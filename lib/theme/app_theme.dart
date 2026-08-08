import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light + dark ThemeData mirroring the Figma design system.
abstract class AppTheme {
  static const String fontFamily = 'Inter';

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.bg;
    final card = isDark ? AppColors.darkCard : AppColors.white;
    final input = isDark ? AppColors.darkInput : AppColors.track;
    final primaryText = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final secondaryText = isDark ? AppColors.darkLabel : AppColors.muted;
    final divider = isDark ? AppColors.darkDivider : AppColors.divider;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.violet,
        brightness: brightness,
        primary: AppColors.violet,
        surface: card,
        onSurface: primaryText,
      ),
      scaffoldBackgroundColor: bg,
      fontFamily: fontFamily,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: primaryText,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryText,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: secondaryText,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: secondaryText,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: secondaryText,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: primaryText,
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: input,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(fontSize: 14, color: secondaryText),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.violet,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.violet
              : (isDark ? AppColors.darkLabel : AppColors.muted),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.buttonTint
              : (isDark ? AppColors.darkInput : AppColors.track),
        ),
      ),
      splashColor: AppColors.violet.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
    );
  }
}
