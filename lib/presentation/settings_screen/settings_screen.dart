import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../services/theme_manager_service.dart';
import '../../services/data_compliance_service.dart';
import './widgets/theme_customization_section_widget.dart';
import './widgets/font_customization_section_widget.dart';
import './widgets/data_privacy_section_widget.dart';
import '../notification_settings/widgets/advanced_settings_section_widget.dart';
import '../notification_settings/widgets/ai_recommendations_section_widget.dart';
import '../notification_settings/widgets/quiet_hours_section_widget.dart';
import '../notification_settings/widgets/usage_warnings_section_widget.dart';
import '../notification_settings/widgets/vibe_alerts_section_widget.dart';
import '../notification_settings/widgets/font_size_section_widget.dart';
import '../notification_settings/widgets/notification_colors_section_widget.dart';
import '../../widgets/custom_icon_widget.dart';

/// Unified Settings screen with improved state preservation
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final DataComplianceService _complianceService = DataComplianceService();

  bool _isLoading = false;
  bool _isInitialized = false;
  late TabController _tabController;

  // Notification status
  bool _notificationsEnabled = true;

  // Vibe-based alerts settings
  bool _vibeAlertsEnabled = true;
  double _vibeAlertThreshold = 0.7;

  // Selected notification colors
  Set<String> _selectedVibeColors = {'Zen', 'Energized', 'Reflective'};

  // Font size preference
  double _notificationFontSize = 14.0;

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeServices();
  }

  void _handleThemeChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _themeManager.removeListener(_handleThemeChange);
    super.dispose();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        _themeManager.initialize(),
        _complianceService.initialize(),
      ]);

      _themeManager.addListener(_handleThemeChange);

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing services: $e');
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Loading Settings...',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Settings',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: _themeManager.primaryVibeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: _themeManager.primaryVibeColor,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.6),
              labelStyle: theme.textTheme.labelMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: theme.textTheme.labelMedium,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Appearance'),
                Tab(text: 'Notifications'),
                Tab(text: 'Privacy'),
                Tab(text: 'Wellbeing'),
              ],
            ),
          ),
          // Tab View with improved state preservation
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AppearanceTabContent(
                  themeManager: _themeManager,
                  onStateChanged: () => setState(() {}),
                ),
                _NotificationsTabContent(
                  notificationsEnabled: _notificationsEnabled,
                  vibeAlertsEnabled: _vibeAlertsEnabled,
                  vibeAlertThreshold: _vibeAlertThreshold,
                  selectedVibeColors: _selectedVibeColors,
                  notificationFontSize: _notificationFontSize,
                  doomScrollingDetection: _doomScrollingDetection,
                  rapidEngagementWarnings: _rapidEngagementWarnings,
                  dailyLimitReminders: _dailyLimitReminders,
                  dailyLimitTime: _dailyLimitTime,
                  aiRecommendationFrequency: _aiRecommendationFrequency,
                  smartTiming: _smartTiming,
                  quietHoursEnabled: _quietHoursEnabled,
                  quietHoursStart: _quietHoursStart,
                  quietHoursEnd: _quietHoursEnd,
                  quietHoursDays: _quietHoursDays,
                  showAdvancedSettings: _showAdvancedSettings,
                  notificationSounds: _notificationSounds,
                  vibrationPatterns: _vibrationPatterns,
                  lockScreenDisplay: _lockScreenDisplay,
                  onNotificationsEnabledChanged: (value) =>
                      setState(() => _notificationsEnabled = value),
                  onVibeAlertsEnabledChanged: (value) =>
                      setState(() => _vibeAlertsEnabled = value),
                  onVibeAlertThresholdChanged: (value) =>
                      setState(() => _vibeAlertThreshold = value),
                  onVibeColorToggle: (vibeName) {
                    setState(() {
                      if (_selectedVibeColors.contains(vibeName)) {
                        _selectedVibeColors.remove(vibeName);
                      } else {
                        _selectedVibeColors.add(vibeName);
                      }
                    });
                  },
                  onFontSizeChanged: (value) =>
                      setState(() => _notificationFontSize = value),
                  onDoomScrollingToggle: (value) =>
                      setState(() => _doomScrollingDetection = value),
                  onRapidEngagementToggle: (value) =>
                      setState(() => _rapidEngagementWarnings = value),
                  onDailyLimitToggle: (value) =>
                      setState(() => _dailyLimitReminders = value),
                  onDailyLimitTimeSelected: (time) =>
                      setState(() => _dailyLimitTime = time),
                  onAiFrequencyChanged: (value) =>
                      setState(() => _aiRecommendationFrequency = value),
                  onSmartTimingToggle: (value) =>
                      setState(() => _smartTiming = value),
                  onQuietHoursToggle: (value) =>
                      setState(() => _quietHoursEnabled = value),
                  onQuietHoursStartSelected: (time) =>
                      setState(() => _quietHoursStart = time),
                  onQuietHoursEndSelected: (time) =>
                      setState(() => _quietHoursEnd = time),
                  onQuietHoursDaysChanged: (days) =>
                      setState(() => _quietHoursDays = days),
                  onAdvancedExpandToggle: () => setState(
                      () => _showAdvancedSettings = !_showAdvancedSettings),
                  onSoundsToggle: (value) =>
                      setState(() => _notificationSounds = value),
                  onVibrationToggle: (value) =>
                      setState(() => _vibrationPatterns = value),
                  onLockScreenToggle: (value) =>
                      setState(() => _lockScreenDisplay = value),
                  themeManager: _themeManager,
                ),
                _PrivacyTabContent(
                  complianceService: _complianceService,
                  onDataDeleted: _handleDataDeletion,
                  themeManager: _themeManager,
                ),
                _WellbeingTabContent(
                  themeManager: _themeManager,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDataDeletion() async {
    final confirmed =
        await _complianceService.showDeleteConfirmationDialog(context);

    if (confirmed) {
      setState(() => _isLoading = true);

      final success = await _complianceService.deleteAllUserData();

      setState(() => _isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('All data has been deleted successfully'),
            backgroundColor: _themeManager.primaryVibeColor,
            behavior: SnackBarBehavior.floating,
          ),
        );

        await _themeManager.initialize();
        setState(() {});
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to delete data. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// Appearance Tab with state preservation
class _AppearanceTabContent extends StatefulWidget {
  final ThemeManagerService themeManager;
  final VoidCallback onStateChanged;

  const _AppearanceTabContent({
    required this.themeManager,
    required this.onStateChanged,
  });

  @override
  State<_AppearanceTabContent> createState() => _AppearanceTabContentState();
}

class _AppearanceTabContentState extends State<_AppearanceTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(theme, 'Theme'),
              SizedBox(height: 2.h),
              ThemeCustomizationSectionWidget(
                themeManager: widget.themeManager,
                onThemeChanged: widget.onStateChanged,
              ),
              SizedBox(height: 3.h),
              _buildSectionHeader(theme, 'Font'),
              SizedBox(height: 2.h),
              FontCustomizationSectionWidget(
                themeManager: widget.themeManager,
                onFontChanged: widget.onStateChanged,
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: widget.themeManager.primaryVibeColor,
        ),
      ),
    );
  }
}

