// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../core/constants/admin_config.dart';
import '../core/storage/preferences_service.dart';
import '../core/storage/sqlite_service.dart';
import '../data/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // ============= Getters =============
  Map<String, dynamic>? get userData => _userData;

  UserModel? get currentUser =>
      _userData != null ? UserModel.fromMap(_userData!) : null;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _isLoggedIn;

  String get userName =>
      _userData?['name'] ?? _repository.currentName ?? 'زائر';

  String get userEmail => _userData?['email'] ?? _repository.currentEmail ?? '';

  /// Check if the currently signed in user has admin permissions
  bool get isAdmin => AdminConfig.isAdmin(userEmail);

  UserProvider({UserRepository? repository})
      : _repository = repository ?? const UserRepository() {
    _initFromStorage();
  }

  /// Initialize user session from repository
  Future<void> _initFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_repository.isLoggedIn && _repository.currentUid != null) {
        final user = _repository.getCurrentUser();
        if (user != null) {
          _userData = user.toMap();
          _isLoggedIn = true;
        } else {
          await _repository.signOut();
          _isLoggedIn = false;
        }
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      _errorMessage = 'خطأ في استرجاع جلسة المستخدم: $e';
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============= المصادقة =============

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final user = await _repository.signIn(email, password);
      if (user != null) {
        _userData = user.toMap();
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تسجيل الدخول: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final existingUser = _repository.getUserByEmail(email);
      if (existingUser != null) {
        _errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
        _errorMessage = 'يرجى ملء جميع الحقول';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newUser = await _repository.signUp(
        name: name,
        email: email,
        password: password,
      );

      _userData = newUser.toMap();
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء إنشاء الحساب: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.signOut();
      _userData = null;
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'خطأ أثناء تسجيل الخروج: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() => signOut();

  Future<void> loadUserData(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _repository.getUserById(uid);
      if (user != null) {
        _userData = user.toMap();
        _isLoggedIn = true;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'خطأ في تحميل بيانات المستخدم: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============= الإعدادات =============

  Map<String, dynamic> getSettings() {
    return _repository.getSettings(currentUser);
  }

  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final success = await _repository.saveSettings(
        settings,
        currentUser: currentUser,
      );

      if (success && _userData != null) {
        _userData!['settings'] = settings;
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = 'خطأ في حفظ الإعدادات: $e';
      return false;
    }
  }

  // ============= المفضلة =============

  List<String> getFavorites() {
    if (_userData == null) return SQLiteService.getUserFavoriteIds('guest');
    final list = _userData!['favorites'];
    if (list is List) {
      return List<String>.from(list);
    }
    return SQLiteService.getUserFavoriteIds('guest');
  }

  bool isFavorite(String placeId) {
    if (_userData == null) return SQLiteService.isUserFavorite('guest', placeId);
    final favs = getFavorites();
    return favs.contains(placeId);
  }

  Future<void> addFavorite(String placeId) async {
    await SQLiteService.addUserFavorite('guest', placeId);
    if (_userData != null) {
      final favs = getFavorites();
      if (!favs.contains(placeId)) {
        favs.add(placeId);
        _userData!['favorites'] = favs;
        await _repository.saveUser(UserModel.fromMap(_userData!));
      }
    }
    notifyListeners();
  }

  Future<void> removeFavorite(String placeId) async {
    await SQLiteService.removeUserFavorite('guest', placeId);
    if (_userData != null) {
      final favs = getFavorites();
      favs.removeWhere((id) => id == placeId);
      _userData!['favorites'] = favs;
      await _repository.saveUser(UserModel.fromMap(_userData!));
    }
    notifyListeners();
  }

  // ============= الحجوزات =============

  List<Map<String, dynamic>> getBookings() {
    if (_userData == null) return [];
    final list = _userData!['bookings'];
    if (list is List) {
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<void> addBooking(Map<String, dynamic> booking) async {
    if (_userData == null) return;
    final list = getBookings();
    list.insert(0, booking);
    _userData!['bookings'] = list;
    await _repository.saveUser(UserModel.fromMap(_userData!));
    notifyListeners();
  }

  Future<void> removeBooking(String bookingId) async {
    if (_userData == null) return;
    final list = getBookings();
    list.removeWhere((b) => b['id'] == bookingId);
    _userData!['bookings'] = list;
    await _repository.saveUser(UserModel.fromMap(_userData!));
    notifyListeners();
  }

  // ============= دوال مساعدة للتجربة =============

  Future<void> addTestUser(String name, String email, String password) async {
    await _repository.signUp(
      name: name,
      email: email,
      password: password,
    );
    notifyListeners();
  }

  List<Map<String, dynamic>> getRegisteredUsers() {
    return SQLiteService.getAllUsers().map((u) {
      return {
        'name': u['name'],
        'email': u['email'],
      };
    }).toList();
  }

  // ============= إعادة ضبط البيانات =============

  Future<void> resetAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _repository.getUserByEmail('ahmed@example.com');
      if (user != null) {
        _userData = user.toMap();
        _isLoggedIn = true;
        await PreferencesService.setLoggedIn(true);
        await PreferencesService.setCurrentUserUid(user.uid);
        await PreferencesService.setCurrentUserEmail(user.email);
        await PreferencesService.setCurrentUserName(user.name);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'خطأ في إعادة الضبط: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.signOut();
      _userData = null;
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'خطأ في مسح البيانات: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
