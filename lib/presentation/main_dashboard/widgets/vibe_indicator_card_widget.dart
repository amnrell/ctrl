import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Large vibe indicator card showing active emotional state
class VibeIndicatorCardWidget extends StatelessWidget {
  final String currentVibe;
  final Color vibeColor;

  const VibeIndicatorCardWidget({
    super.key,
    required this.currentVibe,
    required this.vibeColor,
  });

  /// Get vibe-specific description reflecting the emotional state
  String _getVibeDescription() {
    switch (currentVibe) {
      case 'Zen':
        return 'Calm and grounded. Perfect for mindful scrolling.';
      case 'Energized':
        return 'High energy and motivated. Stay focused!';
      case 'Reflective':
        return 'Thoughtful and introspective. Take your time.';
      case 'Focused':
        return 'Concentrated and productive. Minimize distractions.';
      case 'Creative':
        return 'Inspired and imaginative. Let ideas flow.';
      case 'Social':
        return 'Connected and engaged. Enjoy interactions!';
      default:
        return 'Your current emotional state';
    }
  }

  IconData _getVibeIcon() {
    switch (currentVibe) {
      case 'Zen':
        return Icons.self_improvement;
      case 'Energized':
        return Icons.bolt;
      case 'Reflective':
        return Icons.psychology;
      case 'Focused':
        return Icons.center_focus_strong;
      case 'Creative':
        return Icons.palette;
      case 'Social':
        return Icons.groups;
      default:
        return Icons.mood;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            vibeColor,
            vibeColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: vibeColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Vibe',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Change',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Vibe name with emotional state description
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomIconWidget(
                  iconName: _getVibeIcon().codePoint.toString(),
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show current vibe name prominently
                    Text(
                      currentVibe,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    // Emotional state description
                    Text(
                      _getVibeDescription(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Active since timestamp
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Active since 9:30 AM',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
