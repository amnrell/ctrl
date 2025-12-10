import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Dynamic tech/edgy animated background with particle effects
/// Provides visual depth without overwhelming content
class DynamicBackgroundWidget extends StatefulWidget {
  final Color primaryColor;
  final Color? secondaryColor;

  const DynamicBackgroundWidget({
    super.key,
    required this.primaryColor,
    this.secondaryColor,
  });

  @override
  State<DynamicBackgroundWidget> createState() =>
      _DynamicBackgroundWidgetState();
}

class _DynamicBackgroundWidgetState extends State<DynamicBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gridController;
  final List<Particle> _particles = [];
  final int _particleCount = 15;

  @override
  void initState() {
    super.initState();

    // Initialize particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize grid animation
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Generate particles
    _generateParticles();
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 4 + 2,
        speed: random.nextDouble() * 0.5 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_particleController, _gridController]),
      builder: (context, child) {
        return CustomPaint(
          painter: _DynamicBackgroundPainter(
            particleAnimation: _particleController.value,
            gridAnimation: _gridController.value,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            particles: _particles,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class _DynamicBackgroundPainter extends CustomPainter {
  final double particleAnimation;
  final double gridAnimation;
  final Color primaryColor;
  final Color? secondaryColor;
  final List<Particle> particles;

  _DynamicBackgroundPainter({
    required this.particleAnimation,
    required this.gridAnimation,
    required this.primaryColor,
    this.secondaryColor,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw gradient background
    _drawGradientBackground(canvas, size);

    // Draw grid overlay
    _drawGrid(canvas, size);

    // Draw particles
    _drawParticles(canvas, size);
  }

  void _drawGradientBackground(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withValues(alpha: 0.03),
        (secondaryColor ?? primaryColor).withValues(alpha: 0.06),
        primaryColor.withValues(alpha: 0.02),
      ],
    );

    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.05 + (gridAnimation * 0.03))
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const gridSpacing = 80.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    for (var particle in particles) {
      final offset = particleAnimation * particle.speed;
      final x = ((particle.x + offset) % 1.0) * size.width;
      final y = particle.y * size.height;

      final paint = Paint()
        ..color = primaryColor.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Draw subtle glow
      final glowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(x, y), particle.size * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_DynamicBackgroundPainter oldDelegate) {
    return oldDelegate.particleAnimation != particleAnimation ||
        oldDelegate.gridAnimation != gridAnimation ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
