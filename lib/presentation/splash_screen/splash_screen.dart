import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../services/firebase_auth_service.dart';
import '../../utils/constant.dart';
import '../../utils/responsive_helper.dart';
import '../auth/SIgnin/signin.dart';
import '../tab_page/tab_page.dart';

/// Splash Screen with logo animation
/// Features subtle glitch effects and dynamic color theming
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _glitchController;
  late AnimationController _logoScaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoScaleAnimation;

  final Random _random = Random();
  final ThemeManagerService _themeManager = ThemeManagerService();
  bool _isInitializing = true;
  bool _isAuthenticated = false;
  Color _primaryVibeColor = const Color(0xFF4A7C59); // Default Zen

  // Glitch effect parameters
  double _glitchOffsetX = 0;
  double _glitchOffsetY = 0;
  double _blurAmount = 0;
  double _scanLinePosition = 0;

  @override
  void initState() {
    super.initState();
    _loadThemeAndSetup();
  }

  Future<void> _loadThemeAndSetup() async {
    // Initialize theme manager and load vibe color
    await _themeManager.initialize();
    if (mounted) {
      setState(() {
        _primaryVibeColor = _themeManager.primaryVibeColor;
      });
      _setupAnimations();
      _startSubtleGlitchEffect();
      _initializeApp();
    }
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    )..repeat();

    _logoScaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoScaleController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    _logoScaleController.forward();

    // Scan line animation
    _glitchController.addListener(() {
      if (mounted) {
        setState(() {
          _scanLinePosition = _glitchController.value;
        });
      }
    });
  }

  void _startSubtleGlitchEffect() {
    Future.doWhile(() async {
      if (!mounted) return false;

      await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(150)));

      if (mounted && _isInitializing) {
        setState(() {
          // Subtle position glitch
          _glitchOffsetX = _random.nextDouble() * 2 - 1;
          _glitchOffsetY = _random.nextDouble() * 1 - 0.5;

          // Subtle blur variation
          _blurAmount = _random.nextDouble() * 0.5;
        });
        return true;
      }
      return false;
    });
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        _loadVibePreferences(),
        _syncUsageData(),
        _prepareAIContext(),
      ]);

      // Wait for minimum splash duration (Apple requirement: at least 2 seconds)
      // Also ensure logo animation completes
      await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        _logoScaleController
            .forward()
            .then((_) => Future.delayed(const Duration(milliseconds: 500))),
      ]);

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });

        // Wait for fade animation to complete before navigation
        await _fadeController.forward();
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          HapticFeedback.lightImpact();
          _navigateToNextScreen();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        // Ensure animation completes even on error
        await _fadeController.forward();
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          _navigateToNextScreen();
        }
      }
    }
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
    // Navigate based on authentication state
    var IsLogin = getStorage.read('isLogin') ?? 0;
    if (IsLogin == 1) {
      // User is logged in, go to dashboard
      Get.offAll(() => const TabPage());
    } else {
      // User is not logged in, go to sign in screen
      Get.offAll(() => const SignInPage());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _glitchController.dispose();
    _logoScaleController.dispose();
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
              _primaryVibeColor.withValues(alpha: 0.1),
              theme.colorScheme.surface,
              _primaryVibeColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Subtle grid pattern background
            _buildSubtleGrid(),

            // Scan lines overlay
            _buildScanLines(),

            // Main content
            SafeArea(
              child: ResponsiveHelper.wrapWithMaxWidth(
                context,
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      _buildLogo(theme),
                      SizedBox(
                          height: ResponsiveHelper.getSpacing(context,
                              mobile: 4.0, tablet: 5.0, desktop: 6.0)),
                      _buildLoadingIndicator(theme),
                      const Spacer(flex: 3),
                      _buildInitializationStatus(theme),
                      SizedBox(
                          height: ResponsiveHelper.getSpacing(context,
                              mobile: 3.0, tablet: 4.0, desktop: 5.0)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtleGrid() {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: _SubtleGridPainter(color: _primaryVibeColor),
    );
  }

  Widget _buildScanLines() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ScanLinePainter(
          position: _scanLinePosition,
          color: _primaryVibeColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return ScaleTransition(
      scale: _logoScaleAnimation,
      child: Transform.translate(
        offset: Offset(_glitchOffsetX, _glitchOffsetY),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: _blurAmount,
            sigmaY: _blurAmount,
          ),
          child: Image.asset(
            'assets/images/ctrl-logo-png-transparent-1765008694800.png',
            width: 60.w,
            height: 60.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to SVG if PNG fails
              return Image.asset(
                'assets/images/img_app_logo.svg',
                width: 60.w,
                height: 60.w,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Final fallback to text if both assets fail
                  return Text(
                    'CTRL',
                    style: GoogleFonts.inter(
                      fontSize: 72.sp,
                      fontWeight: FontWeight.w900,
                      color: _primaryVibeColor,
                      letterSpacing: 8,
                    ),
                  );
                },
              );
            },
          ),
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
                _primaryVibeColor.withValues(alpha: 0.8),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Initializing...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: _primaryVibeColor.withValues(alpha: 0.7),
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
                    _primaryVibeColor.withValues(alpha: 0.5),
                  ),
                )
              : CustomIconWidget(
                  iconName: 'check_circle',
                  color: _primaryVibeColor,
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

/// Custom painter for subtle grid pattern
class _SubtleGridPainter extends CustomPainter {
  final Color color;

  _SubtleGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_SubtleGridPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Custom painter for scan line effect
class _ScanLinePainter extends CustomPainter {
  final double position;
  final Color color;

  _ScanLinePainter({required this.position, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    final y = size.height * position;

    // Main scan line
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

    // Fading trail
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0),
          color,
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40));

    canvas.drawRect(Rect.fromLTWH(0, y - 20, size.width, 40), gradientPaint);
  }

  @override
  bool shouldRepaint(_ScanLinePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}
