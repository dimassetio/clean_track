import 'package:flutter/material.dart';

// Define all your colors
class AppColors {
  static const Color primary = Color(0xFFA3D9A5);
  static const Color primaryDark = Color(0xFF8BC68D);
  static const Color primaryLight = Color(0xFFC1E7C2);
  static const Color accent = Color(0xFFA3C9F1);
  static const Color accentDark = Color(0xFF7DB5E6);
  static const Color danger = Color(0xFFF8B9B7);
  static const Color warning = Color(0xFFFFE8A1);
  static const Color success = Color(0xFFA3D9A5);
  static const Color textSecondary = Color(0XFF757575);
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: Color(0XFFF5F5F5),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    onSecondary: Colors.white,
    error: AppColors.danger,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentDark,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ),
  textTheme: TextTheme().copyWith(
    labelLarge: TextTheme().labelLarge?.copyWith(
      color: AppColors.textSecondary,
    ),
    labelMedium: TextTheme().labelMedium?.copyWith(
      color: AppColors.textSecondary,
    ),
    labelSmall: TextTheme().labelSmall?.copyWith(
      color: AppColors.textSecondary,
    ),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryDark,
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryDark,
    secondary: AppColors.accentDark,
    error: AppColors.danger,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.accentDark,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  ),
  textTheme: TextTheme().copyWith(
    labelLarge: TextTheme().labelLarge?.copyWith(
      color: AppColors.textSecondary,
    ),
    labelMedium: TextTheme().labelMedium?.copyWith(
      color: AppColors.textSecondary,
    ),
    labelSmall: TextTheme().labelSmall?.copyWith(
      color: AppColors.textSecondary,
    ),
  ),
);

ThemeData theme(BuildContext context) => Theme.of(context);
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
Color primaryColor(BuildContext context) => Theme.of(context).primaryColor;
