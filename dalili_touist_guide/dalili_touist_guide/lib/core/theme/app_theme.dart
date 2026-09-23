import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Central theme configuration for the application
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme =>
      buildTheme(brightness: Brightness.light, primaryColor: AppColors.primary);

  static ThemeData get darkTheme =>
      buildTheme(brightness: Brightness.dark, primaryColor: AppColors.primary);

  /// Builds a complete Material 3 theme dynamically based on brightness and primary color
  static ThemeData buildTheme({
    required Brightness brightness,
    Color primaryColor = AppColors.primary,
  }) {
    final isDark = brightness == Brightness.dark;
    final baseTextTheme = GoogleFonts.cairoTextTheme();

    final scaffoldBg =
        isDark ? const Color(0xFF0F172A) : AppColors.scaffoldBackground;
    final cardBg = isDark ? const Color(0xFF1E293B) : AppColors.cardBackground;
    final surfaceColor = isDark ? const Color(0xFF1E293B) : AppColors.surface;
    final borderColor = isDark ? const Color(0xFF334155) : AppColors.border;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimary;
    final textMuted =
        isDark ? Colors.white.withValues(alpha: 0.6) : AppColors.textMuted;
    final appBarBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: AppColors.secondary,
        surface: surfaceColor,
        error: AppColors.error,
        brightness: brightness,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appBarBg,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor, width: 1),
        ),
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        contentTextStyle: GoogleFonts.cairo(
          fontSize: 14,
          color: isDark
              ? Colors.white.withValues(alpha: 0.8)
              : AppColors.textSecondary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
