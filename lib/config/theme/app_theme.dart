import 'package:flutter/material.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1B7A3F);
  static const Color primaryColorLight = Color(0xFF2E9E57);
  static const Color primaryColorDark = Color(0xFF0D4620);

  static const Color secondaryColor = Color(0xFFC9934D);
  static const Color secondaryColorLight = Color(0xFFE5C494);
  static const Color secondaryColorDark = Color(0xFFAB7530);

  static const Color backgroundColor = Color(0xFFF8F6F2);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB3261E);

  static const Color darkBackgroundColor = Color(0xFF0E1512);
  static const Color darkSurfaceColor = Color(0xFF1A2420);
  static const Color darkSurfaceVariant = Color(0xFF243028);

  static const Color textColorDark = Color(0xFF1A1A1A);
  static const Color textColorLight = Color(0xFFFFFFFF);
  static const Color textColorSecondary = Color(0xFF6B7280);
  static const Color textColorSecondaryDark = Color(0xFFB0BEC5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      surface: surfaceColor,
      onSurface: textColorDark,
      surfaceContainerHighest: Color(0xFFF0EDE7),
      error: errorColor,
      outline: Color(0xFFD4CFC8),
    ),
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: AppConstants.arabicFontName,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textColorDark,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEBE7E0), width: 1),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF0EDE7),
      selectedColor: primaryColor,
      labelStyle: const TextStyle(
        fontFamily: AppConstants.arabicFontName,
        fontSize: 13,
        color: textColorDark,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: AppConstants.arabicFontName,
        fontSize: 13,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F2ED),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDDD9D2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDDD9D2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEBE7E0),
      thickness: 1,
      space: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColorLight,
      onPrimary: Colors.white,
      secondary: secondaryColorLight,
      onSecondary: darkBackgroundColor,
      surface: darkSurfaceColor,
      onSurface: textColorLight,
      surfaceContainerHighest: darkSurfaceVariant,
      error: errorColor,
      outline: Color(0xFF3A4840),
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    fontFamily: AppConstants.arabicFontName,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: textColorLight,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: darkSurfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF2E3F38), width: 1),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF243028),
      selectedColor: primaryColorLight,
      labelStyle: const TextStyle(
        fontFamily: AppConstants.arabicFontName,
        fontSize: 13,
        color: textColorLight,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: AppConstants.arabicFontName,
        fontSize: 13,
        color: darkBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3A4840)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3A4840)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryColorLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorLight,
        foregroundColor: darkBackgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColorLight,
        foregroundColor: darkBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColorLight,
        side: const BorderSide(color: primaryColorLight),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2E3F38),
      thickness: 1,
      space: 1,
    ),
  );

  static TextTheme _buildTextTheme({required bool isLight}) {
    final textColor = isLight ? textColorDark : textColorLight;
    final secondaryTextColor = isLight ? textColorSecondary : textColorSecondaryDark;

    TextStyle style({
      required double fontSize,
      required FontWeight fontWeight,
      required Color color,
      double? height,
    }) {
      return TextStyle(
        fontFamily: AppConstants.arabicFontName,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      );
    }

    return TextTheme(
      displayLarge: style(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      displayMedium: style(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
      displaySmall: style(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      headlineLarge: style(fontSize: 22, fontWeight: FontWeight.w700, color: textColor),
      headlineMedium: style(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
      headlineSmall: style(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: style(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
      titleMedium: style(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
      titleSmall: style(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      bodyLarge: style(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
      bodyMedium: style(fontSize: 14, fontWeight: FontWeight.w400, color: textColor),
      bodySmall: style(fontSize: 12, fontWeight: FontWeight.w400, color: secondaryTextColor),
      labelLarge: style(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
      labelMedium: style(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
      labelSmall: style(fontSize: 11, fontWeight: FontWeight.w400, color: secondaryTextColor),
    );
  }
}
