import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/theme_manager_service.dart';

class WellbeingTabWidget extends StatelessWidget {
  final ThemeManagerService themeManager;

  const WellbeingTabWidget({
    super.key,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            theme,
            title: 'Wellbeing',
            subtitle:
                'Tools designed to help you pause, reflect, and regain balance.',
          ),
          SizedBox(height: 2.h),

          _neutralCard(
            theme,
            icon: Icons.insights_outlined,
            title: 'Behavior Pattern Awareness',
            description:
                'CTRL observes patterns like excessive scrolling, rapid interactions, and prolonged sessions — without judgment.',
          ),

          SizedBox(height: 2.h),

          _neutralCard(
            theme,
            icon: Icons.self_improvement_outlined,
            title: 'Reflection Over Reaction',
            description:
                'Instead of alerts that demand attention, Wellbeing tools encourage mindful pauses and self-awareness.',
          ),

          SizedBox(height: 2.h),

          _neutralCard(
            theme,
            icon: Icons.lock_outline,
            title: 'Private by Design',
            description:
                'Wellbeing insights stay on your device. Nothing here is shared, tracked, or monetized.',
          ),

          SizedBox(height: 3.h),

          Divider(
            color: theme.colorScheme.outline.withOpacity(0.15),
          ),

          SizedBox(height: 2.h),

          Text(
            'More tools will appear here as CTRL learns how to better support healthy engagement.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    ThemeData theme, {
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _neutralCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
