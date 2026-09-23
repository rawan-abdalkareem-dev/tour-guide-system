// lib/providres/font_size_provider.dart
import 'package:flutter/material.dart';
import '../core/storage/preferences_service.dart';

/// Provider dedicated exclusively to font sizing and global text scaling.
/// Decoupled from user state so changing font size only rebuilds the TextScaler.
class FontSizeProvider extends ChangeNotifier {
  static const double minFontSize = 12.0;
  static const double maxFontSize = 24.0;
  static const double defaultFontSize = 16.0;

  double _fontSize;

  FontSizeProvider() : _fontSize = PreferencesService.fontSize {
    // Clamp to valid range if loaded with an unexpected value
    _fontSize = _fontSize.clamp(minFontSize, maxFontSize);
  }

  /// Current base font size in pixels (default: 16.0)
  double get fontSize => _fontSize;

  /// Normalized scaling factor for MaterialApp TextScaler (default: 1.0)
  double get scaleFactor => (_fontSize / defaultFontSize).clamp(0.8, 1.4);

  /// Sets the font size and persists it to SharedPreferences
  Future<void> setFontSize(double size) async {
    final clamped = size.clamp(minFontSize, maxFontSize);
    if (_fontSize == clamped) return;

    _fontSize = clamped;
    notifyListeners();
    await PreferencesService.setFontSize(_fontSize);
  }

  /// Increments font size by 1.0 up to [maxFontSize]
  Future<void> increaseFontSize() async {
    if (_fontSize < maxFontSize) {
      await setFontSize(_fontSize + 1.0);
    }
  }

  /// Decrements font size by 1.0 down to [minFontSize]
  Future<void> decreaseFontSize() async {
    if (_fontSize > minFontSize) {
      await setFontSize(_fontSize - 1.0);
    }
  }

  /// Resets the font size to the default 16.0
  Future<void> reset() async {
    await setFontSize(defaultFontSize);
  }
}
