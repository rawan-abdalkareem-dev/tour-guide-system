import '../../core/storage/preferences_service.dart';
import '../../core/storage/sqlite_service.dart';
import '../../models/user_model.dart';

/// Repository managing user authentication, sessions, and profile settings
/// Powered 100% by SQLite Relational Database Engine
class UserRepository {
  const UserRepository();

  /// Whether a user is currently logged in based on preferences
  bool get isLoggedIn => PreferencesService.isLoggedIn;

  /// Current user UID
  String? get currentUid => PreferencesService.currentUserUid;

  /// Current user email
  String? get currentEmail => PreferencesService.currentUserEmail;

  /// Current user display name
  String? get currentName => PreferencesService.currentUserName;

  /// Retrieve the current logged in user from SQLite
  UserModel? getCurrentUser() {
    final uid = currentUid;
    if (uid == null || !isLoggedIn) return null;
    final map = SQLiteService.getUserById(uid);
    if (map != null) {
      return UserModel.fromMap(map);
    }
    return null;
  }

  /// Look up user by UID
  UserModel? getUserById(String uid) {
    final map = SQLiteService.getUserById(uid);
    return map != null ? UserModel.fromMap(map) : null;
  }

  /// Look up user by email
  UserModel? getUserByEmail(String email) {
    final map = SQLiteService.getUserByEmail(email);
    return map != null ? UserModel.fromMap(map) : null;
  }

  /// Sign in with email and password
  Future<UserModel?> signIn(String email, String password) async {
    final userMap = SQLiteService.getUserByEmail(email);
    if (userMap == null) return null;

    final storedPassword = userMap['password'] as String?;
    final hashedInput = SQLiteService.hashPassword(password);

    // Support both hashed password and legacy plaintext password for safety
    if (storedPassword == hashedInput || storedPassword == password) {
      final user = UserModel.fromMap(userMap);
      await PreferencesService.setLoggedIn(true);
      await PreferencesService.setCurrentUserUid(user.uid);
      await PreferencesService.setCurrentUserEmail(user.email);
      await PreferencesService.setCurrentUserName(user.name);
      return user;
    }

    return null;
  }

  /// Sign up a new user
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final newUserMap = {
      'uid': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': name.trim(),
      'email': email.trim(),
      'password': SQLiteService.hashPassword(password),
      'createdAt': DateTime.now().toIso8601String(),
      'favorites': <String>[],
      'bookings': <Map<String, dynamic>>[],
      'settings': {
        'darkMode': false,
        'notifications': true,
        'location': true,
        'vibration': true,
        'autoSave': true,
        'language': 'ar',
        'currency': 'ل.س',
        'themeColor': 'أزرق',
        'mapType': 'عادي',
        'fontSize': 16.0,
      },
    };

    await SQLiteService.saveUser(newUserMap);

    final user = UserModel.fromMap(newUserMap);
    await PreferencesService.setLoggedIn(true);
    await PreferencesService.setCurrentUserUid(user.uid);
    await PreferencesService.setCurrentUserEmail(user.email);
    await PreferencesService.setCurrentUserName(user.name);

    return user;
  }

  /// Sign out current user
  Future<void> signOut() async {
    await PreferencesService.clearAuth();
  }

  /// Save updated user model to SQLite
  Future<void> saveUser(UserModel user) async {
    final existing = SQLiteService.getUserById(user.uid);
    final map = user.toMap();
    if (existing != null && existing['password'] != null) {
      map['password'] = existing['password'];
    }
    await SQLiteService.saveUser(map);
  }

  /// Get app settings (from user record if logged in, otherwise from preferences)
  Map<String, dynamic> getSettings(UserModel? currentUser) {
    if (currentUser == null) {
      return {
        'darkMode': PreferencesService.darkMode,
        'notifications': PreferencesService.notifications,
        'location': PreferencesService.location,
        'vibration': PreferencesService.vibration,
        'autoSave': PreferencesService.autoSave,
        'language': PreferencesService.language,
        'currency': PreferencesService.currency,
        'themeColor': PreferencesService.themeColor,
        'mapType': PreferencesService.mapType,
        'fontSize': PreferencesService.fontSize,
      };
    }
    return Map<String, dynamic>.from(currentUser.settings);
  }

  /// Save app settings to preferences and user record
  Future<bool> saveSettings(
    Map<String, dynamic> settings, {
    UserModel? currentUser,
  }) async {
    try {
      if (settings.containsKey('darkMode')) {
        await PreferencesService.setDarkMode(settings['darkMode'] as bool);
      }
      if (settings.containsKey('notifications')) {
        await PreferencesService.setNotifications(
            settings['notifications'] as bool);
      }
      if (settings.containsKey('location')) {
        await PreferencesService.setLocation(settings['location'] as bool);
      }
      if (settings.containsKey('vibration')) {
        await PreferencesService.setVibration(settings['vibration'] as bool);
      }
      if (settings.containsKey('autoSave')) {
        await PreferencesService.setAutoSave(settings['autoSave'] as bool);
      }
      if (settings.containsKey('language')) {
        await PreferencesService.setLanguage(settings['language'] as String);
      }
      if (settings.containsKey('currency')) {
        await PreferencesService.setCurrency(settings['currency'] as String);
      }
      if (settings.containsKey('mapType')) {
        await PreferencesService.setMapType(settings['mapType'] as String);
      }
      if (settings.containsKey('themeColor')) {
        await PreferencesService.setThemeColor(settings['themeColor'] as String);
      }
      if (settings.containsKey('fontSize')) {
        await PreferencesService.setFontSize(
            (settings['fontSize'] as num).toDouble());
      }

      if (currentUser != null) {
        final updated = currentUser.copyWith(settings: settings);
        await saveUser(updated);
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}
