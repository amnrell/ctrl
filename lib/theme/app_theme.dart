import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the emotional wellness application.
/// Implements Adaptive Emotional Minimalism with Dynamic Emotional Spectrum color system.
class AppTheme {
  AppTheme._();

  // Vibe-based Primary Colors (Dynamic Emotional Spectrum)
  static const Color primaryZen =
      Color(0xFF4A7C59); // Grounding green for calm states
  static const Color primaryEnergy =
      Color(0xFFE8B86D); // Warm amber for motivated states
  static const Color primaryReflection =
      Color(0xFF6B73FF); // Thoughtful blue-purple for introspection

  // Neutral Base Colors
  static const Color neutralBase = Color(0xFFF8F9FA); // Clean background
  static const Color surfaceElevation =
      Color(0xFFFFFFFF); // Pure white for cards

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D29); // High contrast dark
  static const Color textSecondary =
      Color(0xFF6C757D); // Subtle gray for supporting info

  // Semantic Colors
  static const Color successIndicator =
      Color(0xFF28A745); // Positive achievements
  static const Color warningGentle =
      Color(0xFFFFC107); // Soft warning without anxiety
  static const Color errorCompassionate =
      Color(0xFFE74C3C); // Muted red for emotional safety

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2D2D2D);

  // Text colors for dark mode
  static const Color textHighEmphasisLight = Color(0xDE000000); // 87% opacity
  static const Color textMediumEmphasisLight = Color(0x99000000); // 60% opacity
  static const Color textDisabledLight = Color(0x61000000); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xDEFFFFFF); // 87% opacity
  static const Color textMediumEmphasisDark = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  // Shadow colors with emotional coherence
  static const Color shadowLight = Color(0x33000000); // 20% opacity
  static const Color shadowDark = Color(0x33FFFFFF); // 20% opacity

  // Divider colors (minimal 1px borders at 15% opacity)
  static const Color dividerLight = Color(0x26000000); // 15% opacity
  static const Color dividerDark = Color(0x26FFFFFF); // 15% opacity

  /// Light theme with Zen vibe as default
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryZen,
      onPrimary: surfaceElevation,
      primaryContainer: primaryZen.withValues(alpha: 0.15),
      onPrimaryContainer: textPrimary,
      secondary: primaryEnergy,
      onSecondary: textPrimary,
      secondaryContainer: primaryEnergy.withValues(alpha: 0.15),
      onSecondaryContainer: textPrimary,
      tertiary: primaryReflection,
      onTertiary: surfaceElevation,
      tertiaryContainer: primaryReflection.withValues(alpha: 0.15),
      onTertiaryContainer: textPrimary,
      error: errorCompassionate,
      onError: surfaceElevation,
      surface: neutralBase,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: dividerLight,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: surfaceDark,
      onInverseSurface: textHighEmphasisDark,
      inversePrimary: primaryZen,
      surfaceTint: primaryZen.withValues(alpha: 0.1),
    ),
    scaffoldBackgroundColor: neutralBase,
    cardColor: surfaceElevation,
    dividerColor: dividerLight,

    // AppBar Theme - Clean and minimal
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceElevation,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card Theme with subtle elevation
    cardTheme: CardTheme(
      color: surfaceElevation,
      elevation: 0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation Bar Theme - Thumb-friendly zone
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceElevation,
      selectedItemColor: primaryZen,
      unselectedItemColor: textSecondary,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // Floating Action Button - Quick vibe access
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryZen,
      foregroundColor: surfaceElevation,
      elevation: 4,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surfaceElevation,
        backgroundColor: primaryZen,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryZen,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: primaryZen.withValues(alpha: 0.15)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryZen,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Theme - Inter for headings, Inter for body (replacing Source Sans Pro)
    textTheme: _buildTextTheme(isLight: true),

    // Input Decoration Theme - Focused states with emotional resonance
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceElevation,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryZen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorCompassionate),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorCompassionate, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorCompassionate,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen.withValues(alpha: 0.5);
        }
        return textSecondary.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(surfaceElevation),
      side: BorderSide(color: dividerLight, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen;
        }
        return textSecondary;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryZen,
      linearTrackColor: primaryZen.withValues(alpha: 0.2),
      circularTrackColor: primaryZen.withValues(alpha: 0.2),
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryZen,
      thumbColor: primaryZen,
      overlayColor: primaryZen.withValues(alpha: 0.2),
      inactiveTrackColor: primaryZen.withValues(alpha: 0.3),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryZen,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryZen,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceElevation,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceElevation,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryZen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceElevation,
      modalBackgroundColor: surfaceElevation,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
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
  );

  /// Dark theme with Zen vibe as default
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryZen,
      onPrimary: backgroundDark,
      primaryContainer: primaryZen.withValues(alpha: 0.15),
      onPrimaryContainer: textHighEmphasisDark,
      secondary: primaryEnergy,
      onSecondary: backgroundDark,
      secondaryContainer: primaryEnergy.withValues(alpha: 0.15),
      onSecondaryContainer: textHighEmphasisDark,
      tertiary: primaryReflection,
      onTertiary: backgroundDark,
      tertiaryContainer: primaryReflection.withValues(alpha: 0.15),
      onTertiaryContainer: textHighEmphasisDark,
      error: errorCompassionate,
      onError: backgroundDark,
      surface: surfaceDark,
      onSurface: textHighEmphasisDark,
      onSurfaceVariant: textMediumEmphasisDark,
      outline: dividerDark,
      outlineVariant: dividerDark,
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: surfaceElevation,
      onInverseSurface: textPrimary,
      inversePrimary: primaryZen,
      surfaceTint: primaryZen.withValues(alpha: 0.1),
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textHighEmphasisDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textHighEmphasisDark,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(
        color: textHighEmphasisDark,
        size: 24,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryZen,
      unselectedItemColor: textMediumEmphasisDark,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryZen,
      foregroundColor: backgroundDark,
      elevation: 4,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundDark,
        backgroundColor: primaryZen,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryZen,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: primaryZen.withValues(alpha: 0.15)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryZen,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Theme
    textTheme: _buildTextTheme(isLight: false),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryZen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorCompassionate),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorCompassionate, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textMediumEmphasisDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorCompassionate,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen;
        }
        return textMediumEmphasisDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen.withValues(alpha: 0.5);
        }
        return textMediumEmphasisDark.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundDark),
      side: BorderSide(color: dividerDark, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryZen;
        }
        return textMediumEmphasisDark;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryZen,
      linearTrackColor: primaryZen.withValues(alpha: 0.2),
      circularTrackColor: primaryZen.withValues(alpha: 0.2),
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryZen,
      thumbColor: primaryZen,
      overlayColor: primaryZen.withValues(alpha: 0.2),
      inactiveTrackColor: primaryZen.withValues(alpha: 0.3),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryZen,
      unselectedLabelColor: textMediumEmphasisDark,
      indicatorColor: primaryZen,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textHighEmphasisDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cardDark,
      contentTextStyle: GoogleFonts.inter(
        color: textHighEmphasisDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryZen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: cardDark,
      modalBackgroundColor: cardDark,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: cardDark,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textHighEmphasisDark,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasisDark,
      ),
    ),
  );

  /// Helper method to build text theme based on brightness
  /// Uses Inter for headings, Inter for body text (replacing Source Sans Pro),
  /// Roboto for captions, and JetBrains Mono for data display
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles - Inter for headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),

      // Headline styles - Inter for headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),

      // Title styles - Inter for headings
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Body styles - Inter (replacing Source Sans Pro)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles - Roboto for captions
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Helper method to get data text style using JetBrains Mono
  static TextStyle dataTextStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor = isLight ? textPrimary : textHighEmphasisDark;
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0,
    );
  }

  /// Helper method to create vibe-specific theme variations
  static ThemeData getVibeTheme({
    required bool isLight,
    required Color vibeColor,
  }) {
    final baseTheme = isLight ? lightTheme : darkTheme;

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: vibeColor,
        primaryContainer: vibeColor.withValues(alpha: 0.15),
      ),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: vibeColor,
      ),
      progressIndicatorTheme: baseTheme.progressIndicatorTheme.copyWith(
        color: vibeColor,
        linearTrackColor: vibeColor.withValues(alpha: 0.2),
        circularTrackColor: vibeColor.withValues(alpha: 0.2),
      ),
    );
  }
}