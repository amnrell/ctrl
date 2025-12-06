import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Filter bottom sheet for customizing tracking parameters
class FilterBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  final List<String> _selectedApps = ['Twitter', 'Instagram'];
  final List<String> _selectedVibes = ['Zen', 'Energy'];
  double _notificationThreshold = 4.0;

  final List<String> _availableApps = [
    'Twitter',
    'Instagram',
    'TikTok',
    'Facebook',
    'LinkedIn',
    'Reddit',
  ];

  final List<String> _availableVibes = [
    'Zen',
    'Energy',
    'Reflection',
    'Calm',
    'Focused',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Options',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: theme.colorScheme.outline),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Apps Filter
                    Text(
                      'Track Apps',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _availableApps.map((app) {
                        final isSelected = _selectedApps.contains(app);
                        return FilterChip(
                          label: Text(app),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedApps.add(app);
                              } else {
                                _selectedApps.remove(app);
                              }
                            });
                          },
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor:
                              theme.colorScheme.primary.withValues(alpha: 0.15),
                          labelStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 3.h),

                    // Vibes Filter
                    Text(
                      'Track Vibes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _availableVibes.map((vibe) {
                        final isSelected = _selectedVibes.contains(vibe);
                        return FilterChip(
                          label: Text(vibe),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedVibes.add(vibe);
                              } else {
                                _selectedVibes.remove(vibe);
                              }
                            });
                          },
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor:
                              theme.colorScheme.primary.withValues(alpha: 0.15),
                          labelStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 3.h),

                    // Notification Threshold
                    Text(
                      'Notification Threshold',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _notificationThreshold,
                            min: 1.0,
                            max: 8.0,
                            divisions: 7,
                            label:
                                '${_notificationThreshold.toStringAsFixed(1)} hours',
                            onChanged: (value) {
                              setState(() {
                                _notificationThreshold = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${_notificationThreshold.toStringAsFixed(1)}h',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Get notified when daily usage exceeds this threshold',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Apply Button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters({
                      'apps': _selectedApps,
                      'vibes': _selectedVibes,
                      'threshold': _notificationThreshold,
                    });
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
