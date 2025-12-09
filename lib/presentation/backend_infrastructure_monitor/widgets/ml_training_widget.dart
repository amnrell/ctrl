import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying ML training status and model performance
class MLTrainingWidget extends StatelessWidget {
  const MLTrainingWidget({super.key});

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
              Icon(Icons.model_training,
                  color: theme.colorScheme.primary, size: 28),
              SizedBox(width: 2.w),
              Text(
                'ML Training',
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
                child: _buildModelMetric(
                  'Model Accuracy',
                  '94.3%',
                  Icons.check_circle,
                  Colors.green,
                  theme,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildModelMetric(
                  'Training Progress',
                  '78%',
                  Icons.trending_up,
                  Colors.blue,
                  theme,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildModelMetric(
                  'Resource Usage',
                  '3.2 GB',
                  Icons.memory,
                  Colors.orange,
                  theme,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildModelMetric(
                  'Training Time',
                  '2.4 hrs',
                  Icons.timer,
                  Colors.purple,
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModelMetric(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
