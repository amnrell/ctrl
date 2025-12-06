import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../main_dashboard/widgets/dynamic_background_widget.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_breakdown_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/pattern_detection_card_widget.dart';
import './widgets/screen_time_chart_widget.dart';

/// Usage Analytics screen providing comprehensive social media engagement tracking
/// with pattern detection and emotional correlation insights.
///
/// Features:
/// - Date range selection and export functionality
/// - Interactive screen time charts with pinch-to-zoom
/// - App-specific usage breakdowns
/// - Pattern detection alerts (rapid-fire tweeting, doom scrolling, spontaneous liking)
/// - Swipe-to-reveal detailed breakdowns
/// - Tap-to-drill-down hourly patterns
/// - Pull-to-refresh data sync
/// - Filter customization via bottom sheet
/// - Vibe-themed interface colors
class UsageAnalytics extends StatefulWidget {
  const UsageAnalytics({super.key});

  @override
  State<UsageAnalytics> createState() => _UsageAnalyticsState();
}

class _UsageAnalyticsState extends State<UsageAnalytics> {
  final ThemeManagerService _themeManager = ThemeManagerService();

  bool _isLoading = false;
  String _selectedDateRange = 'This Week';
  DateTime _lastUpdated = DateTime.now();

  // Mock data for demonstration with refined terminology
  final Map<String, dynamic> _analyticsData = {
    'screenTime': [
      {'day': 'Mon', 'hours': 4.2},
      {'day': 'Tue', 'hours': 5.1},
      {'day': 'Wed', 'hours': 3.8},
      {'day': 'Thu', 'hours': 6.3},
      {'day': 'Fri', 'hours': 4.9},
      {'day': 'Sat', 'hours': 7.2},
      {'day': 'Sun', 'hours': 5.5},
    ],
    'patterns': [
      {
        'id': 1,
        'type': 'Excessive Content Consumption',
        'description':
            'Prolonged content viewing detected during evening hours',
        'severity': 'medium',
        'icon': 'visibility',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'vibe': 'Reflective',
      },
      {
        'id': 2,
        'type': 'High-Frequency Interactions',
        'description': 'Rapid engagement pattern observed across platforms',
        'severity': 'high',
        'icon': 'touch_app',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'vibe': 'Energized',
      },
      {
        'id': 3,
        'type': 'Continuous Scrolling Behavior',
        'description': 'Extended scrolling session detected on social feeds',
        'severity': 'low',
        'icon': 'swap_vert',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'vibe': 'Zen',
      },
    ],
    'appBreakdown': [
      {
        'name': 'Instagram',
        'hours': 12.5,
        'percentage': 35,
        'icon': 'photo_camera',
      },
      {'name': 'Twitter', 'hours': 8.3, 'percentage': 23, 'icon': 'chat'},
      {
        'name': 'TikTok',
        'hours': 7.2,
        'percentage': 20,
        'icon': 'video_library',
      },
      {'name': 'Facebook', 'hours': 5.1, 'percentage': 14, 'icon': 'thumb_up'},
      {'name': 'Others', 'hours': 2.9, 'percentage': 8, 'icon': 'more_horiz'},
    ],
  };

  // Add getters for accessing analytics data
  List<Map<String, dynamic>> get _screenTimeData =>
      (_analyticsData['screenTime'] as List).cast<Map<String, dynamic>>();

  List<Map<String, dynamic>> get _patternDetections =>
      (_analyticsData['patterns'] as List).cast<Map<String, dynamic>>();

  List<Map<String, dynamic>> get _appBreakdown =>
      (_analyticsData['appBreakdown'] as List).cast<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();

