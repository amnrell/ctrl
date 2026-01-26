import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// Centralized theme manager for vibe-based color synchronization
/// Handles theme persistence, color combinations, and font customization
class ThemeManagerService extends ChangeNotifier {
  static final ThemeManagerService _instance = ThemeManagerService._internal();
  factory ThemeManagerService() => _instance;
  ThemeManagerService._internal();

  // Current theme settings
  Color _primaryVibeColor = AppTheme.primaryZen;
  Color? _secondaryVibeColor;
  bool _isLightMode = true;
  double _fontSizeMultiplier = 1.0;
  String _fontStyle = 'Inter';
  String _currentVibeName = 'Zen'; // Track vibe name for persistence

  // Getters
  Color get primaryVibeColor => _primaryVibeColor;
  Color? get secondaryVibeColor => _secondaryVibeColor;
  bool get isLightMode => _isLightMode;
  double get fontSizeMultiplier => _fontSizeMultiplier;
  String get fontStyle => _fontStyle;
  String get currentVibeName => _currentVibeName; // Getter for vibe name

  // Vibe color combinations for variations
  static const Map<String, List<Color>> vibeColorCombinations = {
    'zen-energy': [AppTheme.primaryZen, AppTheme.primaryEnergy],
    'zen-reflection': [AppTheme.primaryZen, AppTheme.primaryReflection],
    'energy-reflection': [AppTheme.primaryEnergy, AppTheme.primaryReflection],
    'zen-solo': [AppTheme.primaryZen],
    'energy-solo': [AppTheme.primaryEnergy],
    'reflection-solo': [AppTheme.primaryReflection],
  };

  // Font style options
  static const List<String> fontStyleOptions = [
    'Inter',
    'Roboto',
    'Poppins',
    'Lato',
    'Open Sans',
  ];

  /// Initialize theme from shared preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Load primary vibe color
    final primaryColorValue = prefs.getInt('primary_vibe_color');
    if (primaryColorValue != null) {
      _primaryVibeColor = Color(primaryColorValue);
    }

    // Load vibe name for persistence
    _currentVibeName = prefs.getString('current_vibe_name') ?? 'Zen';

    // Load secondary vibe color (for combinations)
    final secondaryColorValue = prefs.getInt('secondary_vibe_color');
    if (secondaryColorValue != null) {
      _secondaryVibeColor = Color(secondaryColorValue);
    }

    // Load theme mode
    _isLightMode = prefs.getBool('is_light_mode') ?? true;

    // Load font settings
    _fontSizeMultiplier = prefs.getDouble('font_size_multiplier') ?? 1.0;
    _fontStyle = prefs.getString('font_style') ?? 'Inter';

    notifyListeners();
  }

  /// Set primary vibe color and save to preferences
  Future<void> setPrimaryVibeColor(Color color, {String? vibeName}) async {
    _primaryVibeColor = color;
    if (vibeName != null) {
      _currentVibeName = vibeName;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primary_vibe_color', color.value);
    if (vibeName != null) {
      await prefs.setString('current_vibe_name', vibeName);
    }
    notifyListeners();
  }

  /// Set secondary vibe color for combinations
  Future<void> setSecondaryVibeColor(Color? color) async {
    _secondaryVibeColor = color;
    final prefs = await SharedPreferences.getInstance();
    if (color != null) {
      await prefs.setInt('secondary_vibe_color', color.value);
    } else {
      await prefs.remove('secondary_vibe_color');
    }
    notifyListeners();
  }

  /// Set vibe color combination by key
  Future<void> setVibeColorCombination(String combinationKey) async {
    final colors = vibeColorCombinations[combinationKey];
    if (colors != null && colors.isNotEmpty) {
      await setPrimaryVibeColor(colors[0]);
      if (colors.length > 1) {
        await setSecondaryVibeColor(colors[1]);
      } else {
        await setSecondaryVibeColor(null);
      }
    }
  }

  /// Toggle theme mode (light/dark)
  Future<void> toggleThemeMode() async {
    _isLightMode = !_isLightMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_light_mode', _isLightMode);
    notifyListeners();
  }

  /// Set font size multiplier
  Future<void> setFontSizeMultiplier(double multiplier) async {
    _fontSizeMultiplier = multiplier.clamp(0.8, 1.5);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size_multiplier', _fontSizeMultiplier);
    notifyListeners();
  }

  /// Set font style
  Future<void> setFontStyle(String fontStyle) async {
    if (fontStyleOptions.contains(fontStyle)) {
      _fontStyle = fontStyle;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('font_style', fontStyle);
      notifyListeners();
    }
  }

  /// Get current theme data with vibe color applied
  ThemeData getCurrentTheme() {
    final baseTheme = _isLightMode ? AppTheme.lightTheme : AppTheme.darkTheme;

    // Apply vibe color
    ThemeData vibeTheme = AppTheme.getVibeTheme(
      isLight: _isLightMode,
      vibeColor: _primaryVibeColor,
    );

    // Apply font size multiplier to text theme
    final textTheme = vibeTheme.textTheme.apply(
      fontSizeFactor: _fontSizeMultiplier,
    );

    return vibeTheme.copyWith(
      textTheme: textTheme,
    );
  }

  /// Get gradient colors for vibe combinations
  List<Color> getGradientColors() {
    if (_secondaryVibeColor != null) {
      return [
        _primaryVibeColor,
        _secondaryVibeColor!,
      ];
    }
    return [
      _primaryVibeColor,
      _primaryVibeColor.withValues(alpha: 0.7),
    ];
  }
}
