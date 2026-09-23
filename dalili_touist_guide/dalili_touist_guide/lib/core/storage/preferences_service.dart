import 'package:shared_preferences/shared_preferences.dart';

/// Central wrapper for SharedPreferences
class PreferencesService {
  PreferencesService._();

  static late SharedPreferences _prefs;

  // Keys
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyCurrentUserUid = 'current_user_uid';
  static const String _keyCurrentUserEmail = 'current_user_email';
  static const String _keyCurrentUserName = 'current_user_name';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyNotifications = 'notifications';
  static const String _keyLanguage = 'language';
  static const String _keyFontSize = 'font_size';
  static const String _keyVibration = 'vibration';
  static const String _keyCurrency = 'currency';
  static const String _keyMapType = 'map_type';
  static const String _keyThemeColor = 'theme_color';
  static const String _keyLocation = 'location';
  static const String _keyAutoSave = 'auto_save';
  static const String _keyAppRating = 'app_rating';

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============= Auth State =============

  static bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;

  static Future<bool> setLoggedIn(bool value) =>
      _prefs.setBool(_keyIsLoggedIn, value);

  static String? get currentUserUid => _prefs.getString(_keyCurrentUserUid);

  static Future<bool> setCurrentUserUid(String? uid) {
    if (uid == null) {
      return _prefs.remove(_keyCurrentUserUid);
    }
    return _prefs.setString(_keyCurrentUserUid, uid);
  }

  static String? get currentUserEmail => _prefs.getString(_keyCurrentUserEmail);

  static Future<bool> setCurrentUserEmail(String? email) {
    if (email == null) {
      return _prefs.remove(_keyCurrentUserEmail);
    }
    return _prefs.setString(_keyCurrentUserEmail, email);
  }

  static String? get currentUserName => _prefs.getString(_keyCurrentUserName);

  static Future<bool> setCurrentUserName(String? name) {
    if (name == null) {
      return _prefs.remove(_keyCurrentUserName);
    }
    return _prefs.setString(_keyCurrentUserName, name);
  }

  static Future<void> clearAuth() async {
    await _prefs.setBool(_keyIsLoggedIn, false);
    await _prefs.remove(_keyCurrentUserUid);
    await _prefs.remove(_keyCurrentUserEmail);
    await _prefs.remove(_keyCurrentUserName);
  }

  // ============= Settings =============

  static bool get darkMode => _prefs.getBool(_keyDarkMode) ?? false;

  static Future<bool> setDarkMode(bool value) =>
      _prefs.setBool(_keyDarkMode, value);

  static bool get notifications => _prefs.getBool(_keyNotifications) ?? true;

  static Future<bool> setNotifications(bool value) =>
      _prefs.setBool(_keyNotifications, value);

  static String get language => _prefs.getString(_keyLanguage) ?? 'ar';

  static Future<bool> setLanguage(String value) =>
      _prefs.setString(_keyLanguage, value);

  static double get fontSize => _prefs.getDouble(_keyFontSize) ?? 16.0;

  static Future<bool> setFontSize(double value) =>
      _prefs.setDouble(_keyFontSize, value);

  static bool get vibration => _prefs.getBool(_keyVibration) ?? true;

  static Future<bool> setVibration(bool value) =>
      _prefs.setBool(_keyVibration, value);

  static String get currency => _prefs.getString(_keyCurrency) ?? 'ل.س';

  static Future<bool> setCurrency(String value) =>
      _prefs.setString(_keyCurrency, value);

  static String get mapType => _prefs.getString(_keyMapType) ?? 'عادي';

  static Future<bool> setMapType(String value) =>
      _prefs.setString(_keyMapType, value);

  static String get themeColor => _prefs.getString(_keyThemeColor) ?? 'أزرق';

  static Future<bool> setThemeColor(String value) =>
      _prefs.setString(_keyThemeColor, value);

  static bool get location => _prefs.getBool(_keyLocation) ?? true;

  static Future<bool> setLocation(bool value) =>
      _prefs.setBool(_keyLocation, value);

  static bool get autoSave => _prefs.getBool(_keyAutoSave) ?? true;

  static Future<bool> setAutoSave(bool value) =>
      _prefs.setBool(_keyAutoSave, value);

  static int get appRating => _prefs.getInt(_keyAppRating) ?? 5;

  static Future<bool> setAppRating(int value) =>
      _prefs.setInt(_keyAppRating, value);

  // ============= Generic Helpers =============

  static String? getString(String key, [String? defaultValue]) =>
      _prefs.getString(key) ?? defaultValue;

  static Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  static bool getBool(String key, [bool defaultValue = false]) =>
      _prefs.getBool(key) ?? defaultValue;

  static Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  static double getDouble(String key, [double defaultValue = 0.0]) =>
      _prefs.getDouble(key) ?? defaultValue;

  static Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);
}
