import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_image_widget.dart';

/// Enhanced analytics page with social media platform tracking
class UsageAnalytics extends StatefulWidget {
  const UsageAnalytics({super.key});

  @override
  State<UsageAnalytics> createState() => _UsageAnalyticsState();
}

class _UsageAnalyticsState extends State<UsageAnalytics> {
  String _selectedChartType = 'Line';
  String _selectedPlatform = 'All';

  // Social media platforms with tracking status
  final List<Map<String, dynamic>> _socialPlatforms = [
    {
      'name': 'Instagram',
      'icon':
          'https://images.unsplash.com/photo-1611262588024-d12430b98920?w=100',
      'color': const Color(0xFFE1306C),
      'isTracked': true,
      'weeklyHours': 12.5,
      'dailyAverage': 1.8,
    },
    {
      'name': 'TikTok',
      'icon':
          'https://images.unsplash.com/photo-1633613286991-611fe299c4be?w=100',
      'color': const Color(0xFF000000),
      'isTracked': true,
      'weeklyHours': 18.2,
      'dailyAverage': 2.6,
    },
    {
      'name': 'X',
      'icon':
          'https://images.unsplash.com/photo-1611605698335-8b1569810432?w=100',
      'color': const Color(0xFF000000),
      'isTracked': true,
      'weeklyHours': 8.4,
      'dailyAverage': 1.2,
    },
    {
      'name': 'Reddit',
      'icon':
          'https://images.unsplash.com/photo-1616469829935-c6e4f1b3e13f?w=100',
      'color': const Color(0xFFFF4500),
      'isTracked': true,
      'weeklyHours': 10.3,
      'dailyAverage': 1.5,
    },
    {
      'name': 'Facebook',
      'icon':
          'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=100',
      'color': const Color(0xFF1877F2),
      'isTracked': false,
      'weeklyHours': 0.0,
      'dailyAverage': 0.0,
    },
    {
      'name': 'YouTube',
      'icon':
          'https://images.unsplash.com/photo-1611162616305-c69b3fa7fbe0?w=100',
      'color': const Color(0xFFFF0000),
      'isTracked': true,
      'weeklyHours': 15.3,
      'dailyAverage': 2.2,
    },
    {
      'name': 'Snapchat',
      'icon':
          'https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=100',
      'color': const Color(0xFFFFFC00),
      'isTracked': false,
      'weeklyHours': 0.0,
      'dailyAverage': 0.0,
    },
  ];

  // Platform-specific weekly data
  final Map<String, List<Map<String, dynamic>>> _platformWeekData = {
    'Instagram': [
      {'day': 'Mon', 'hours': 1.5},
      {'day': 'Tue', 'hours': 2.1},
      {'day': 'Wed', 'hours': 1.8},
      {'day': 'Thu', 'hours': 2.3},
      {'day': 'Fri', 'hours': 1.9},
      {'day': 'Sat', 'hours': 1.7},
      {'day': 'Sun', 'hours': 1.2},
    ],
    'TikTok': [
      {'day': 'Mon', 'hours': 2.8},
      {'day': 'Tue', 'hours': 3.2},
      {'day': 'Wed', 'hours': 2.4},
      {'day': 'Thu', 'hours': 2.9},
      {'day': 'Fri', 'hours': 2.6},
      {'day': 'Sat', 'hours': 2.1},
      {'day': 'Sun', 'hours': 2.2},
    ],
    'X': [
      {'day': 'Mon', 'hours': 1.2},
      {'day': 'Tue', 'hours': 1.4},
      {'day': 'Wed', 'hours': 1.1},
      {'day': 'Thu', 'hours': 1.3},
      {'day': 'Fri', 'hours': 1.2},
      {'day': 'Sat', 'hours': 1.0},
      {'day': 'Sun', 'hours': 1.2},
    ],
    'Reddit': [
      {'day': 'Mon', 'hours': 1.5},
      {'day': 'Tue', 'hours': 1.7},
      {'day': 'Wed', 'hours': 1.3},
      {'day': 'Thu', 'hours': 1.6},
      {'day': 'Fri', 'hours': 1.4},
      {'day': 'Sat', 'hours': 1.2},
      {'day': 'Sun', 'hours': 1.6},
    ],
    'YouTube': [
      {'day': 'Mon', 'hours': 2.2},
      {'day': 'Tue', 'hours': 2.5},
      {'day': 'Wed', 'hours': 2.1},
      {'day': 'Thu', 'hours': 2.4},
      {'day': 'Fri', 'hours': 2.3},
      {'day': 'Sat', 'hours': 1.9},
      {'day': 'Sun', 'hours': 1.9},
    ],
  };

