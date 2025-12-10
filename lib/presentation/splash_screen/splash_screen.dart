import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

/// Splash Screen with cyberpunk-style glitching CTRL text animation
/// Features chromatic aberration, scan lines, blur effects, and dynamic color shifts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _glitchController;
  late Animation<double> _fadeAnimation;

  final Random _random = Random();
  bool _isInitializing = true;

  // Glitch effect parameters
  double _glitchOffsetX = 0;
  double _glitchOffsetY = 0;
  double _redChannelOffset = 0;
  double _cyanChannelOffset = 0;
  double _blurAmount = 0;
  double _scanLinePosition = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCyberpunkGlitchEffect();
    _initializeApp();
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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();

    // Scan line animation
    _glitchController.addListener(() {
      if (mounted) {
        setState(() {
          _scanLinePosition = _glitchController.value;
        });
      }
    });
  }

  void _startCyberpunkGlitchEffect() {
    Future.doWhile(() async {
      if (!mounted) return false;

      await Future.delayed(Duration(milliseconds: 50 + _random.nextInt(100)));

      if (mounted && _isInitializing) {
        setState(() {
          // Chromatic aberration effect (red/cyan shift)
          _redChannelOffset = _random.nextDouble() * 6 - 3;
          _cyanChannelOffset = _random.nextDouble() * 6 - 3;

          // Position glitch
          _glitchOffsetX = _random.nextDouble() * 8 - 4;
          _glitchOffsetY = _random.nextDouble() * 4 - 2;

          // Blur variation
          _blurAmount = _random.nextDouble() * 2;
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
    _fadeController.dispose();
    _glitchController.dispose();
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
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A1A),
              const Color(0xFF0F0F0F),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Cyberpunk grid pattern background
            _buildCyberpunkGrid(),

            // Scan lines overlay
            _buildScanLines(),

            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    _buildCyberpunkGlitchText(theme),
                    const SizedBox(height: 48),
                    _buildLoadingIndicator(theme),
                    const Spacer(flex: 3),
                    _buildInitializationStatus(theme),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCyberpunkGrid() {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: _CyberpunkGridPainter(),
    );
  }

  Widget _buildScanLines() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ScanLinePainter(
          position: _scanLinePosition,
          color: Colors.cyan.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildCyberpunkGlitchText(ThemeData theme) {
    return Stack(
      children: [
        // Red chromatic aberration layer
        Transform.translate(
          offset: Offset(_redChannelOffset, _glitchOffsetY),
          child: _buildGlitchTextLayer(
            'CTRL',
            Colors.red.withValues(alpha: 0.7),
          ),
        ),
        // Cyan chromatic aberration layer
        Transform.translate(
          offset: Offset(_cyanChannelOffset, -_glitchOffsetY),
          child: _buildGlitchTextLayer(
            'CTRL',
            Colors.cyan.withValues(alpha: 0.7),
          ),
        ),
        // Main text with blur
        Transform.translate(
          offset: Offset(_glitchOffsetX, _glitchOffsetY),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _blurAmount,
              sigmaY: _blurAmount,
            ),
            child: _buildGlitchTextLayer('CTRL', Colors.white),
          ),
        ),
        // Sharp overlay text
        _buildGlitchTextLayer('CTRL', Colors.white.withValues(alpha: 0.9)),
      ],
    );
  }

  Widget _buildGlitchTextLayer(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 72.sp,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: 8,
        shadows: [
          Shadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 3),
          ),
          Shadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(2, 2),
          ),
        ],
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
                Colors.cyan.withValues(alpha: 0.8),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Initializing...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.cyan.withValues(alpha: 0.7),
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
          child:
              isLoading
                  ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.cyan.withValues(alpha: 0.5),
                    ),
                  )
                  : CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.cyan,
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

/// Custom painter for cyberpunk grid pattern
class _CyberpunkGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.cyan.withValues(alpha: 0.03)
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for scan line effect
class _ScanLinePainter extends CustomPainter {
  final double position;
  final Color color;

  _ScanLinePainter({required this.position, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2;

    final y = size.height * position;

    // Main scan line
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

    // Fading trail
    final gradientPaint =
        Paint()
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
