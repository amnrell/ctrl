import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying critical infrastructure health metrics with color-coded status indicators
class InfrastructureHealthWidget extends StatelessWidget {
  final Map<String, dynamic> healthData;

  const InfrastructureHealthWidget({
    super.key,
    required this.healthData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety,
                  color: theme.colorScheme.primary, size: 28),
              SizedBox(width: 2.w),
              Text(
                'System Health',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildHealthMetric(
                  'API Response',
                  healthData['apiResponseTime'] ?? '45ms',
                  _getHealthStatus(healthData['apiHealth'] ?? 'good'),
                  theme,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildHealthMetric(
                  'Database',
                  healthData['dbQueryTime'] ?? '12ms',
                  _getHealthStatus(healthData['dbHealth'] ?? 'good'),
                  theme,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildHealthMetric(
                  'BigQuery',
                  healthData['bigQueryStatus'] ?? 'Active',
                  _getHealthStatus(healthData['bigQueryHealth'] ?? 'good'),
                  theme,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildHealthMetric(
                  'OAuth',
                  healthData['oauthStatus'] ?? 'Online',
                  _getHealthStatus(healthData['oauthHealth'] ?? 'good'),
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(
    String label,
    String value,
    Color statusColor,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthStatus(String status) {
    switch (status.toLowerCase()) {
      case 'good':
      case 'healthy':
      case 'online':
      case 'active':
        return Colors.green;
      case 'warning':
      case 'degraded':
        return Colors.orange;
      case 'critical':
      case 'down':
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