  // Get aggregated data for all platforms
  List<Map<String, dynamic>> get _weekData {
    if (_selectedPlatform == 'All') {
      return List.generate(7, (index) {
        double totalHours = 0;
        String day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];

        _platformWeekData.forEach((platform, data) {
          if (_getPlatformByName(platform)['isTracked']) {
            totalHours += (data[index]['hours'] as num).toDouble();
          }
        });

        return {'day': day, 'hours': totalHours};
      });
    } else {
      return _platformWeekData[_selectedPlatform] ?? [];
    }
  }

  Map<String, dynamic> _getPlatformByName(String name) {
    return _socialPlatforms.firstWhere(
      (p) => p['name'] == name,
      orElse: () => {'isTracked': false},
    );
  }

  List<Map<String, dynamic>> get _trackedPlatforms {
    return _socialPlatforms.where((p) => p['isTracked'] as bool).toList();
  }

  double get _totalWeeklyHours {
    return _trackedPlatforms.fold(
      0.0,
      (sum, platform) => sum + (platform['weeklyHours'] as num).toDouble(),
    );
  }

  double get _averageDailyHours {
    return _totalWeeklyHours / 7;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Social Media Analytics',
        variant: CustomAppBarVariant.withBack,
        vibeColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tracked Platforms Summary
              _buildTrackedPlatformsSummary(theme),
              SizedBox(height: 3.h),

              // Platform Filter Selector
              _buildPlatformSelector(theme),
              SizedBox(height: 3.h),

              // Chart Type Selector
              Text(
                'Chart Type',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  _buildChartTypeButton('Line', theme),
                  SizedBox(width: 2.w),
                  _buildChartTypeButton('Bar', theme),
                  SizedBox(width: 2.w),
                  _buildChartTypeButton('Pie', theme),
                ],
              ),
              SizedBox(height: 3.h),

              // Chart Title
              Text(
                _selectedPlatform == 'All'
                    ? 'Weekly Total Screen Time'
                    : '$_selectedPlatform Usage',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),

              // Chart Container
              Container(
                height: 40.h,
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
                child: _buildChart(theme),
              ),
              SizedBox(height: 2.h),

              // Stats Summary
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Total',
                      '${_totalWeeklyHours.toStringAsFixed(1)}h',
                      theme,
                    ),
                    _buildStatItem(
                      'Daily Avg',
                      '${_averageDailyHours.toStringAsFixed(1)}h',
                      theme,
                    ),
                    _buildStatItem(
                      'Tracked',
                      '${_trackedPlatforms.length}',
                      theme,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // Platform Breakdown
              _buildPlatformBreakdown(theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/usage-analytics',
        onNavigate: (route) {
          if (route != '/usage-analytics') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }

  Widget _buildTrackedPlatformsSummary(ThemeData theme) {
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
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radar, color: theme.colorScheme.primary, size: 24),
              SizedBox(width: 2.w),
              Text(
                'Active Tracking',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children:
                _trackedPlatforms
                    .map((platform) => _buildPlatformChip(platform, theme))
                    .toList(),
          ),
          if (_trackedPlatforms.isEmpty)
            Text(
              'No platforms are being tracked',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(Map<String, dynamic> platform, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: (platform['color'] as Color).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: platform['color'] as Color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: platform['color'] as Color,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            platform['name'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Platform',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPlatformFilterButton('All', theme),
              SizedBox(width: 2.w),
              ..._trackedPlatforms.map((platform) {
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: _buildPlatformFilterButton(
                    platform['name'] as String,
                    theme,
                    color: platform['color'] as Color,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformFilterButton(
    String name,
    ThemeData theme, {
    Color? color,
  }) {
    final isSelected = _selectedPlatform == name;
    final buttonColor = color ?? theme.colorScheme.primary;

    return ElevatedButton(
      onPressed: () => setState(() => _selectedPlatform = name),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected
                ? buttonColor
                : theme.colorScheme.surfaceContainerHighest,
        foregroundColor:
            isSelected ? Colors.white : theme.colorScheme.onSurface,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPlatformBreakdown(ThemeData theme) {
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
          Text(
            'Platform Breakdown',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          ..._socialPlatforms.map((platform) {
            final isTracked = platform['isTracked'] as bool;
            return Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: _buildPlatformRow(platform, isTracked, theme),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlatformRow(
    Map<String, dynamic> platform,
    bool isTracked,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          platform['isTracked'] = !isTracked;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color:
              isTracked
                  ? (platform['color'] as Color).withValues(alpha: 0.1)
                  : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isTracked
                    ? platform['color'] as Color
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isTracked ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Platform Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (platform['color'] as Color).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomImageWidget(
                  imageUrl: platform['icon'] as String,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  semanticLabel:
                      '${platform['name']} social media platform icon',
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // Platform Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        platform['name'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isTracked
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isTracked ? 'TRACKING' : 'OFF',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isTracked ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isTracked) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      '${platform['weeklyHours']}h this week • ${platform['dailyAverage']}h daily avg',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      'Tap to enable tracking',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Toggle Icon
            Icon(
              isTracked ? Icons.toggle_on : Icons.toggle_off,
              color: isTracked ? Colors.green : Colors.grey,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTypeButton(String type, ThemeData theme) {
    final isSelected = _selectedChartType == type;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedChartType = type),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
          foregroundColor:
              isSelected ? Colors.white : theme.colorScheme.onSurface,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          type,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildChart(ThemeData theme) {
    switch (_selectedChartType) {
      case 'Bar':
        return _buildBarChart(theme);
      case 'Pie':
        return _buildPieChart(theme);
      default:
        return _buildLineChart(theme);
    }
  }

  Widget _buildLineChart(ThemeData theme) {
    final chartColor =
        _selectedPlatform == 'All'
            ? theme.colorScheme.primary
            : _getPlatformByName(_selectedPlatform)['color'] as Color? ??
                theme.colorScheme.primary;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
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
                  '${value.toInt()}h',
                  style: theme.textTheme.bodySmall,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < _weekData.length) {
                  return Text(
                    _weekData[value.toInt()]['day'],
                    style: theme.textTheme.bodySmall,
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY:
            _weekData
                .map((d) => d['hours'] as double)
                .reduce((a, b) => a > b ? a : b) +
            1,
        lineBarsData: [
          LineChartBarData(
            spots:
                _weekData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value['hours']))
                    .toList(),
            isCurved: true,
            color: chartColor,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: chartColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: chartColor.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(ThemeData theme) {
    final chartColor =
        _selectedPlatform == 'All'
            ? theme.colorScheme.primary
            : _getPlatformByName(_selectedPlatform)['color'] as Color? ??
                theme.colorScheme.primary;

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
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
                  '${value.toInt()}h',
                  style: theme.textTheme.bodySmall,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < _weekData.length) {
                  return Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      _weekData[value.toInt()]['day'],
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY:
            _weekData
                .map((d) => d['hours'] as double)
                .reduce((a, b) => a > b ? a : b) +
            1,
        barGroups:
            _weekData
                .asMap()
                .entries
                .map(
                  (e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value['hours'],
                        color: chartColor,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildPieChart(ThemeData theme) {
    if (_selectedPlatform != 'All') {
      // Show single platform pie chart with daily breakdown
      final colors = [
        Colors.red,
        Colors.orange,
        Colors.amber,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
      ];

      return PieChart(
        PieChartData(
          sections:
              _weekData
                  .asMap()
                  .entries
                  .map(
                    (e) => PieChartSectionData(
                      value: e.value['hours'],
                      title: '${e.value['day']}\n${e.value['hours']}h',
                      color: colors[e.key % colors.length],
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                  .toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      );
    }

    // Show platform comparison pie chart
    return PieChart(
      PieChartData(
        sections:
            _trackedPlatforms
                .map(
                  (platform) => PieChartSectionData(
                    value: (platform['weeklyHours'] as num).toDouble(),
                    title: '${platform['name']}\n${platform['weeklyHours']}h',
                    color: platform['color'] as Color,
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
                .toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildStatItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
