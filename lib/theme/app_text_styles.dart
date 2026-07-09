import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resq_meal/theme/app_colors.dart';

/// Typography built on Plus Jakarta Sans for a clean, modern feel.
abstract final class AppTextStyles {
  static TextStyle get _base => GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
        height: 1.35,
      );

  static TextStyle get displayLarge =>
      _base.copyWith(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2);

  static TextStyle get displayMedium =>
      _base.copyWith(fontSize: 28, fontWeight: FontWeight.w700, height: 1.25);

  static TextStyle get headlineLarge =>
      _base.copyWith(fontSize: 24, fontWeight: FontWeight.w700);

  static TextStyle get headlineMedium =>
      _base.copyWith(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get titleLarge =>
      _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get titleMedium =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium =>
      _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall =>
      _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelLarge =>
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get labelMedium =>
      _base.copyWith(fontSize: 12, fontWeight: FontWeight.w600);

  static TextStyle get button =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white);
}
