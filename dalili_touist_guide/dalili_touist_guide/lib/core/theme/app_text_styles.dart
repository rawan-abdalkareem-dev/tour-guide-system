import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// App typography using GoogleFonts Cairo
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headingLarge => GoogleFonts.cairo(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingMedium => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingSmall => GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textMuted,
      );

  static TextStyle get button => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get caption => GoogleFonts.cairo(
        fontSize: 11,
        color: AppColors.textMuted,
      );
}