// Notifications Tab with state preservation
class _NotificationsTabContent extends StatefulWidget {
  final bool notificationsEnabled;
  final bool vibeAlertsEnabled;
  final double vibeAlertThreshold;
  final Set<String> selectedVibeColors;
  final double notificationFontSize;
  final bool doomScrollingDetection;
  final bool rapidEngagementWarnings;
  final bool dailyLimitReminders;
  final TimeOfDay dailyLimitTime;
  final String aiRecommendationFrequency;
  final bool smartTiming;
  final bool quietHoursEnabled;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;
  final Set<int> quietHoursDays;
  final bool showAdvancedSettings;
  final bool notificationSounds;
  final bool vibrationPatterns;
  final bool lockScreenDisplay;
  final ValueChanged<bool> onNotificationsEnabledChanged;
  final ValueChanged<bool> onVibeAlertsEnabledChanged;
  final ValueChanged<double> onVibeAlertThresholdChanged;
  final ValueChanged<String> onVibeColorToggle;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<bool> onDoomScrollingToggle;
  final ValueChanged<bool> onRapidEngagementToggle;
  final ValueChanged<bool> onDailyLimitToggle;
  final ValueChanged<TimeOfDay> onDailyLimitTimeSelected;
  final ValueChanged<String> onAiFrequencyChanged;
  final ValueChanged<bool> onSmartTimingToggle;
  final ValueChanged<bool> onQuietHoursToggle;
  final ValueChanged<TimeOfDay> onQuietHoursStartSelected;
  final ValueChanged<TimeOfDay> onQuietHoursEndSelected;
  final ValueChanged<Set<int>> onQuietHoursDaysChanged;
  final VoidCallback onAdvancedExpandToggle;
  final ValueChanged<bool> onSoundsToggle;
  final ValueChanged<bool> onVibrationToggle;
  final ValueChanged<bool> onLockScreenToggle;
  final ThemeManagerService themeManager;

