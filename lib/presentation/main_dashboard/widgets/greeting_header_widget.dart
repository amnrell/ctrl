import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../models/vibe_config.dart';

/// Greeting header with vibe-specific time-based greetings and emotional prompts
class GreetingHeaderWidget extends StatelessWidget {
  final DateTime currentTime;
  final Color vibeColor;
  final String currentVibe;

  const GreetingHeaderWidget({
    super.key,
    required this.currentTime,
    required this.vibeColor,
    required this.currentVibe,
  });

  /// Get time-based greeting (Good Morning/Afternoon/Evening)
  String _getTimeBasedGreeting() {
    final hour = currentTime.hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Get vibe-specific emotional prompt using VibeConfig
  String _getVibePrompt() {
    final vibeConfig = VibeConfig.getConfig(currentVibe);
    return vibeConfig.emotionalPrompt;
  }

  IconData _getVibeIcon() {
    final vibeConfig = VibeConfig.getConfig(currentVibe);
    return vibeConfig.icon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            vibeColor.withValues(alpha: 0.1),
            vibeColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: _getVibeIcon().codePoint.toString(),
                color: vibeColor,
                size: 28,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  _getTimeBasedGreeting(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Vibe-specific emotional prompt
          Text(
            _getVibePrompt(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          SizedBox(height: 1.h),

          // Time display
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
