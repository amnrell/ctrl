import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

/// Splash Screen with advanced glitching CTRL text animation
/// Features dynamic font changes, color shifts, and italic transformations
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Enhanced font families for glitching effect with COLORFUL variations
  final List<Map<String, dynamic>> _glitchVariations = [
    {
      'font': GoogleFonts.inter,
      'weight': FontWeight.w900,
      'italic': false,
      'color': Color(0xFFFF5252), // Vibrant red
    },
    {
      'font': GoogleFonts.robotoMono,
      'weight': FontWeight.w700,
      'italic': false,
      'color': Color(0xFFFFEB3B), // Bright yellow
    },
    {
      'font': GoogleFonts.poppins,
      'weight': FontWeight.w800,
      'italic': true,
      'color': Color(0xFF4CAF50), // Vivid green
    },
    {
      'font': GoogleFonts.courierPrime,
      'weight': FontWeight.bold,
      'italic': false,
      'color': Color(0xFF2196F3), // Electric blue
    },
    {
      'font': GoogleFonts.lato,
      'weight': FontWeight.w900,
      'italic': true,
      'color': Color(0xFFFF6B6B), // Coral red
    },
    {
      'font': GoogleFonts.sourceCodePro,
      'weight': FontWeight.w800,
      'italic': false,
      'color': Color(0xFFFFC107), // Amber yellow
    },
    {
      'font': GoogleFonts.montserrat,
      'weight': FontWeight.w700,
      'italic': false,
      'color': Color(0xFF66BB6A), // Fresh green
    },
    {
      'font': GoogleFonts.ibmPlexMono,
      'weight': FontWeight.bold,
      'italic': true,
      'color': Color(0xFF42A5F5), // Sky blue
    },
    {
      'font': GoogleFonts.raleway,
      'weight': FontWeight.w900,
      'italic': true,
      'color': Color(0xFFEF5350), // Red
    },
    {
      'font': GoogleFonts.ubuntu,
      'weight': FontWeight.w800,
      'italic': false,
      'color': Color(0xFFFDD835), // Gold yellow
    },
    {
      'font': GoogleFonts.jetBrainsMono,
      'weight': FontWeight.w700,
      'italic': false,
      'color': Color(0xFF26A69A), // Teal green
    },
    {
      'font': GoogleFonts.inconsolata,
      'weight': FontWeight.bold,
      'italic': false,
      'color': Color(0xFF1E88E5), // Deep blue
    },
  ];

  int _currentVariationIndex = 0;
  Map<String, dynamic> _currentVariation = {};
  bool _isInitializing = true;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentVariation = _glitchVariations[0];
    _setupAnimation();
    _startEnhancedGlitchEffect();
    _initializeApp();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  void _startEnhancedGlitchEffect() {
    // Rapid variation switching for enhanced glitch effect
    Future.doWhile(() async {
      if (!mounted) return false;

      // Random delay between 60-120ms for natural glitch feel
      await Future.delayed(Duration(milliseconds: 60 + _random.nextInt(60)));

      if (mounted && _isInitializing) {
        setState(() {
          _currentVariationIndex = _random.nextInt(_glitchVariations.length);
          _currentVariation = _glitchVariations[_currentVariationIndex];
        });
        return true;
      }
      return false;
    });
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        _checkAuthentication(),
        _loadVibePreferences(),
        _syncUsageData(),
        _prepareAIContext(),
      ]);

      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });

        HapticFeedback.lightImpact();
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        _navigateToNextScreen();
      }
    }
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _loadVibePreferences() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _syncUsageData() async {
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _prepareAIContext() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.95),
              // Soft RGB tone that changes with current glitch color
              _currentVariation['color'].withValues(alpha: 0.08),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildEnhancedGlitchingText(theme),
                const SizedBox(height: 48),
                _buildLoadingIndicator(theme),
                const Spacer(flex: 3),
                _buildInitializationStatus(theme),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedGlitchingText(ThemeData theme) {
    final fontFunction = _currentVariation['font'] as TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      child: Text(
        'CTRL',
        key: ValueKey(_currentVariationIndex),
        style: fontFunction(
          fontSize: 72.sp,
          fontWeight: _currentVariation['weight'],
          fontStyle:
              _currentVariation['italic'] ? FontStyle.italic : FontStyle.normal,
          // Use the colorful variations without clashing
          color: (_currentVariation['color'] as Color).withValues(alpha: 0.95),
          letterSpacing: _currentVariation['italic'] ? 6 : 8,
          shadows: [
            Shadow(
              color:
                  (_currentVariation['color'] as Color).withValues(alpha: 0.5),
              blurRadius: 20,
              offset: Offset(_currentVariation['italic'] ? -2 : 0, 3),
            ),
            Shadow(
              color: (_currentVariation['color'] as Color).withValues(alpha: 0.3),
              blurRadius: 40,
              offset: Offset(_currentVariation['italic'] ? 2 : -2, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return SizedBox(
      width: 40.w,
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
            width: 3.h,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                (_currentVariation['color'] as Color).withValues(alpha: 0.8),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Initializing...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitializationStatus(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          _buildStatusItem(theme, 'AI Services', _isInitializing),
          SizedBox(height: 1.h),
          _buildStatusItem(theme, 'Social Media Integration', _isInitializing),
          SizedBox(height: 1.h),
          _buildStatusItem(theme, 'Usage Analytics', _isInitializing),
        ],
      ),
    );
  }

  Widget _buildStatusItem(ThemeData theme, String label, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 2.h,
          height: 2.h,
          child: isLoading
              ? CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _currentVariation['color'].withValues(alpha: 0.5),
                  ),
                )
              : CustomIconWidget(
                  iconName: 'check_circle',
                  color: _currentVariation['color'],
                  size: 2.h,
                ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}