    // Listen to theme manager changes for real-time vibe color updates
    _themeManager.addListener(() {
      if (mounted) {
        setState(() {
          // Force rebuild when vibe color changes
        });
      }
    });
  }

  @override
  void dispose() {
    _themeManager.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Usage Analytics',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _currentVibeColor,
      ),
      body: Stack(
        children: [
          // Dynamic background matching main dashboard
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _currentVibeColor,
              secondaryColor: _themeManager.secondaryVibeColor,
            ),
          ),

          // Main content
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: theme.colorScheme.primary,
            child: CustomScrollView(
              slivers: [
                // Date Range Selector (Sticky Header)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    child: DateRangeSelectorWidget(
                      selectedRange: _selectedDateRange,
                      onRangeChanged: _handleDateRangeChange,
                      onFilterPressed: _showFilterBottomSheet,
                    ),
                  ),
                ),

                // Last Updated Info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'sync',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Last updated: ${_formatLastUpdated()}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Screen Time Chart
                SliverToBoxAdapter(
                  child: ScreenTimeChartWidget(
                    data: _screenTimeData,
                    onChartTap: _handleChartTap,
                  ),
                ),

                SizedBox(height: 2.h).toSliver(),

                // App Breakdown
                SliverToBoxAdapter(
                  child: AppBreakdownWidget(
                    apps: _appBreakdown,
                    onAppTap: _handleAppTap,
                  ),
                ),

                SizedBox(height: 2.h).toSliver(),

                // Pattern Detection Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'warning',
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Pattern Detections',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Pattern Detection Cards
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return PatternDetectionCardWidget(
                      pattern: _patternDetections[index],
                      onTap: () => _handlePatternTap(_patternDetections[index]),
                      onSwipeLeft: () =>
                          _handlePatternSwipe(_patternDetections[index]),
                    );
                  }, childCount: _patternDetections.length),
                ),

                SizedBox(height: 10.h).toSliver(),
              ],
            ),
          ),
          // Floating action button for export
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _handleExport,
              backgroundColor: _currentVibeColor,
              child: Icon(Icons.download, color: Colors.white),
            ),
          ),
        ],
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

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Analytics updated successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleDateRangeChange(String range) {
    setState(() {
      _selectedDateRange = range;
    });
  }

  void _handleExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exporting analytics report...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleChartTap(Map<String, dynamic> dataPoint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${dataPoint["day"]} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Screen Time: ${dataPoint["hours"]} hours'),
            SizedBox(height: 1.h),
            Text(
                'Average: ${((dataPoint["hours"] as double) / 7).toStringAsFixed(1)} hours/day'),
            SizedBox(height: 1.h),
            Text('Current Vibe: ${_getVibeNameFromColor(_currentVibeColor)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleAppTap(Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${app["name"]} Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Time: ${app["hours"]} hours'),
            SizedBox(height: 1.h),
            Text('Percentage: ${app["percentage"]}%'),
            SizedBox(height: 1.h),
            Text(
              'Average Daily: ${((app["hours"] as double) / 7).toStringAsFixed(1)} hours',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handlePatternTap(Map<String, dynamic> pattern) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pattern["type"] as String),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 1.h),
              Text(pattern["description"] as String),
              SizedBox(height: 2.h),
              Text(
                'Severity',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: _getSeverityColor(
                    pattern["severity"] as String,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (pattern["severity"] as String).toUpperCase(),
                  style: TextStyle(
                    color: _getSeverityColor(pattern["severity"] as String),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Detected',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(_formatTimestamp(pattern["timestamp"] as DateTime)),
              SizedBox(height: 2.h),
              Text(
                'Associated Vibe',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(pattern["vibe"] as String),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _handlePatternSwipe(Map<String, dynamic> pattern) {
    _handlePatternTap(pattern);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onApplyFilters: (filters) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Filters applied successfully'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalTimeCard(ThemeData theme, double totalTime) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _themeManager.primaryVibeColor, // Synced gradient colors
            _themeManager.primaryVibeColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _themeManager.primaryVibeColor.withValues(
              alpha: 0.3,
            ), // Synced shadow
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Time: ${totalTime.toStringAsFixed(1)} hours',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: _themeManager.primaryVibeColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Vibe: ${_getVibeNameFromColor(_themeManager.primaryVibeColor)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: _themeManager.primaryVibeColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAppUsage() {
    return _appBreakdown;
  }

  String _getVibeNameFromColor(Color color) {
    if (color.value == const Color(0xFF4A7C59).value) return 'Zen';
    if (color.value == const Color(0xFFE8B86D).value) return 'Energy';
    if (color.value == const Color(0xFF6B73FF).value) return 'Reflection';
    return 'Custom';
  }

  Color get _currentVibeColor => _themeManager.primaryVibeColor;
}

/// Sticky header delegate for date range selector
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 8.h;

  @override
  double get maxExtent => 8.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return false;
  }
}

/// Extension to convert SizedBox to Sliver
extension SizedBoxSliver on SizedBox {
  Widget toSliver() {
    return SliverToBoxAdapter(child: this);
  }
}
