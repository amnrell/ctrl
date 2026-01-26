import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/theme_manager_service.dart';
import '../settings_screen/widgets/font_customization_section_widget.dart';
import '../settings_screen/widgets/theme_customization_section_widget.dart';

class AppearancePage extends StatefulWidget {
  final ThemeManagerService themeManager;
  final VoidCallback onStateChanged;

  const AppearancePage({
    required this.themeManager,
    required this.onStateChanged,
  });

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Appearance",
          style: TextStyle(),
        ),
      ),
      body: SafeArea(
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
