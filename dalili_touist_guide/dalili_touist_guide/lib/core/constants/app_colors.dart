import 'package:flutter/material.dart';

/// Central color palette for the app
class AppColors {
  AppColors._();

  // Primary palette (Deep Blue)
  static const Color primary = Color(0xFF0D47A1);
  static const Color primaryDark = Color(0xFF002171);
  static const Color primaryLight = Color(0xFF5472D3);

  // Secondary palette (Warm Amber / Gold)
  static const Color secondary = Color(0xFFFFB300);
  static const Color secondaryDark = Color(0xFFC68400);
  static const Color secondaryLight = Color(0xFFFFE54C);

  // Accent & Actions
  static const Color accent = Color(0xFFFF6F00);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF8FAFC);

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textLight = Colors.white;

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEEF2F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFF0D47A1),
      Color(0xFF1976D2),
    ],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xCC000000),
    ],
  );

  // Light mode background gradient (Signature Syrian Damascus Royal Blue)
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D47A1),
      Color(0xFF1A237E),
      Color(0xFF0D47A1),
    ],
  );

  // Dark mode background gradient (Sleek Midnight Obsidian Slate)
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF070B14),
      Color(0xFF0F172A),
      Color(0xFF070B14),
    ],
  );

  /// Returns the appropriate background gradient based on theme brightness
  static LinearGradient backgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkBackgroundGradient : lightBackgroundGradient;
  }

  /// Returns the appropriate scaffold / header background color
  static Color getAppBarColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF0F172A) : const Color(0xFF0D47A1);
  }

  /// Returns the appropriate card / container background color
  static Color getCardColor(
    BuildContext context, {
    double lightAlpha = 0.12,
    double darkAlpha = 0.85,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF1E293B).withValues(alpha: darkAlpha)
        : Colors.white.withValues(alpha: lightAlpha);
  }

  /// Returns the appropriate border color for cards and inputs
  static Color getCardBorderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF334155).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.15);
  }

  /// Bottom navigation bar gradient
  static LinearGradient navBarGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return LinearGradient(
        colors: [
          const Color(0xFF070B14).withValues(alpha: 0.98),
          const Color(0xFF0F172A).withValues(alpha: 0.98),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return LinearGradient(
      colors: [
        const Color(0xFF0D47A1).withValues(alpha: 0.98),
        const Color(0xFF1A237E).withValues(alpha: 0.98),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
