import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/theme_manager_service.dart';
import '../../../widgets/custom_icon_widget.dart';

class VibeAlertsSectionWidget extends StatelessWidget {
  final ThemeManagerService themeManager;
  final bool isEnabled;
  final double threshold;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onThresholdChanged;
  final VoidCallback onPreviewTap;

  const VibeAlertsSectionWidget({
    super.key,
    required this.themeManager,
    required this.isEnabled,
    required this.threshold,
    required this.onToggle,
    required this.onThresholdChanged,
    required this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color vibeColor = themeManager.primaryVibeColor;

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
          _buildHeader(theme, vibeColor),
          if (isEnabled) ...[
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            _buildControls(context, theme, vibeColor),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color vibeColor) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: vibeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'psychology',
              color: vibeColor,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vibe-Based Alerts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Get notified when your vibe shifts',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(value: isEnabled, onChanged: onToggle),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    ThemeData theme,
    Color vibeColor,
  ) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alert Sensitivity',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: vibeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(threshold * 100).toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: vibeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: vibeColor,
              inactiveTrackColor:
                  vibeColor.withValues(alpha: 0.25),
              thumbColor: vibeColor,
              overlayColor: vibeColor.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: threshold,
              min: 0.3,
              max: 1.0,
              divisions: 7,
              onChanged: onThresholdChanged,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Less Sensitive',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
              Text(
                'More Sensitive',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          InkWell(
            onTap: onPreviewTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: vibeColor.withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'visibility',
                    color: vibeColor,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Preview Notification',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: vibeColor,
                      fontWeight: FontWeight.w500,
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
}
