import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// Centralized theme + vibe manager
/// SAFE singleton – never disposed by UI
/// Fully backwards-compatible
class ThemeManagerService extends ChangeNotifier {
  // ------------------------------------
  // SINGLETON (GLOBAL, SAFE)
  // ------------------------------------

  ThemeManagerService._internal();
  static final ThemeManagerService instance =
      ThemeManagerService._internal();

  /// Backwards compatibility
  factory ThemeManagerService() => instance;

  // ------------------------------------
  // CORE STATE
  // ------------------------------------

  Color _primaryVibeColor = AppTheme.primaryZen;
  Color? _secondaryVibeColor;
  bool _isLightMode = true;
  double _fontSizeMultiplier = 1.0;
  String _fontStyle = 'Inter';
  String _currentVibeName = 'Zen';

  bool _initialized = false;

  // ------------------------------------
  // LEGACY CONSTANTS (DO NOT REMOVE)
  // ------------------------------------

  static const Map<String, List<Color>> vibeColorCombinations = {
    'zen': [AppTheme.primaryZen],
    'energy': [AppTheme.primaryEnergy],
    'reflection': [AppTheme.primaryReflection],
    'zen-energy': [AppTheme.primaryZen, AppTheme.primaryEnergy],
    'zen-reflection': [AppTheme.primaryZen, AppTheme.primaryReflection],
    'energy-reflection': [
      AppTheme.primaryEnergy,
      AppTheme.primaryReflection,
    ],
  };

  static const List<String> fontStyleOptions = [
    'Inter',
    'Roboto',
    'Poppins',
    'Lato',
    'Open Sans',
  ];

  // ------------------------------------
  // GETTERS (USED ACROSS APP)
  // ------------------------------------

  Color get primaryVibeColor => _primaryVibeColor;
  Color? get secondaryVibeColor => _secondaryVibeColor;
  bool get isLightMode => _isLightMode;
  double get fontSizeMultiplier => _fontSizeMultiplier;
  String get fontStyle => _fontStyle;
  String get currentVibeName => _currentVibeName;

  /// Notifications & previews should always use this
  Color get currentVibeColor => _primaryVibeColor;

  bool get isInitialized => _initialized;

  // ------------------------------------
  // INIT (SAFE TO CALL MULTIPLE TIMES)
  // ------------------------------------

  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();

    final primary = prefs.getInt('primary_vibe_color');
    final secondary = prefs.getInt('secondary_vibe_color');

    if (primary != null) {
      _primaryVibeColor = Color(primary);
    }
    if (secondary != null) {
      _secondaryVibeColor = Color(secondary);
    }

    _currentVibeName =
        prefs.getString('current_vibe_name') ?? 'Zen';
    _isLightMode = prefs.getBool('is_light_mode') ?? true;
    _fontSizeMultiplier =
        prefs.getDouble('font_size_multiplier') ?? 1.0;
    _fontStyle = prefs.getString('font_style') ?? 'Inter';

    _initialized = true;
    notifyListeners();
  }

  // ------------------------------------
  // VIBE CONTROLS
  // ------------------------------------

  Future<void> setPrimaryVibeColor(
    Color color, {
    String? vibeName,
  }) async {
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

  Future<void> setSecondaryVibeColor(Color? color) async {
    _secondaryVibeColor = color;
    final prefs = await SharedPreferences.getInstance();

    if (color == null) {
      await prefs.remove('secondary_vibe_color');
    } else {
      await prefs.setInt('secondary_vibe_color', color.value);
    }

    notifyListeners();
  }

  Future<void> setVibeColorCombination(String key) async {
    final colors = vibeColorCombinations[key];
    if (colors == null || colors.isEmpty) return;

    await setPrimaryVibeColor(colors.first, vibeName: key);

    if (colors.length > 1) {
      await setSecondaryVibeColor(colors[1]);
    } else {
      await setSecondaryVibeColor(null);
    }
  }

  // ------------------------------------
  // FONT CONTROLS (FIXES PREVIOUS ERRORS)
  // ------------------------------------

  Future<void> setFontSizeMultiplier(double multiplier) async {
    _fontSizeMultiplier = multiplier.clamp(0.8, 1.5);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(
      'font_size_multiplier',
      _fontSizeMultiplier,
    );

    notifyListeners();
  }

  Future<void> setFontStyle(String font) async {
    if (!fontStyleOptions.contains(font)) return;
    _fontStyle = font;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('font_style', font);

    notifyListeners();
  }

  // ------------------------------------
  // THEME MODE
  // ------------------------------------

  Future<void> toggleThemeMode() async {
    _isLightMode = !_isLightMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_light_mode', _isLightMode);
    notifyListeners();
  }

  // ------------------------------------
  // THEME OUTPUT
  // ------------------------------------

  ThemeData getCurrentTheme() {
    final base =
        _isLightMode ? AppTheme.lightTheme : AppTheme.darkTheme;

    final themed = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: _primaryVibeColor,
      ),
    );

    return themed.copyWith(
      textTheme: themed.textTheme.apply(
        fontSizeFactor: _fontSizeMultiplier,
        fontFamily: _fontStyle,
      ),
    );
  }

  // ------------------------------------
  // GRADIENT SUPPORT
  // ------------------------------------

  List<Color> getGradientColors() {
    if (_secondaryVibeColor != null) {
      return [_primaryVibeColor, _secondaryVibeColor!];
    }
    return [
      _primaryVibeColor,
      _primaryVibeColor.withValues(alpha: 0.7),
    ];
  }
}
