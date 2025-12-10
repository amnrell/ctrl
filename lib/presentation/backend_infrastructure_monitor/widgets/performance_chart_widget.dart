import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying historical performance trends with interactive graphs
class PerformanceChartWidget extends StatefulWidget {
  const PerformanceChartWidget({super.key});

  @override
  State<PerformanceChartWidget> createState() => _PerformanceChartWidgetState();
}

class _PerformanceChartWidgetState extends State<PerformanceChartWidget> {
  String _selectedMetric = 'Response Time';

  final Map<String, List<FlSpot>> _performanceData = {
    'Response Time': [
      const FlSpot(0, 45),
      const FlSpot(1, 52),
      const FlSpot(2, 38),
      const FlSpot(3, 55),
      const FlSpot(4, 42),
      const FlSpot(5, 48),
      const FlSpot(6, 41),
    ],
    'Database': [
      const FlSpot(0, 12),
      const FlSpot(1, 15),
      const FlSpot(2, 10),
      const FlSpot(3, 18),
      const FlSpot(4, 13),
      const FlSpot(5, 14),
      const FlSpot(6, 11),
    ],
    'CPU Usage': [
      const FlSpot(0, 45),
      const FlSpot(1, 60),
      const FlSpot(2, 55),
      const FlSpot(3, 70),
      const FlSpot(4, 52),
      const FlSpot(5, 58),
      const FlSpot(6, 48),
    ],
  };

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricButton('Response Time', theme),
              _buildMetricButton('Database', theme),
              _buildMetricButton('CPU Usage', theme),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 30.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}${_getUnit()}',
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()],
                              style: theme.textTheme.bodySmall);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: _getMaxY(),
                lineBarsData: [
                  LineChartBarData(
                    spots: _performanceData[_selectedMetric] ?? [],
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricButton(String metric, ThemeData theme) {
    final isSelected = _selectedMetric == metric;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedMetric = metric),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        foregroundColor:
            isSelected ? Colors.white : theme.colorScheme.onSurface,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        metric,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  String _getUnit() {
    switch (_selectedMetric) {
      case 'Response Time':
      case 'Database':
        return 'ms';
      case 'CPU Usage':
        return '%';
      default:
        return '';
    }
  }

  double _getMaxY() {
    switch (_selectedMetric) {
      case 'Response Time':
        return 80;
      case 'Database':
        return 30;
      case 'CPU Usage':
        return 100;
      default:
        return 100;
    }
  }
}
