import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for usage warnings configuration section
class UsageWarningsSectionWidget extends StatelessWidget {
  final bool doomScrollingEnabled;
  final bool rapidEngagementEnabled;
  final bool dailyLimitEnabled;
  final TimeOfDay dailyLimitTime;
  final ValueChanged<bool> onDoomScrollingToggle;
  final ValueChanged<bool> onRapidEngagementToggle;
  final ValueChanged<bool> onDailyLimitToggle;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const UsageWarningsSectionWidget({
    super.key,
    required this.doomScrollingEnabled,
    required this.rapidEngagementEnabled,
    required this.dailyLimitEnabled,
    required this.dailyLimitTime,
    required this.onDoomScrollingToggle,
    required this.onRapidEngagementToggle,
    required this.onDailyLimitToggle,
    required this.onTimeSelected,
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'warning',
                    color: const Color(0xFFFFC107),
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usage Warnings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Alerts for unhealthy patterns',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
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
          _buildWarningOption(
            context,
            theme,
            icon: 'phone_android',
            title: 'Doom Scrolling Detection',
            description: 'Alert when scrolling for extended periods',
            value: doomScrollingEnabled,
            onChanged: onDoomScrollingToggle,
          ),
          Divider(
            height: 1,
            indent: 16.w,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          _buildWarningOption(
            context,
            theme,
            icon: 'flash_on',
            title: 'Rapid Engagement Warnings',
            description: 'Notify during rapid fire posting/liking',
            value: rapidEngagementEnabled,
            onChanged: onRapidEngagementToggle,
          ),
          Divider(
            height: 1,
            indent: 16.w,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          _buildDailyLimitOption(context, theme),
        ],
      ),
    );
  }

  Widget _buildWarningOption(
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

  Widget _buildDailyLimitOption(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'schedule',
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
                      'Daily Limit Reminders',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Remind at specific time daily',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: dailyLimitEnabled,
                onChanged: onDailyLimitToggle,
              ),
            ],
          ),
          if (dailyLimitEnabled) ...[
            SizedBox(height: 2.h),
            InkWell(
              onTap: () => _selectTime(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Reminder Time',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      dailyLimitTime.format(context),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: dailyLimitTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.primary,
              dayPeriodTextColor: Theme.of(context).colorScheme.primary,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }
}
