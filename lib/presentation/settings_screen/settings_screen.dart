import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../services/theme_manager_service.dart';
import '../../services/data_compliance_service.dart';
import './widgets/theme_customization_section_widget.dart';
import './widgets/font_customization_section_widget.dart';
import './widgets/data_privacy_section_widget.dart';

/// Settings screen for theme customization, font settings, and data compliance
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final DataComplianceService _complianceService = DataComplianceService();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();

    // Listen to theme changes for real-time vibe color updates
    _themeManager.addListener(_handleThemeChange);
  }

  void _handleThemeChange() {
    if (mounted) {
      setState(() {
        // Force rebuild when vibe color changes
      });
    }
  }

  @override
  void dispose() {
    _themeManager.removeListener(_handleThemeChange);
    super.dispose();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _themeManager.initialize(),
      _complianceService.initialize(),
    ]);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Settings',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor, // Real-time vibe color
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(theme, 'Appearance'),
                      SizedBox(height: 2.h),

                      // Theme Customization Section
                      ThemeCustomizationSectionWidget(
                        themeManager: _themeManager,
                        onThemeChanged: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Font Customization Section
                      FontCustomizationSectionWidget(
                        themeManager: _themeManager,
                        onFontChanged: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 4.h),

                      _buildSectionHeader(theme, 'Digital Wellbeing'),
                      SizedBox(height: 2.h),

                      // Usage Pattern Settings with refined terminology
                      _buildUsagePatternSettings(theme),
                      SizedBox(height: 4.h),

                      _buildSectionHeader(theme, 'Privacy & Data'),
                      SizedBox(height: 2.h),

                      // Data Privacy Section
                      DataPrivacySectionWidget(
                        complianceService: _complianceService,
                        onDataDeleted: () {
                          _handleDataDeletion();
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
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
          color: _themeManager.primaryVibeColor, // Real-time vibe color
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
          Text(
            'Behavior Pattern Detection',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _themeManager.primaryVibeColor,
            ),
          ),
          SizedBox(height: 2.h),
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

  Widget _buildPatternOption(
      ThemeData theme, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: _themeManager.primaryVibeColor, // Real-time vibe color
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
                    color:
                        _themeManager.primaryVibeColor, // Real-time title color
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Reset theme to defaults
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
