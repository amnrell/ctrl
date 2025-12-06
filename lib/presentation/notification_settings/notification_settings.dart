import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_settings_section_widget.dart';
import './widgets/ai_recommendations_section_widget.dart';
import './widgets/quiet_hours_section_widget.dart';
import './widgets/usage_warnings_section_widget.dart';
import './widgets/vibe_alerts_section_widget.dart';

/// Notification Settings screen for personalized alert configuration
/// based on emotional states and usage patterns with granular control options
class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  // Notification status
  bool _notificationsEnabled = true;
  bool _showPreview = true;

  // Vibe-based alerts settings
  bool _vibeAlertsEnabled = true;
  double _vibeAlertThreshold = 0.7;

  // Usage warnings settings
  bool _doomScrollingDetection = true;
  bool _rapidEngagementWarnings = true;
  bool _dailyLimitReminders = true;
  TimeOfDay _dailyLimitTime = const TimeOfDay(hour: 22, minute: 0);

  // AI recommendations settings
  String _aiRecommendationFrequency = 'Hourly';
  bool _smartTiming = true;

  // Quiet hours settings
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  Set<int> _quietHoursDays = {1, 2, 3, 4, 5, 6, 7};

  // Advanced settings
  bool _showAdvancedSettings = false;
  bool _notificationSounds = true;
  bool _vibrationPatterns = true;
  bool _lockScreenDisplay = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Notification Settings',
        variant: CustomAppBarVariant.withBack,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationStatusHeader(theme),
                SizedBox(height: 3.h),

                // Vibe-Based Alerts Section
                VibeAlertsSectionWidget(
                  isEnabled: _vibeAlertsEnabled,
                  threshold: _vibeAlertThreshold,
                  onToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _vibeAlertsEnabled = value);
                  },
                  onThresholdChanged: (value) {
                    setState(() => _vibeAlertThreshold = value);
                  },
                  onPreviewTap: () =>
                      _showNotificationPreview(context, 'Vibe Alert'),
                ),
                SizedBox(height: 2.h),

                // Usage Warnings Section
                UsageWarningsSectionWidget(
                  doomScrollingEnabled: _doomScrollingDetection,
                  rapidEngagementEnabled: _rapidEngagementWarnings,
                  dailyLimitEnabled: _dailyLimitReminders,
                  dailyLimitTime: _dailyLimitTime,
                  onDoomScrollingToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _doomScrollingDetection = value);
                  },
                  onRapidEngagementToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _rapidEngagementWarnings = value);
                  },
                  onDailyLimitToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _dailyLimitReminders = value);
                  },
                  onTimeSelected: (time) {
                    setState(() => _dailyLimitTime = time);
                  },
                ),
                SizedBox(height: 2.h),

                // AI Recommendations Section
                AiRecommendationsSectionWidget(
                  frequency: _aiRecommendationFrequency,
                  smartTimingEnabled: _smartTiming,
                  onFrequencyChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _aiRecommendationFrequency = value);
                  },
                  onSmartTimingToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _smartTiming = value);
                  },
                ),
                SizedBox(height: 2.h),

                // Quiet Hours Section
                QuietHoursSectionWidget(
                  isEnabled: _quietHoursEnabled,
                  startTime: _quietHoursStart,
                  endTime: _quietHoursEnd,
                  selectedDays: _quietHoursDays,
                  onToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _quietHoursEnabled = value);
                  },
                  onStartTimeSelected: (time) {
                    setState(() => _quietHoursStart = time);
                  },
                  onEndTimeSelected: (time) {
                    setState(() => _quietHoursEnd = time);
                  },
                  onDaysChanged: (days) {
                    setState(() => _quietHoursDays = days);
                  },
                ),
                SizedBox(height: 2.h),

                // Advanced Settings Section
                AdvancedSettingsSectionWidget(
                  isExpanded: _showAdvancedSettings,
                  soundsEnabled: _notificationSounds,
                  vibrationEnabled: _vibrationPatterns,
                  lockScreenEnabled: _lockScreenDisplay,
                  onExpandToggle: () {
                    HapticFeedback.lightImpact();
                    setState(
                        () => _showAdvancedSettings = !_showAdvancedSettings);
                  },
                  onSoundsToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _notificationSounds = value);
                  },
                  onVibrationToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _vibrationPatterns = value);
                  },
                  onLockScreenToggle: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _lockScreenDisplay = value);
                  },
                ),
                SizedBox(height: 3.h),

                // Test Notification Button
                _buildTestNotificationButton(theme),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationStatusHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _notificationsEnabled
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _notificationsEnabled
                  ? 'notifications_active'
                  : 'notifications_off',
              color: _notificationsEnabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _notificationsEnabled ? 'Active' : 'Disabled',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _notificationsEnabled = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotificationButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _notificationsEnabled
            ? () => _showNotificationPreview(context, 'Test Notification')
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'send',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Send Test Notification',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationPreview(BuildContext context, String type) {
    final theme = Theme.of(context);

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'notifications',
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'This is how your notification will appear',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: theme.colorScheme.primary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}