  const _NotificationsTabContent({
    required this.notificationsEnabled,
    required this.vibeAlertsEnabled,
    required this.vibeAlertThreshold,
    required this.selectedVibeColors,
    required this.notificationFontSize,
    required this.doomScrollingDetection,
    required this.rapidEngagementWarnings,
    required this.dailyLimitReminders,
    required this.dailyLimitTime,
    required this.aiRecommendationFrequency,
    required this.smartTiming,
    required this.quietHoursEnabled,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.quietHoursDays,
    required this.showAdvancedSettings,
    required this.notificationSounds,
    required this.vibrationPatterns,
    required this.lockScreenDisplay,
    required this.onNotificationsEnabledChanged,
    required this.onVibeAlertsEnabledChanged,
    required this.onVibeAlertThresholdChanged,
    required this.onVibeColorToggle,
    required this.onFontSizeChanged,
    required this.onDoomScrollingToggle,
    required this.onRapidEngagementToggle,
    required this.onDailyLimitToggle,
    required this.onDailyLimitTimeSelected,
    required this.onAiFrequencyChanged,
    required this.onSmartTimingToggle,
    required this.onQuietHoursToggle,
    required this.onQuietHoursStartSelected,
    required this.onQuietHoursEndSelected,
    required this.onQuietHoursDaysChanged,
    required this.onAdvancedExpandToggle,
    required this.onSoundsToggle,
    required this.onVibrationToggle,
    required this.onLockScreenToggle,
    required this.themeManager,
  });

  @override
  State<_NotificationsTabContent> createState() =>
      _NotificationsTabContentState();
}

class _NotificationsTabContentState extends State<_NotificationsTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationStatusHeader(theme),
              SizedBox(height: 3.h),
              VibeAlertsSectionWidget(
                isEnabled: widget.vibeAlertsEnabled,
                threshold: widget.vibeAlertThreshold,
                onToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onVibeAlertsEnabledChanged(value);
                },
                onThresholdChanged: widget.onVibeAlertThresholdChanged,
                onPreviewTap: () =>
                    _showNotificationPreview(context, 'Vibe Alert'),
              ),
              SizedBox(height: 2.h),
              NotificationColorsSectionWidget(
                selectedVibes: widget.selectedVibeColors,
                onVibeToggle: widget.onVibeColorToggle,
              ),
              SizedBox(height: 2.h),
              FontSizeSectionWidget(
                fontSize: widget.notificationFontSize,
                onFontSizeChanged: widget.onFontSizeChanged,
              ),
              SizedBox(height: 2.h),
              UsageWarningsSectionWidget(
                doomScrollingEnabled: widget.doomScrollingDetection,
                rapidEngagementEnabled: widget.rapidEngagementWarnings,
                dailyLimitEnabled: widget.dailyLimitReminders,
                dailyLimitTime: widget.dailyLimitTime,
                onDoomScrollingToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onDoomScrollingToggle(value);
                },
                onRapidEngagementToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onRapidEngagementToggle(value);
                },
                onDailyLimitToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onDailyLimitToggle(value);
                },
                onTimeSelected: widget.onDailyLimitTimeSelected,
              ),
              SizedBox(height: 2.h),
              AiRecommendationsSectionWidget(
                frequency: widget.aiRecommendationFrequency,
                smartTimingEnabled: widget.smartTiming,
                onFrequencyChanged: (value) {
                  HapticFeedback.lightImpact();
                  widget.onAiFrequencyChanged(value);
                },
                onSmartTimingToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onSmartTimingToggle(value);
                },
              ),
              SizedBox(height: 2.h),
              QuietHoursSectionWidget(
                isEnabled: widget.quietHoursEnabled,
                startTime: widget.quietHoursStart,
                endTime: widget.quietHoursEnd,
                selectedDays: widget.quietHoursDays,
                onToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onQuietHoursToggle(value);
                },
                onStartTimeSelected: widget.onQuietHoursStartSelected,
                onEndTimeSelected: widget.onQuietHoursEndSelected,
                onDaysChanged: widget.onQuietHoursDaysChanged,
              ),
              SizedBox(height: 2.h),
              AdvancedSettingsSectionWidget(
                isExpanded: widget.showAdvancedSettings,
                soundsEnabled: widget.notificationSounds,
                vibrationEnabled: widget.vibrationPatterns,
                lockScreenEnabled: widget.lockScreenDisplay,
                onExpandToggle: () {
                  HapticFeedback.lightImpact();
                  widget.onAdvancedExpandToggle();
                },
                onSoundsToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onSoundsToggle(value);
                },
                onVibrationToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onVibrationToggle(value);
                },
                onLockScreenToggle: (value) {
                  HapticFeedback.lightImpact();
                  widget.onLockScreenToggle(value);
                },
              ),
              SizedBox(height: 3.h),
              _buildTestNotificationButton(theme),
              SizedBox(height: 3.h),
            ],
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
              color: widget.notificationsEnabled
                  ? widget.themeManager.primaryVibeColor.withValues(alpha: 0.1)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: widget.notificationsEnabled
                  ? 'notifications_active'
                  : 'notifications_off',
              color: widget.notificationsEnabled
                  ? widget.themeManager.primaryVibeColor
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
                  widget.notificationsEnabled ? 'Active' : 'Disabled',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.notificationsEnabled,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              widget.onNotificationsEnabledChanged(value);
            },
            activeColor: widget.themeManager.primaryVibeColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotificationButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.notificationsEnabled
            ? () => _showNotificationPreview(context, 'Test Notification')
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.themeManager.primaryVibeColor,
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
                color:
                    widget.themeManager.primaryVibeColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'notifications',
                color: widget.themeManager.primaryVibeColor,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: widget.themeManager.primaryVibeColor,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

