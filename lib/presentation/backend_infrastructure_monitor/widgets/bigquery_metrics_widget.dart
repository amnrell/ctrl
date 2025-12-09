import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/bigquery_service.dart';

/// Widget displaying BigQuery-specific monitoring metrics
class BigQueryMetricsWidget extends StatefulWidget {
  const BigQueryMetricsWidget({super.key});

  @override
  State<BigQueryMetricsWidget> createState() => _BigQueryMetricsWidgetState();
}

class _BigQueryMetricsWidgetState extends State<BigQueryMetricsWidget> {
  final BigQueryService _bigQueryService = BigQueryService();
  Map<String, dynamic> _metrics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBigQueryMetrics();
  }

  Future<void> _loadBigQueryMetrics() async {
    setState(() => _isLoading = true);

    try {
      final metrics = await _bigQueryService.getBigQueryMetrics();
      setState(() {
        _metrics = metrics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_queue,
                  color: theme.colorScheme.primary, size: 28),
              SizedBox(width: 2.w),
              Text(
                'BigQuery Status',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildMetricRow(
            'Query Costs',
            '\$${_metrics['queryCosts'] ?? '0.00'}',
            Icons.attach_money,
            theme,
          ),
          SizedBox(height: 1.h),
          _buildMetricRow(
            'Slot Utilization',
            '${_metrics['slotUtilization'] ?? '0'}%',
            Icons.memory,
            theme,
          ),
          SizedBox(height: 1.h),
          _buildMetricRow(
            'Data Freshness',
            _metrics['dataFreshness'] ?? 'Real-time',
            Icons.update,
            theme,
          ),
          SizedBox(height: 1.h),
          _buildMetricRow(
            'Active Jobs',
            '${_metrics['activeJobs'] ?? '0'}',
            Icons.work,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
