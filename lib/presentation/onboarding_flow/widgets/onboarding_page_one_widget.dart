import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// First onboarding page - Welcome and value proposition
class OnboardingPageOneWidget extends StatefulWidget {
  final Color vibeColor;

  const OnboardingPageOneWidget({
    super.key,
    required this.vibeColor,
  });

  @override
  State<OnboardingPageOneWidget> createState() =>
      _OnboardingPageOneWidgetState();
}

class _OnboardingPageOneWidgetState extends State<OnboardingPageOneWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Animated CTRL logo
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.vibeColor.withValues(alpha: 0.3),
                          widget.vibeColor.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: CustomImageWidget(
                        imagePath:
                            'assets/images/ctrl-logo-png-transparent-1765008694800.png',
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 6.h),

            // Welcome title
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  widget.vibeColor,
                  widget.vibeColor.withValues(alpha: 0.7),
                ],
              ).createShader(bounds),
              child: Text(
                'Welcome to CTRL',
                style: GoogleFonts.inter(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 3.h),

            // Value proposition
            Text(
              'Take control of your digital wellbeing',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            Text(
              'Monitor social media usage, understand your emotional patterns, and make mindful decisions about your screen time',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            // Feature highlights
            _buildFeatureHighlight(
              context,
              'psychology',
              'Emotional Awareness',
              'Track how social media affects your mood',
            ),
            SizedBox(height: 2.h),
            _buildFeatureHighlight(
              context,
              'insights',
              'Smart Analytics',
              'Understand your usage patterns with AI',
            ),
            SizedBox(height: 2.h),
            _buildFeatureHighlight(
              context,
              'shield',
              'Mindful Control',
              'Set boundaries that work for you',
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureHighlight(
    BuildContext context,
    String iconName,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: widget.vibeColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getIconData(iconName),
            color: widget.vibeColor,
            size: 24,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'psychology':
        return Icons.psychology;
      case 'insights':
        return Icons.insights;
      case 'shield':
        return Icons.shield;
      default:
        return Icons.star;
    }
  }
}
