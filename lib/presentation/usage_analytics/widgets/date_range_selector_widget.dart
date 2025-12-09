import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Date range selector widget with filter button for usage analytics
class DateRangeSelectorWidget extends StatelessWidget {
  final String selectedRange;
  final ValueChanged<String> onRangeChanged;
  final VoidCallback onFilterPressed;

  const DateRangeSelectorWidget({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ranges = ['Today', 'This Week', 'This Month', 'All Time'];

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ranges.map((range) {
                  final isSelected = range == selectedRange;
                  return Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: FilterChip(
                      label: Text(range),
                      selected: isSelected,
                      onSelected: (_) => onRangeChanged(range),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      selectedColor:
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'tune',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: onFilterPressed,
            tooltip: 'Filter Options',
          ),
        ],
      ),
    );
  }
}
