import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying infrastructure alert cards with severity indicators
class AlertCardWidget extends StatelessWidget {
  final Map<String, dynamic> alertData;

  const AlertCardWidget({
    super.key,
    required this.alertData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severity = alertData['severity'] ?? 'info';
    final severityColor = _getSeverityColor(severity);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(_getSeverityIcon(severity), color: severityColor, size: 24),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alertData['title'] ?? 'Alert',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  alertData['message'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  alertData['timestamp'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}
