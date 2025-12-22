import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Vibe-based Primary Colors
  static const Color primaryZen = Color(0xFF4A7C59);
  static const Color primaryEnergy = Color(0xFFE8B86D);
  static const Color primaryReflection = Color(0xFF6B73FF);

  static const Color neutralBase = Color(0xFFF8F9FA);
  static const Color surfaceElevation = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1A1D29);
  static const Color textSecondary = Color(0xFF6C757D);

  static const Color successIndicator = Color(0xFF28A745);
  static const Color warningGentle = Color(0xFFFFC107);
  static const Color errorCompassionate = Color(0xFFE74C3C);

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2D2D2D);

  static const Color shadowLight = Color(0x33000000);
  static const Color shadowDark = Color(0x33FFFFFF);

  static const Color dividerLight = Color(0x26000000);
  static const Color dividerDark = Color(0x26FFFFFF);

  /// LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: neutralBase,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryZen,
      brightness: Brightness.light,
      surface: neutralBase,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: surfaceElevation,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    cardTheme: CardThemeData(
      color: surfaceElevation,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: primaryZen,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryZen,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: surfaceElevation,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
    ),

    textTheme: GoogleFonts.interTextTheme(),
  );

  /// DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryZen,
      brightness: Brightness.dark,
      surface: surfaceDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.label,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: cardDark,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ),
  );

  /// 🔑 REQUIRED BY Rocket theme_manager_service.dart
  /// Restores vibe-based dynamic theming
  static ThemeData getVibeTheme({
    required bool isLight,
    required Color vibeColor,
  }) {
    final baseTheme = isLight ? lightTheme : darkTheme;

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: vibeColor,
        primaryContainer: vibeColor.withOpacity(0.15),
      ),
      floatingActionButtonTheme:
          baseTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: vibeColor,
      ),
      progressIndicatorTheme:
          baseTheme.progressIndicatorTheme.copyWith(
        color: vibeColor,
        linearTrackColor: vibeColor.withOpacity(0.2),
        circularTrackColor: vibeColor.withOpacity(0.2),
      ),
    );
  }
}
