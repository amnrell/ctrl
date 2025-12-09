import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Platform breakdown widget showing per-platform analytics
class PlatformBreakdownWidget extends StatelessWidget {
  final List<dynamic> platformData;

  const PlatformBreakdownWidget({
    super.key,
    required this.platformData,
  });

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return Colors.black;
      case 'x':
      case 'twitter':
        return Colors.black;
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'reddit':
        return const Color(0xFFFF4500);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (platformData.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            'No platform data available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Breakdown',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        ...platformData.map((data) => _buildPlatformCard(theme, data)),
      ],
    );
  }

  Widget _buildPlatformCard(ThemeData theme, dynamic data) {
    final platform = data['platform'] as String? ?? 'Unknown';
    final interactions = (data['total_interactions'] as num?)?.toInt() ?? 0;
    final avgDuration =
        (data['avg_session_duration'] as num?)?.toDouble() ?? 0.0;
    final platformColor = _getPlatformColor(platform);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: platformColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: platformColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: platformColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    platform.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      color: platformColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                      platform,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$interactions interactions',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Avg Session',
                  '${avgDuration.toStringAsFixed(1)}m',
                  Icons.timer,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Daily Hours',
                  '${(avgDuration / 60).toStringAsFixed(1)}h',
                  Icons.access_time,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      ThemeData theme, String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
