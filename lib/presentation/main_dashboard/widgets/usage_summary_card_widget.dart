import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Usage summary cards displaying social media engagement data
class UsageSummaryCardWidget extends StatelessWidget {
  final Map<String, dynamic> usageData;
  final Color vibeColor;
  final VoidCallback onTap;

  const UsageSummaryCardWidget({
    super.key,
    required this.usageData,
    required this.vibeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Total screen time card
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'phone_android',
                          color: vibeColor,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Total Screen Time',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  usageData['totalScreenTime'] as String? ?? '0h 0m',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: vibeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Today\'s usage across all apps',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Apps breakdown
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'apps',
                    color: vibeColor,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Top Apps',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // App list
              ...(usageData['appsBreakdown'] as List<Map<String, dynamic>>? ??
                      [])
                  .map((app) => _buildAppItem(context, app, theme)),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Detected patterns
        if ((usageData['detectedPatterns'] as List<String>?)?.isNotEmpty ??
            false)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.warningGentle.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.warningGentle.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning_amber',
                      color: AppTheme.warningGentle,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Detected Patterns',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.warningGentle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                ...(usageData['detectedPatterns'] as List<String>)
                    .map((pattern) => Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'circle',
                                color: AppTheme.warningGentle,
                                size: 8,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  pattern,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAppItem(
      BuildContext context, Map<String, dynamic> app, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          // App icon placeholder
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: vibeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                (app['name'] as String).substring(0, 1),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: vibeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app['name'] as String,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: app['percentage'] as double,
                    backgroundColor:
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(vibeColor),
                    minHeight: 0.8.h,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 3.w),

          Text(
            app['time'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
