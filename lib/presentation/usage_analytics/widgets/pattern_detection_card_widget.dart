import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/theme_manager_service.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Pattern detection card with swipe-to-reveal functionality and real-time vibe theming
class PatternDetectionCardWidget extends StatefulWidget {
  final Map<String, dynamic> pattern;
  final VoidCallback onTap;
  final VoidCallback onSwipeLeft;

  const PatternDetectionCardWidget({
    super.key,
    required this.pattern,
    required this.onTap,
    required this.onSwipeLeft,
  });

  @override
  State<PatternDetectionCardWidget> createState() =>
      _PatternDetectionCardWidgetState();
}

class _PatternDetectionCardWidgetState
    extends State<PatternDetectionCardWidget> {
  final ThemeManagerService _themeManager = ThemeManagerService();

  @override
  void initState() {
    super.initState();
    // Listen to theme changes for real-time vibe color updates
    _themeManager.addListener(_handleThemeChange);
  }

  void _handleThemeChange() {
    if (mounted) {
      setState(() {
        // Force rebuild when vibe color changes
      });
    }
  }

  @override
  void dispose() {
    _themeManager.removeListener(_handleThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor =
        _getSeverityColor(widget.pattern["severity"] as String, theme);

    // Use theme manager for consistent vibe coloring with real-time updates
    final Color vibeColor = _themeManager.primaryVibeColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(widget.pattern["id"]),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onSwipeLeft(),
              backgroundColor: vibeColor, // Real-time vibe color
              foregroundColor: theme.colorScheme.onPrimary,
              icon: Icons.info_outline,
              label: 'Details',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Severity Indicator
                      Container(
                        width: 1.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: severityColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Pattern Icon with real-time vibe color
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: vibeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: widget.pattern["icon"] as String,
                            color: vibeColor, // Real-time icon color
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Pattern Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pattern["type"] as String,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              widget.pattern["description"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Timestamp and Vibe
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatTimestamp(
                                widget.pattern["timestamp"] as DateTime),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: vibeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.pattern["vibe"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: vibeColor, // Real-time badge color
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),

                  // Swipe hint
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'swipe_left',
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Swipe left for AI analysis',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity, ThemeData theme) {
    switch (severity) {
      case 'high':
        return theme.colorScheme.error;
      case 'medium':
        return const Color(0xFFFFC107);
      case 'low':
        return const Color(0xFF28A745);
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
