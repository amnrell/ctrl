import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/theme_manager_service.dart';

/// Interactive screen time chart with proper null safety and theme initialization
class ScreenTimeChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function(Map<String, dynamic>) onChartTap;
  final String chartType;

  const ScreenTimeChartWidget({
    super.key,
    required this.data,
    required this.onChartTap,
    this.chartType = 'Line',
  });

  @override
  State<ScreenTimeChartWidget> createState() => _ScreenTimeChartWidgetState();
}

class _ScreenTimeChartWidgetState extends State<ScreenTimeChartWidget> {
  int? _touchedIndex;
  bool _isProcessingTouch = false;
  ThemeManagerService? _themeManager;
  bool _isInitialized = false;
  Color? _cachedVibeColor;

  @override
  void initState() {
    super.initState();
    _initializeThemeManager();
  }

  Future<void> _initializeThemeManager() async {
    try {
      _themeManager = ThemeManagerService();
      await _themeManager!.initialize();
      if (mounted) {
        setState(() {
          _cachedVibeColor = _themeManager!.primaryVibeColor;
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Theme manager initialization error: $e');
      if (mounted) {
        setState(() {
          _cachedVibeColor = null;
          _isInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _themeManager = null;
    super.dispose();
  }

  Color _getVibeColor(BuildContext context) {
    if (_cachedVibeColor != null) return _cachedVibeColor!;
    if (_themeManager != null && _isInitialized) {
      return _themeManager!.primaryVibeColor;
    }
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vibeColor = _getVibeColor(context);

    if (!_isInitialized) {
      return Card(
        elevation: 0,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Container(
          height: 30.h,
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: vibeColor),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Screen Time Trend',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: vibeColor,
                  ),
                ),
                Text(
                  '${_calculateTotalHours().toStringAsFixed(1)} hrs',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: vibeColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Chart with constrained height
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 28.h, minHeight: 25.h),
              child: _buildChart(theme, vibeColor),
            ),

            SizedBox(height: 2.h),
            Text(
              widget.chartType == 'Line'
                  ? 'Tap points for details'
                  : widget.chartType == 'Bar'
                      ? 'Tap bars for hourly breakdown'
                      : 'Tap slices for app details',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(ThemeData theme, Color vibeColor) {
    switch (widget.chartType) {
      case 'Bar':
        return _buildBarChart(theme, vibeColor);
      case 'Pie':
        return _buildPieChart(theme, vibeColor);
      case 'Line':
      default:
        return _buildLineChart(theme, vibeColor);
    }
  }

  Widget _buildLineChart(ThemeData theme, Color vibeColor) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
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
                  '${value.toInt()}h',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: vibeColor.withValues(alpha: 0.7),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < widget.data.length) {
                  final dayValue = widget.data[value.toInt()]['day'];
                  return Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      dayValue?.toString() ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: vibeColor.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: widget.data.asMap().entries.map(
              (entry) {
                final hours = entry.value['hours'];
                return FlSpot(
                  entry.key.toDouble(),
                  hours is double ? hours : (hours as num).toDouble(),
                );
              },
            ).toList(),
            isCurved: true,
            color: vibeColor,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: vibeColor,
                  strokeWidth: 2,
                  strokeColor: theme.cardColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  vibeColor.withValues(alpha: 0.3),
                  vibeColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}h',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (event is FlTapUpEvent && !_isProcessingTouch) {
              if (response != null &&
                  response.lineBarSpots != null &&
                  response.lineBarSpots!.isNotEmpty) {
                _isProcessingTouch = true;
                final index = response.lineBarSpots!.first.spotIndex;
                if (index >= 0 && index < widget.data.length) {
                  widget.onChartTap(widget.data[index]);
                }
                Future.delayed(const Duration(milliseconds: 300), () {
                  _isProcessingTouch = false;
                });
              }
            }
          },
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  Widget _buildBarChart(ThemeData theme, Color vibeColor) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
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
                  '${value.toInt()}h',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: vibeColor.withValues(alpha: 0.7),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < widget.data.length) {
                  final dayValue = widget.data[value.toInt()]['day'];
                  return Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      dayValue?.toString() ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: vibeColor.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: widget.data.asMap().entries.map(
          (entry) {
            final hours = entry.value['hours'];
            final hoursValue =
                hours is double ? hours : (hours as num).toDouble();
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: hoursValue,
                  color: _touchedIndex == entry.key
                      ? vibeColor.withValues(alpha: 0.8)
                      : vibeColor,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [vibeColor, vibeColor.withValues(alpha: 0.7)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          },
        ).toList(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)}h',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
            if (event is FlTapUpEvent && !_isProcessingTouch) {
              setState(() {
                if (response != null && response.spot != null) {
                  _isProcessingTouch = true;
                  _touchedIndex = response.spot!.touchedBarGroupIndex;
                  widget.onChartTap(widget.data[_touchedIndex!]);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        _touchedIndex = null;
                        _isProcessingTouch = false;
                      });
                    }
                  });
                }
              });
            }
          },
          handleBuiltInTouches: false,
        ),
      ),
    );
  }

  Widget _buildPieChart(ThemeData theme, Color vibeColor) {
    final colors = [
      vibeColor,
      vibeColor.withValues(alpha: 0.8),
      vibeColor.withValues(alpha: 0.6),
      vibeColor.withValues(alpha: 0.4),
      vibeColor.withValues(alpha: 0.3),
      vibeColor.withValues(alpha: 0.2),
      vibeColor.withValues(alpha: 0.1),
    ];

    return PieChart(
      PieChartData(
        sections: widget.data.asMap().entries.map((entry) {
          final index = entry.key;
          final hours = entry.value['hours'];
          final value = hours is double ? hours : (hours as num).toDouble();
          final dayValue = entry.value['day'];
          final isTouched = index == _touchedIndex;
          final radius = isTouched ? 65.0 : 55.0;

          return PieChartSectionData(
            value: value,
            title:
                '${dayValue?.toString() ?? ''}\n${value.toStringAsFixed(1)}h',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: isTouched ? 12 : 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            color: colors[index % colors.length],
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
            if (event is FlTapUpEvent && !_isProcessingTouch) {
              setState(() {
                if (response != null && response.touchedSection != null) {
                  _isProcessingTouch = true;
                  _touchedIndex = response.touchedSection!.touchedSectionIndex;
                  if (_touchedIndex != null &&
                      _touchedIndex! < widget.data.length) {
                    widget.onChartTap(widget.data[_touchedIndex!]);
                  }
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        _touchedIndex = null;
                        _isProcessingTouch = false;
                      });
                    }
                  });
                }
              });
            }
          },
        ),
      ),
    );
  }

  double _calculateTotalHours() {
    return widget.data.fold(
      0.0,
      (sum, item) {
        final hours = item["hours"];
        final hoursValue =
            hours is double ? hours : (hours as num?)?.toDouble() ?? 0.0;
        return sum + hoursValue;
      },
    );
  }
}
