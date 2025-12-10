import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Data pipeline status widget showing BigQuery connection and data source status
class DataPipelineStatusWidget extends StatelessWidget {
  final bool isConfigured;
  final bool isMockData;

  const DataPipelineStatusWidget({
    super.key,
    required this.isConfigured,
    required this.isMockData,
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
                Icons.cloud_queue,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Data Pipeline Status',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildStatusRow(
            theme,
            'BigQuery Integration',
            isConfigured ? 'Active' : 'Not Configured',
            isConfigured ? Colors.green : Colors.orange,
            isConfigured ? Icons.check_circle : Icons.warning,
          ),
          SizedBox(height: 1.h),
          _buildStatusRow(
            theme,
            'Data Source',
            isMockData ? 'Mock Data (Development)' : 'Live Data',
            isMockData ? Colors.blue : Colors.green,
            isMockData ? Icons.code : Icons.cloud_done,
          ),
          if (!isConfigured) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Configure BigQuery credentials to enable live data collection and advanced analytics',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(ThemeData theme, String label, String status,
      Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              status,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
