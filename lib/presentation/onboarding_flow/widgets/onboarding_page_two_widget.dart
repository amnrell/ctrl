import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Second onboarding page - Permissions and privacy explanation
class OnboardingPageTwoWidget extends StatelessWidget {
  final Color vibeColor;

  const OnboardingPageTwoWidget({
    super.key,
    required this.vibeColor,
  });

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

            // Permissions icon
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: vibeColor.withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.verified_user_rounded,
                color: vibeColor,
                size: 80,
              ),
            ),

            SizedBox(height: 6.h),

            // Title
            Text(
              'Privacy First',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'We need a few permissions to help you take control of your digital wellbeing',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            // Permission items
            _buildPermissionItem(
              context,
              Icons.app_settings_alt,
              'Social Media Access',
              'Track usage time across your social apps',
              'Required for analytics',
            ),
            SizedBox(height: 3.h),
            _buildPermissionItem(
              context,
              Icons.query_stats,
              'Usage Statistics',
              'Analyze your screen time patterns',
              'Helps detect unhealthy habits',
            ),
            SizedBox(height: 3.h),
            _buildPermissionItem(
              context,
              Icons.notifications_active,
              'Notifications',
              'Remind you about breaks and goals',
              'Optional - you control frequency',
            ),

            SizedBox(height: 6.h),

            // Privacy assurance
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: vibeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: vibeColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_rounded,
                    color: vibeColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Your data stays on your device. We never share or sell your information.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String benefit,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: vibeColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              color: vibeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: vibeColor,
              size: 28,
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
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  benefit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: vibeColor,
                    fontStyle: FontStyle.italic,
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
