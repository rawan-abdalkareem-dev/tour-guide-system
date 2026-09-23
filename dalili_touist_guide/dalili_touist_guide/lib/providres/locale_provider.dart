// lib/providres/locale_provider.dart
import 'package:flutter/material.dart';
import '../core/storage/preferences_service.dart';

/// Provider dedicated to application language & locale (Arabic / English).
/// Decoupled from user state so language changes rebuild MaterialApp dynamically.
class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  LocaleProvider() : _locale = Locale(PreferencesService.language);

  /// Current active locale
  Locale get locale => _locale;

  /// Current active language code ('ar' or 'en')
  String get languageCode => _locale.languageCode;

  /// Whether current locale is Arabic
  bool get isArabic => _locale.languageCode == 'ar';

  /// Whether current locale is English
  bool get isEnglish => _locale.languageCode == 'en';

  /// Sets the application locale and persists it to SharedPreferences
  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
    await PreferencesService.setLanguage(newLocale.languageCode);
  }

  /// Sets locale by language code string ('ar' or 'en')
  Future<void> setLanguageCode(String code) async {
    if (code != 'ar' && code != 'en') return;
    await setLocale(Locale(code));
  }

  /// Resets locale to default (Arabic)
  Future<void> reset() async {
    await setLocale(const Locale('ar'));
  }
}
