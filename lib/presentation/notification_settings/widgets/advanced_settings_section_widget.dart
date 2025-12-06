import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for advanced notification settings section
class AdvancedSettingsSectionWidget extends StatelessWidget {
  final bool isExpanded;
  final bool soundsEnabled;
  final bool vibrationEnabled;
  final bool lockScreenEnabled;
  final VoidCallback onExpandToggle;
  final ValueChanged<bool> onSoundsToggle;
  final ValueChanged<bool> onVibrationToggle;
  final ValueChanged<bool> onLockScreenToggle;

  const AdvancedSettingsSectionWidget({
    super.key,
    required this.isExpanded,
    required this.soundsEnabled,
    required this.vibrationEnabled,
    required this.lockScreenEnabled,
    required this.onExpandToggle,
    required this.onSoundsToggle,
    required this.onVibrationToggle,
    required this.onLockScreenToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          InkWell(
            onTap: onExpandToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'tune',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Settings',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Customize notification behavior',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'expand_more',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            _buildAdvancedOption(
              context,
              theme,
              icon: 'volume_up',
              title: 'Notification Sounds',
              description: 'Play sound for notifications',
              value: soundsEnabled,
              onChanged: onSoundsToggle,
            ),
            Divider(
              height: 1,
              indent: 16.w,
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
            _buildAdvancedOption(
              context,
              theme,
              icon: 'vibration',
              title: 'Vibration Patterns',
              description: 'Haptic feedback for alerts',
              value: vibrationEnabled,
              onChanged: onVibrationToggle,
            ),
            Divider(
              height: 1,
              indent: 16.w,
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
            _buildAdvancedOption(
              context,
              theme,
              icon: 'lock_screen',
              title: 'Lock Screen Display',
              description: 'Show notifications on lock screen',
              value: lockScreenEnabled,
              onChanged: onLockScreenToggle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdvancedOption(
    BuildContext context,
    ThemeData theme, {
    required String icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