// Privacy Tab with state preservation
class _PrivacyTabContent extends StatefulWidget {
  final DataComplianceService complianceService;
  final VoidCallback onDataDeleted;
  final ThemeManagerService themeManager;

  const _PrivacyTabContent({
    required this.complianceService,
    required this.onDataDeleted,
    required this.themeManager,
  });

  @override
  State<_PrivacyTabContent> createState() => _PrivacyTabContentState();
}

class _PrivacyTabContentState extends State<_PrivacyTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(theme, 'Data Privacy'),
              SizedBox(height: 2.h),
              DataPrivacySectionWidget(
                complianceService: widget.complianceService,
                onDataDeleted: widget.onDataDeleted,
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: widget.themeManager.primaryVibeColor,
        ),
      ),
    );
  }
}

// Wellbeing Tab with state preservation
class _WellbeingTabContent extends StatefulWidget {
  final ThemeManagerService themeManager;

  const _WellbeingTabContent({
    required this.themeManager,
  });

  @override
  State<_WellbeingTabContent> createState() => _WellbeingTabContentState();
}

class _WellbeingTabContentState extends State<_WellbeingTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(theme, 'Behavior Pattern Detection'),
              SizedBox(height: 2.h),
              _buildUsagePatternSettings(theme),
              SizedBox(height: 3.h),
              _buildSectionHeader(theme, 'Feedback & Support'),
              SizedBox(height: 2.h),
              _buildFeedbackSection(theme),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: widget.themeManager.primaryVibeColor,
        ),
      ),
    );
  }

  Widget _buildUsagePatternSettings(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatternOption(
            theme,
            'Excessive Content Consumption',
            'Monitor prolonged content viewing patterns',
          ),
          _buildPatternOption(
            theme,
            'High-Frequency Interactions',
            'Track rapid engagement and interaction patterns',
          ),
          _buildPatternOption(
            theme,
            'Continuous Scrolling Detection',
            'Identify extended scrolling behaviors',
          ),
          _buildPatternOption(
            theme,
            'Rapid Posting Activity',
            'Monitor high-volume content creation patterns',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pushNamed(context, '/feedback-rating-system');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: widget.themeManager.primaryVibeColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.rate_review,
                    color: widget.themeManager.primaryVibeColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share Feedback',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Help us improve CTRL with your thoughts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatternOption(
      ThemeData theme, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: widget.themeManager.primaryVibeColor,
            size: 20,
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
                    color: widget.themeManager.primaryVibeColor,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
