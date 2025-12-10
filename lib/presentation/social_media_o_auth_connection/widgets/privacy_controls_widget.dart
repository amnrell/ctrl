import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Privacy controls widget for BigQuery and analytics consent
class PrivacyControlsWidget extends StatelessWidget {
  final bool bigQueryEnabled;
  final bool analyticsEnabled;
  final ValueChanged<bool> onAnalyticsToggle;

  const PrivacyControlsWidget({
    super.key,
    required this.bigQueryEnabled,
    required this.analyticsEnabled,
    required this.onAnalyticsToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
              Icon(
                Icons.privacy_tip_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Privacy & Data Controls',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildBigQueryStatus(theme),
          SizedBox(height: 2.h),
          _buildAnalyticsToggle(theme),
          SizedBox(height: 2.h),
          _buildDataUsageInfo(theme),
        ],
      ),
    );
  }

  Widget _buildBigQueryStatus(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: bigQueryEnabled
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: bigQueryEnabled
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.orange.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            bigQueryEnabled ? Icons.cloud_done : Icons.cloud_off,
            color: bigQueryEnabled ? Colors.green : Colors.orange,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BigQuery Integration',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  bigQueryEnabled
                      ? 'Active - Data collection enabled'
                      : 'Not configured - Using local storage only',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsToggle(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics & Training',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Allow data collection for analytics and AI model training',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: analyticsEnabled,
            onChanged: onAnalyticsToggle,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDataUsageInfo(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'How We Use Your Data',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildDataPoint(
            theme,
            'Usage patterns for personalized recommendations',
          ),
          _buildDataPoint(
            theme,
            'Anonymized metrics for platform analytics',
          ),
          _buildDataPoint(
            theme,
            'Behavioral insights for AI model improvement',
          ),
          _buildDataPoint(
            theme,
            'No personal content or messages are stored',
          ),
        ],
      ),
    );
  }

  Widget _buildDataPoint(ThemeData theme, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: Icon(
              Icons.check_circle_outline,
              size: 14,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
