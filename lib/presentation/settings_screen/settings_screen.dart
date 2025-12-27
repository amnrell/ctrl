import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../services/theme_manager_service.dart';
import '../../services/data_compliance_service.dart';
import '../../services/notification_palette_service.dart';

import './widgets/theme_customization_section_widget.dart';
import './widgets/font_customization_section_widget.dart';
import './widgets/data_privacy_section_widget.dart';
import './widgets/wellbeing_tab_widget.dart';

import '../notification_settings/widgets/vibe_alerts_section_widget.dart';
import '../notification_settings/widgets/font_size_section_widget.dart';
import '../notification_settings/widgets/notification_colors_section_widget.dart';

/// Unified Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final DataComplianceService _complianceService = DataComplianceService();
  final NotificationPaletteService _notificationPalette =
      NotificationPaletteService();

  late TabController _tabController;
  bool _isInitialized = false;

  bool _vibeAlertsEnabled = true;
  double _vibeAlertThreshold = 0.7;
  double _notificationFontSize = 14.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _themeManager.initialize(),
      _complianceService.initialize(),
      _notificationPalette.initialize(),
    ]);

    _themeManager.addListener(_refresh);
    _notificationPalette.addListener(_refresh);

    setState(() => _isInitialized = true);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _themeManager.removeListener(_refresh);
    _notificationPalette.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
          _buildTabs(theme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AppearanceTab(themeManager: _themeManager),
                _NotificationsTab(
                  themeManager: _themeManager,
                  notificationPalette: _notificationPalette,
                  vibeAlertsEnabled: _vibeAlertsEnabled,
                  vibeAlertThreshold: _vibeAlertThreshold,
                  notificationFontSize: _notificationFontSize,
                  onChanged: () => setState(() {}),
                ),
                _PrivacyTab(
                  complianceService: _complianceService,
                ),
                WellbeingTabWidget(
                  themeManager: _themeManager,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: _themeManager.primaryVibeColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: _themeManager.primaryVibeColor,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withOpacity(0.6),
        tabs: const [
          Tab(text: 'Appearance'),
          Tab(text: 'Notifications'),
          Tab(text: 'Privacy'),
          Tab(text: 'Wellbeing'),
        ],
      ),
    );
  }
}

/* ----------------------------- TABS ----------------------------- */

class _NotificationsTab extends StatelessWidget {
  final ThemeManagerService themeManager;
  final NotificationPaletteService notificationPalette;
  final bool vibeAlertsEnabled;
  final double vibeAlertThreshold;
  final double notificationFontSize;
  final VoidCallback onChanged;

  const _NotificationsTab({
    required this.themeManager,
    required this.notificationPalette,
    required this.vibeAlertsEnabled,
    required this.vibeAlertThreshold,
    required this.notificationFontSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          VibeAlertsSectionWidget(
            themeManager: themeManager,
            isEnabled: vibeAlertsEnabled,
            threshold: vibeAlertThreshold,
            onToggle: (_) => onChanged(),
            onThresholdChanged: (_) => onChanged(),
            onPreviewTap: () {},
          ),
          SizedBox(height: 2.h),
          NotificationColorsSectionWidget(
            selectedVibes: notificationPalette.enabledVibes,
            onVibeToggle: notificationPalette.toggleVibe,
          ),
          SizedBox(height: 2.h),
          FontSizeSectionWidget(
            fontSize: notificationFontSize,
            onFontSizeChanged: (_) => onChanged(),
          ),
        ],
      ),
    );
  }
}

class _AppearanceTab extends StatelessWidget {
  final ThemeManagerService themeManager;
  const _AppearanceTab({required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ThemeCustomizationSectionWidget(
            themeManager: themeManager,
            onThemeChanged: () {},
          ),
          SizedBox(height: 3.h),
          FontCustomizationSectionWidget(
            themeManager: themeManager,
            onFontChanged: () {},
          ),
        ],
      ),
    );
  }
}

class _PrivacyTab extends StatelessWidget {
  final DataComplianceService complianceService;

  const _PrivacyTab({
    required this.complianceService,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: DataPrivacySectionWidget(
        complianceService: complianceService,
        onDataDeleted: () {},
      ),
    );
  }
}
