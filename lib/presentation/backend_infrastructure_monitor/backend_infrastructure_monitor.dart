import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/bigquery_service.dart';
import '../../services/infrastructure_monitoring_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/alert_card_widget.dart';
import './widgets/bigquery_metrics_widget.dart';
import './widgets/data_pipeline_widget.dart';
import './widgets/infrastructure_health_widget.dart';
import './widgets/ml_training_widget.dart';
import './widgets/performance_chart_widget.dart';
import './widgets/user_analytics_widget.dart';

/// Backend Infrastructure Monitor provides system administrators and power users
/// visibility into CTRL's scalable architecture with BigQuery integration
class BackendInfrastructureMonitor extends StatefulWidget {
  const BackendInfrastructureMonitor({super.key});

  @override
  State<BackendInfrastructureMonitor> createState() =>
      _BackendInfrastructureMonitorState();
}

class _BackendInfrastructureMonitorState
    extends State<BackendInfrastructureMonitor> {
  final InfrastructureMonitoringService _monitoringService =
      InfrastructureMonitoringService();
  final BigQueryService _bigQueryService = BigQueryService();

  bool _isLoading = true;
  Map<String, dynamic> _infrastructureHealth = {};
  List<Map<String, dynamic>> _recentAlerts = [];

  @override
  void initState() {
    super.initState();
    _loadInfrastructureData();
  }

  Future<void> _loadInfrastructureData() async {
    setState(() => _isLoading = true);

    try {
      final health = await _monitoringService.getInfrastructureHealth();
      final alerts = await _monitoringService.getRecentAlerts();

      setState(() {
        _infrastructureHealth = health;
        _recentAlerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load infrastructure data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Infrastructure Monitor',
        variant: CustomAppBarVariant.withBack,
        vibeColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInfrastructureData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to admin settings
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadInfrastructureData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Infrastructure Health Dashboard
                      InfrastructureHealthWidget(
                        healthData: _infrastructureHealth,
                      ),
                      SizedBox(height: 3.h),

                      // Recent Alerts
                      if (_recentAlerts.isNotEmpty) ...[
                        Text(
                          'Recent Alerts',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ...(_recentAlerts.map(
                          (alert) => Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: AlertCardWidget(alertData: alert),
                          ),
                        )),
                        SizedBox(height: 3.h),
                      ],

                      // Performance Charts
                      Text(
                        'Performance Trends',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      const PerformanceChartWidget(),
                      SizedBox(height: 3.h),

                      // BigQuery Metrics
                      Text(
                        'BigQuery Analytics',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      const BigQueryMetricsWidget(),
                      SizedBox(height: 3.h),

                      // Data Pipeline Status
                      const DataPipelineWidget(),
                      SizedBox(height: 3.h),

                      // ML Training Status
                      const MLTrainingWidget(),
                      SizedBox(height: 3.h),

                      // User Analytics Overview
                      const UserAnalyticsWidget(),
                      SizedBox(height: 2.h),

                      // Export Infrastructure Report
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _exportInfrastructureReport,
                          icon: const Icon(Icons.download),
                          label: const Text('Export Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 1.5.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/backend-infrastructure-monitor',
        onNavigate: (route) {
          if (route != '/backend-infrastructure-monitor') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }

  Future<void> _exportInfrastructureReport() async {
    try {
      await _monitoringService.generateInfrastructureReport();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Infrastructure report exported successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export report: $e')),
        );
      }
    }
  }
}
