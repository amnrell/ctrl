import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/bigquery_data_service.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/analytics_metric_card_widget.dart';
import './widgets/data_pipeline_status_widget.dart';
import './widgets/platform_breakdown_widget.dart';

/// Data Analytics Dashboard Screen
/// Provides comprehensive insights into social media patterns with BigQuery integration
class DataAnalyticsDashboard extends StatefulWidget {
  const DataAnalyticsDashboard({super.key});

  @override
  State<DataAnalyticsDashboard> createState() => _DataAnalyticsDashboardState();
}

class _DataAnalyticsDashboardState extends State<DataAnalyticsDashboard>
    with SingleTickerProviderStateMixin {
  final BigQueryDataService _bigQueryService = BigQueryDataService();

  late TabController _tabController;
  bool _isLoading = true;
  Map<String, dynamic>? _analyticsData;
  String _selectedTimeRange = 'Week';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    try {
      await _bigQueryService.initialize();

      final endDate = DateTime.now();
      final startDate = _getStartDateForRange(endDate);

      final data = await _bigQueryService.getAggregatedAnalytics(
        startDate: startDate,
        endDate: endDate,
      );

      setState(() {
        _analyticsData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading analytics: $e');
      setState(() => _isLoading = false);
    }
  }

  DateTime _getStartDateForRange(DateTime end) {
    switch (_selectedTimeRange) {
      case 'Day':
        return end.subtract(const Duration(days: 1));
      case 'Week':
        return end.subtract(const Duration(days: 7));
      case 'Month':
        return end.subtract(const Duration(days: 30));
      case 'Year':
        return end.subtract(const Duration(days: 365));
      default:
        return end.subtract(const Duration(days: 7));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Analytics Dashboard',
        variant: CustomAppBarVariant.withBack,
        onLeadingPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : SafeArea(
              child: Column(
                children: [
                  _buildTimeRangeSelector(theme),
                  _buildTabBar(theme),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPersonalAnalyticsTab(theme),
                        _buildTrendAnalysisTab(theme),
                        _buildModelPerformanceTab(theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTimeRangeSelector(ThemeData theme) {
    final ranges = ['Day', 'Week', 'Month', 'Year'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(0.5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: ranges
            .map(
              (range) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedTimeRange = range);
                    _loadAnalytics();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _selectedTimeRange == range
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      range,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _selectedTimeRange == range
                            ? Colors.white
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        fontWeight: _selectedTimeRange == range
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle:
            theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Trends'),
          Tab(text: 'AI Model'),
        ],
      ),
    );
  }

  Widget _buildPersonalAnalyticsTab(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsGrid(theme),
            SizedBox(height: 3.h),
            DataPipelineStatusWidget(
              isConfigured: _bigQueryService.isConfigured(),
              isMockData: _analyticsData?['is_mock'] ?? false,
            ),
            SizedBox(height: 3.h),
            PlatformBreakdownWidget(
              platformData: _analyticsData?['data'] ?? [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendAnalysisTab(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Trends',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),
            _buildTrendChart(theme),
            SizedBox(height: 3.h),
            _buildComparativeInsights(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildModelPerformanceTab(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Model Performance',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),
            _buildModelMetrics(theme),
            SizedBox(height: 3.h),
            _buildTrainingProgress(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(ThemeData theme) {
    final data = _analyticsData?['data'] as List? ?? [];
    final totalInteractions = data.fold<int>(
      0,
      (sum, item) => sum + ((item['total_interactions'] as num?)?.toInt() ?? 0),
    );
    final avgDuration = data.isEmpty
        ? 0.0
        : data.fold<double>(
              0,
              (sum, item) =>
                  sum +
                  ((item['avg_session_duration'] as num?)?.toDouble() ?? 0),
            ) /
            data.length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.5,
      children: [
        AnalyticsMetricCardWidget(
          title: 'Total Data Points',
          value: totalInteractions.toString(),
          icon: Icons.data_usage,
          color: Colors.blue,
        ),
        AnalyticsMetricCardWidget(
          title: 'Avg Session',
          value: '${avgDuration.toStringAsFixed(1)}m',
          icon: Icons.timer,
          color: Colors.purple,
        ),
        AnalyticsMetricCardWidget(
          title: 'Platforms',
          value: data.length.toString(),
          icon: Icons.hub,
          color: Colors.orange,
        ),
        AnalyticsMetricCardWidget(
          title: 'Accuracy',
          value: '94.2%',
          icon: Icons.insights,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildTrendChart(ThemeData theme) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 5),
                const FlSpot(2, 4),
                const FlSpot(3, 7),
                const FlSpot(4, 6),
                const FlSpot(5, 8),
                const FlSpot(6, 9),
              ],
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparativeInsights(ThemeData theme) {
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
          Text(
            'Key Insights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInsightRow(theme, '↑ 23%', 'Usage increase this week'),
          _buildInsightRow(theme, '↓ 15%', 'Scrolling depth decreased'),
          _buildInsightRow(theme, '↑ 34%', 'Engagement improved'),
        ],
      ),
    );
  }

  Widget _buildInsightRow(ThemeData theme, String metric, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: metric.startsWith('↑')
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              metric,
              style: theme.textTheme.bodySmall?.copyWith(
                color: metric.startsWith('↑') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            description,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildModelMetrics(ThemeData theme) {
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
        children: [
          _buildModelMetricRow(
              theme, 'Prediction Accuracy', 94.2, Colors.green),
          _buildModelMetricRow(theme, 'Training Progress', 78.5, Colors.blue),
          _buildModelMetricRow(theme, 'Data Quality', 91.8, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildModelMetricRow(
      ThemeData theme, String label, double value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 8,
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingProgress(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.model_training,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Active Training',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Model is currently processing ${_analyticsData?['data']?.length ?? 0} data sources to improve prediction accuracy and personalization.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
