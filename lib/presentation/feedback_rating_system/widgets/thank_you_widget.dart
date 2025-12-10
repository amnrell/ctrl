import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../services/theme_manager_service.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Thank you screen after feedback submission
class ThankYouWidget extends StatelessWidget {
  final VoidCallback onClose;
  final ThemeManagerService themeManager;

  const ThankYouWidget({
    super.key,
    required this.onClose,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                themeManager.primaryVibeColor.withValues(alpha: 0.15),
                themeManager.primaryVibeColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: themeManager.primaryVibeColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: themeManager.primaryVibeColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: themeManager.primaryVibeColor,
                  size: 64,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Thank You! 🎉',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeManager.primaryVibeColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Your feedback helps us make CTRL better for everyone!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'We\'ll review your feedback and may reach out if you provided contact information.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeManager.primaryVibeColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
