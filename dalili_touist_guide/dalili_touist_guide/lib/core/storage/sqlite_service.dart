import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../../data/app_initial_data.dart';
import '../../models/booking_model.dart';
import '../../models/category.dart';
import '../../models/place.dart';
import '../../models/user_model.dart';

/// Central SQLite Relational Database Service
/// Manages the 6 core relational tables, foreign key constraints,
/// cascading operations, and automated seed synchronization.
class SQLiteService {
  SQLiteService._();

  static const String _dbName = 'dalili_tourist_guide.db';
  static const int _dbVersion = 1;

  static Database? _database;

  // In-memory runtime cache for instantaneous zero-latency UI reads
  static List<Category> _cachedCategories = [];
  static List<Place> _cachedPlaces = [];
  static List<Booking> _cachedBookings = [];
  static final Map<String, List<String>> _cachedFavorites = {};
  static final Map<String, Map<String, dynamic>> _cachedUsers = {};

  /// Access the active SQLite Database instance
  static Database get database {
    if (_database == null) {
      throw StateError('SQLiteService has not been initialized. Call SQLiteService.init() first.');
    }
    return _database!;
  }

  /// Initialize SQLite database, create tables, seed data, and hydrate memory cache
  static Future<void> init() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWebNoWebWorker;
    }

    final databasesPath = await getDatabasesPath();
    final dbPath = p.join(databasesPath, _dbName);

    _database = await openDatabase(
      dbPath,
      version: _dbVersion,
      onConfigure: (db) async {
        // Enforce SQLite Foreign Key Referential Integrity
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        await _createSchema(db);
        await _seedAllInitialData(db);
      },
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );

    // Hydrate in-memory caches from SQLite tables
    await _hydrateCache();
  }

  /// Execute DDL statements for the 6 relational tables
  static Future<void> _createSchema(Database db) async {
    // 1. Categories Table (1:N with places)
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name_ar TEXT NOT NULL,
        name_en TEXT NOT NULL,
        emoji TEXT
      );
    ''');

    // 2. Places Table
    await db.execute('''
      CREATE TABLE places (
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        name_ar TEXT NOT NULL,
        name_en TEXT,
        city TEXT NOT NULL,
        description TEXT,
        main_image_url TEXT NOT NULL,
        price_level TEXT DEFAULT 'متوسط',
        rating REAL DEFAULT 4.5,
        reviews_count INTEGER DEFAULT 1,
        phone TEXT,
        opening_hours TEXT,
        website TEXT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT
      );
    ''');

    // 3. Place Images Gallery Table (1:N with places - CASCADE DELETE)
    await db.execute('''
      CREATE TABLE place_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        place_id TEXT NOT NULL,
        image_url TEXT NOT NULL,
        display_order INTEGER DEFAULT 0,
        FOREIGN KEY (place_id) REFERENCES places (id) ON DELETE CASCADE
      );
    ''');

    // 4. Users Table (1:N with bookings, N:M with favorites)
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        phone TEXT,
        role TEXT DEFAULT 'user',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        settings_json TEXT
      );
    ''');

    // 5. User Favorites Junction Table (N:M relation with composite key)
    await db.execute('''
      CREATE TABLE user_favorites (
        user_id TEXT NOT NULL,
        place_id TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (user_id, place_id),
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (place_id) REFERENCES places (id) ON DELETE CASCADE
      );
    ''');

    // 6. Bookings Table (1:N with users & places)
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        place_id TEXT,
        visitor_name TEXT NOT NULL,
        visitor_phone TEXT NOT NULL,
        visit_date TEXT NOT NULL,
        visit_time TEXT NOT NULL,
        number_of_people INTEGER DEFAULT 1,
        notes TEXT,
        status TEXT DEFAULT 'pending',
        total_price REAL DEFAULT 0.0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
        FOREIGN KEY (place_id) REFERENCES places (id) ON DELETE RESTRICT
      );
    ''');
  }

  /// Bootstrap initial seed records into SQLite tables
  static Future<void> _seedAllInitialData(Database db) async {
    // 1. Seed Categories
    final categories = AppInitialData.getInitialCategories();
    final categoryNameToId = <String, String>{};
    for (var cat in categories) {
      categoryNameToId[cat.name] = cat.id;
      await db.insert('categories', {
        'id': cat.id,
        'name_ar': cat.name,
        'name_en': cat.nameEn,
        'emoji': cat.emoji,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // 2. Seed Places & Gallery Images
    final rawPlaces = AppInitialData.getInitialRawPlaces();
    for (var p in rawPlaces) {
      final placeId = p['id']?.toString() ?? '';
      final categoryName = p['category']?.toString() ?? '';
      final categoryId = categoryNameToId[categoryName] ?? 'c1';

      await db.insert('places', {
        'id': placeId,
        'category_id': categoryId,
        'name_ar': p['name']?.toString() ?? '',
        'name_en': p['nameEn']?.toString() ?? '',
        'city': p['location']?.toString() ?? '',
        'description': p['description']?.toString() ?? '',
        'main_image_url': p['image']?.toString() ?? '',
        'price_level': p['price']?.toString() ?? 'متوسط',
        'rating': (p['rating'] as num?)?.toDouble() ?? 4.5,
        'reviews_count': (p['reviews'] as num?)?.toInt() ?? 1,
        'phone': p['phone']?.toString() ?? '',
        'opening_hours': p['openingHours']?.toString() ?? '',
        'website': p['website']?.toString() ?? '',
        'latitude': (p['latitude'] as num?)?.toDouble() ?? 0.0,
        'longitude': (p['longitude'] as num?)?.toDouble() ?? 0.0,
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      // Seed Gallery Images
      final images = (p['images'] as List?)?.map((e) => e.toString()).toList() ?? [];
      for (int i = 0; i < images.length; i++) {
        await db.insert('place_images', {
          'place_id': placeId,
          'image_url': images[i],
          'display_order': i,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    // 3. Seed Users
    final users = AppInitialData.getInitialUsers();
    for (var u in users) {
      await db.insert('users', {
        'id': u['uid']?.toString() ?? '',
        'name': u['name']?.toString() ?? '',
        'email': u['email']?.toString() ?? '',
        'password_hash': u['password']?.toString() ?? '',
        'phone': u['phone']?.toString() ?? '',
        'role': u['role']?.toString() ?? 'user',
        'created_at': u['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
        'settings_json': jsonEncode(u['settings'] ?? {}),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // 4. Seed Bookings
    final bookings = AppInitialData.getInitialBookings();
    for (var b in bookings) {
      await db.insert('bookings', {
        'id': b.id,
        'user_id': b.userId,
        'place_id': b.placeId.isNotEmpty ? b.placeId : 'r3',
        'visitor_name': b.placeName,
        'visitor_phone': b.phoneNumber,
        'visit_date': b.visitDate.toIso8601String(),
        'visit_time': '12:00 PM',
        'number_of_people': b.numberOfPeople,
        'notes': b.notes,
        'status': b.status,
        'total_price': b.totalPrice,
        'created_at': b.bookingDate.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // 5. Seed Favorites
    final favMap = AppInitialData.getInitialFavorites();
    for (var entry in favMap.entries) {
      final userId = entry.key;
      for (var placeId in entry.value) {
        // If guest, create guest placeholder or map safely
        if (userId != 'guest') {
          await db.insert('user_favorites', {
            'user_id': userId,
            'place_id': placeId,
            'created_at': DateTime.now().toIso8601String(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
    }
  }

  /// Hydrate in-memory memory models directly from SQLite tables
  static Future<void> _hydrateCache() async {
    final db = database;

    // Load Categories
    final catRows = await db.query('categories', orderBy: 'id ASC');
    _cachedCategories = catRows.map((r) {
      return Category(
        id: r['id'] as String,
        name: r['name_ar'] as String,
        nameEn: r['name_en'] as String? ?? '',
        emoji: r['emoji'] as String? ?? '📍',
      );
    }).toList();

    // Load Places with JOIN to Categories and Place Images
    final placeRows = await db.rawQuery('''
      SELECT p.*, c.name_ar as cat_name_ar, c.name_en as cat_name_en
      FROM places p
      LEFT JOIN categories c ON p.category_id = c.id
      ORDER BY p.id ASC
    ''');

    final imageRows = await db.query('place_images', orderBy: 'place_id, display_order ASC');
    final imagesByPlace = <String, List<String>>{};
    for (var img in imageRows) {
      final pid = img['place_id'] as String;
      final url = img['image_url'] as String;
      imagesByPlace.putIfAbsent(pid, () => []).add(url);
    }

    _cachedPlaces = placeRows.map((r) {
      final id = r['id'] as String;
      return Place(
        id: id,
        name: r['name_ar'] as String,
        nameEn: r['name_en'] as String? ?? '',
        description: r['description'] as String? ?? '',
        image: r['main_image_url'] as String,
        rating: (r['rating'] as num?)?.toDouble() ?? 4.5,
        category: r['cat_name_ar'] as String? ?? '',
        categoryEn: r['cat_name_en'] as String? ?? '',
        location: r['city'] as String,
        latitude: (r['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (r['longitude'] as num?)?.toDouble() ?? 0.0,
        openingHours: r['opening_hours'] as String? ?? '',
        phone: r['phone'] as String? ?? '',
        website: r['website'] as String? ?? '',
        price: r['price_level'] as String? ?? 'متوسط',
        reviews: (r['reviews_count'] as num?)?.toInt() ?? 1,
        images: imagesByPlace[id] ?? [],
      );
    }).toList();

    // Load Bookings with JOIN to Places and Users
    final bookingRows = await db.rawQuery('''
      SELECT b.*, p.name_ar as place_name, p.main_image_url as place_image, p.city as place_city, u.email as user_email
      FROM bookings b
      LEFT JOIN places p ON b.place_id = p.id
      LEFT JOIN users u ON b.user_id = u.id
      ORDER BY b.created_at DESC
    ''');

    _cachedBookings = bookingRows.map((r) {
      return Booking(
        id: r['id'] as String,
        userId: r['user_id'] as String? ?? '',
        placeId: r['place_id'] as String? ?? '',
        placeName: r['place_name'] as String? ?? r['visitor_name'] as String,
        placeImage: r['place_image'] as String? ?? '',
        placeLocation: r['place_city'] as String? ?? '',
        bookingDate: DateTime.tryParse(r['created_at']?.toString() ?? '') ?? DateTime.now(),
        visitDate: DateTime.tryParse(r['visit_date']?.toString() ?? '') ?? DateTime.now(),
        numberOfPeople: (r['number_of_people'] as num?)?.toInt() ?? 1,
        totalPrice: (r['total_price'] as num?)?.toDouble() ?? 0.0,
        status: r['status'] as String? ?? 'pending',
        notes: r['notes'] as String? ?? '',
        phoneNumber: r['visitor_phone'] as String? ?? '',
        email: r['user_email'] as String? ?? '',
      );
    }).toList();

    // Load Users
    final userRows = await db.query('users');
    _cachedUsers.clear();
    for (var u in userRows) {
      final uid = u['id'] as String;
      Map<String, dynamic> settings = {};
      try {
        if (u['settings_json'] != null) {
          settings = Map<String, dynamic>.from(jsonDecode(u['settings_json'] as String));
        }
      } catch (_) {}

      _cachedUsers[uid] = {
        'uid': uid,
        'name': u['name'] as String,
        'email': u['email'] as String,
        'password': u['password_hash'] as String,
        'role': u['role'] as String? ?? 'user',
        'createdAt': u['created_at'] as String,
        'settings': settings,
      };
    }

    // Load User Favorites
    final favRows = await db.query('user_favorites');
    _cachedFavorites.clear();
    for (var f in favRows) {
      final uid = f['user_id'] as String;
      final pid = f['place_id'] as String;
      _cachedFavorites.putIfAbsent(uid, () => []).add(pid);
    }
    // Maintain guest favorites
    if (!_cachedFavorites.containsKey('guest')) {
      _cachedFavorites['guest'] = ['r1'];
    }
  }

  // ==========================================
  // Categories Operations
  // ==========================================

  static List<Category> getCategories() => List<Category>.from(_cachedCategories);

  static Future<void> saveCategory(Category category) async {
    final db = database;
    await db.insert('categories', {
      'id': category.id,
      'name_ar': category.name,
      'name_en': category.nameEn,
      'emoji': category.emoji,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    _cachedCategories.removeWhere((c) => c.id == category.id);
    _cachedCategories.add(category);
  }

  static Future<void> deleteCategory(String id) async {
    final db = database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    _cachedCategories.removeWhere((c) => c.id == id);
  }

  // ==========================================
  // Places Operations
  // ==========================================

  static List<Place> getPlaces() => List<Place>.from(_cachedPlaces);

  static List<Map<String, dynamic>> getAllPlaces() {
    return _cachedPlaces.map((p) => p.toMap()).toList();
  }

  static Place? getPlaceById(String id) {
    try {
      return _cachedPlaces.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<void> savePlace(Place place) async {
    final db = database;

    // Resolve categoryId
    String categoryId = 'c1';
    final matchedCat = _cachedCategories.where((c) => c.name == place.category);
    if (matchedCat.isNotEmpty) {
      categoryId = matchedCat.first.id;
    }

    await db.insert('places', {
      'id': place.id,
      'category_id': categoryId,
      'name_ar': place.name,
      'name_en': place.nameEn,
      'city': place.location,
      'description': place.description,
      'main_image_url': place.image,
      'price_level': place.price,
      'rating': place.rating,
      'reviews_count': place.reviews,
      'phone': place.phone,
      'opening_hours': place.openingHours,
      'website': place.website,
      'latitude': place.latitude,
      'longitude': place.longitude,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Replace gallery images
    await db.delete('place_images', where: 'place_id = ?', whereArgs: [place.id]);
    for (int i = 0; i < place.images.length; i++) {
      await db.insert('place_images', {
        'place_id': place.id,
        'image_url': place.images[i],
        'display_order': i,
      });
    }

    _cachedPlaces.removeWhere((p) => p.id == place.id);
    _cachedPlaces.add(place);
  }

  static Future<void> deletePlace(String id) async {
    final db = database;
    // Foreign key CASCADE will automatically delete place_images & user_favorites
    await db.delete('places', where: 'id = ?', whereArgs: [id]);
    _cachedPlaces.removeWhere((p) => p.id == id);
  }

  // ==========================================
  // Bookings Operations
  // ==========================================

  static List<Booking> getBookings() => List<Booking>.from(_cachedBookings);

  static List<Booking> getUserBookings(String userId, {String? email}) {
    final trimmedUid = userId.trim();
    final trimmedEmail = email?.trim().toLowerCase();

    return _cachedBookings.where((b) {
      if (trimmedUid.isNotEmpty && b.userId.trim() == trimmedUid) {
        return true;
      }
      if (trimmedEmail != null &&
          trimmedEmail.isNotEmpty &&
          b.email.trim().toLowerCase() == trimmedEmail) {
        return true;
      }
      return false;
    }).toList();
  }

  static Future<void> saveBooking(Booking booking) async {
    final db = database;
    final placeId = booking.placeId.isNotEmpty
        ? booking.placeId
        : (_cachedPlaces.where((p) => p.name == booking.placeName).isNotEmpty
            ? _cachedPlaces.firstWhere((p) => p.name == booking.placeName).id
            : 'r1');

    await db.insert('bookings', {
      'id': booking.id,
      'user_id': booking.userId,
      'place_id': placeId,
      'visitor_name': booking.placeName,
      'visitor_phone': booking.phoneNumber,
      'visit_date': booking.visitDate.toIso8601String(),
      'visit_time': '12:00 PM',
      'number_of_people': booking.numberOfPeople,
      'notes': booking.notes,
      'status': booking.status,
      'total_price': booking.totalPrice,
      'created_at': booking.bookingDate.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    _cachedBookings.removeWhere((b) => b.id == booking.id);
    _cachedBookings.insert(0, booking);
  }

  static Future<void> updateBooking(Booking booking) async {
    await saveBooking(booking);
  }

  static Future<void> deleteBooking(String id) async {
    final db = database;
    await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
    _cachedBookings.removeWhere((b) => b.id == id);
  }

  static Future<void> clearBookings() async {
    final db = database;
    await db.delete('bookings');
    _cachedBookings.clear();
  }

  // ==========================================
  // Favorites Operations
  // ==========================================

  static List<String> getUserFavoriteIds(String userId) {
    final effectiveUid = userId.trim().isEmpty ? 'guest' : userId.trim();
    return List<String>.from(_cachedFavorites[effectiveUid] ?? []);
  }

  static bool isUserFavorite(String userId, String placeId) {
    final list = getUserFavoriteIds(userId);
    return list.contains(placeId);
  }

  static Future<void> addUserFavorite(String userId, String placeId) async {
    final effectiveUid = userId.trim().isEmpty ? 'guest' : userId.trim();
    final db = database;

    if (effectiveUid != 'guest') {
      await db.insert('user_favorites', {
        'user_id': effectiveUid,
        'place_id': placeId,
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    final currentList = _cachedFavorites.putIfAbsent(effectiveUid, () => []);
    if (!currentList.contains(placeId)) {
      currentList.add(placeId);
    }
  }

  static Future<void> removeUserFavorite(String userId, String placeId) async {
    final effectiveUid = userId.trim().isEmpty ? 'guest' : userId.trim();
    final db = database;

    if (effectiveUid != 'guest') {
      await db.delete('user_favorites',
          where: 'user_id = ? AND place_id = ?',
          whereArgs: [effectiveUid, placeId]);
    }

    final currentList = _cachedFavorites[effectiveUid];
    currentList?.remove(placeId);
  }

  static Future<void> clearUserFavorites(String userId) async {
    final effectiveUid = userId.trim().isEmpty ? 'guest' : userId.trim();
    final db = database;

    if (effectiveUid != 'guest') {
      await db.delete('user_favorites', where: 'user_id = ?', whereArgs: [effectiveUid]);
    }

    _cachedFavorites[effectiveUid]?.clear();
  }

  // ==========================================
  // Users Operations
  // ==========================================

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static List<Map<String, dynamic>> getAllUsers() {
    return _cachedUsers.values.toList();
  }

  static Map<String, dynamic>? getUserByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (var u in _cachedUsers.values) {
      if ((u['email'] as String?)?.trim().toLowerCase() == normalized) {
        return Map<String, dynamic>.from(u);
      }
    }
    return null;
  }

  static Map<String, dynamic>? getUserById(String uid) {
    final data = _cachedUsers[uid];
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final uid = user['uid'] as String;
    final db = database;

    await db.insert('users', {
      'id': uid,
      'name': user['name']?.toString() ?? '',
      'email': user['email']?.toString() ?? '',
      'password_hash': user['password']?.toString() ?? '',
      'phone': user['phone']?.toString() ?? '',
      'role': user['role']?.toString() ?? 'user',
      'created_at': user['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      'settings_json': jsonEncode(user['settings'] ?? {}),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    _cachedUsers[uid] = Map<String, dynamic>.from(user);
  }
}
