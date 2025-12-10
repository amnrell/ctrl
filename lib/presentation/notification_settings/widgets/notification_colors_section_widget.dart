import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/vibe_config.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for notification color selection with all available vibe colors
class NotificationColorsSectionWidget extends StatelessWidget {
  final Set<String> selectedVibes;
  final ValueChanged<String> onVibeToggle;

  const NotificationColorsSectionWidget({
    super.key,
    required this.selectedVibes,
    required this.onVibeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allVibes = VibeConfig.getAllVibes();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'palette',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Colors',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Select which vibes to show in notifications',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children:
                  allVibes.map((vibe) {
                    final isSelected = selectedVibes.contains(vibe.name);
                    return _buildVibeColorCard(
                      context,
                      vibe: vibe,
                      isSelected: isSelected,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onVibeToggle(vibe.name);
                      },
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Tap to select/deselect vibe colors for notifications',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVibeColorCard(
    BuildContext context, {
    required VibeConfig vibe,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final cardWidth = (100.w - 8.w - 6.w) / 3;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? vibe.color.withValues(alpha: 0.15)
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? vibe.color
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: vibe.color,
                shape: BoxShape.circle,
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: vibe.color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                        : null,
              ),
              child:
                  isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 6.w)
                      : null,
            ),
            SizedBox(height: 1.h),
            Text(
              vibe.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color:
                    isSelected
                        ? vibe.color
                        : theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
