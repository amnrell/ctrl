import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Connection status summary widget
class ConnectionStatusWidget extends StatelessWidget {
  final Map<String, bool> connectionStatuses;

  const ConnectionStatusWidget({
    super.key,
    required this.connectionStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectedCount =
        connectionStatuses.values.where((connected) => connected).length;
    final totalCount = connectionStatuses.length;

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
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Connection Status',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  theme,
                  'Connected',
                  connectedCount.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatusCard(
                  theme,
                  'Available',
                  totalCount.toString(),
                  theme.colorScheme.primary,
                  Icons.hub,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildProgressBar(theme, connectedCount, totalCount),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    ThemeData theme,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
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

  Widget _buildProgressBar(ThemeData theme, int connected, int total) {
    final progress = total > 0 ? connected / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Setup Progress',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
