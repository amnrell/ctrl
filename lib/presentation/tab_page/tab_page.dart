import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/tab_controller.dart';
import '../../services/theme_manager_service.dart';
import '../main_dashboard/main_dashboard.dart';
import '../ctrl_center/ctrl_center.dart';
import '../usage_analytics/usage_analytics.dart';
import '../settings_screen/settings_screen.dart';

/// Main tab page with bottom navigation
/// Implements the same structure as Mobile-Insights-by-Artigan
class TabPage extends StatefulWidget {
  final int? selectedTabIndex;
  const TabPage({super.key, this.selectedTabIndex = 0});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final controller = Get.put(TabCountController());
  final ThemeManagerService _themeManager = ThemeManagerService();

  final List<Widget> _pages = [
    const MainDashboard(),
    const CtrlCenter(),
    const UsageAnalytics(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    controller.changeTabIndex(widget.selectedTabIndex!);
    super.initState();

    // Initialize theme manager
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: IndexedStack(
            index: controller.tabIndex.value,
            children: _pages,
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    color: theme.cardColor,
                    border: Border(
                      top: BorderSide(
                        color: theme.dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  height: Platform.isAndroid ? 65 : 65,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTabItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          label: "Home",
                          index: 0,
                        ),
                        _buildTabItem(
                          icon: Icons.psychology_outlined,
                          activeIcon: Icons.psychology,
                          label: "CTRL",
                          index: 1,
                        ),
                        _buildTabItem(
                          icon: Icons.bar_chart_outlined,
                          activeIcon: Icons.bar_chart,
                          label: "Analytics",
                          index: 2,
                        ),
                        _buildTabItem(
                          icon: Icons.settings_outlined,
                          activeIcon: Icons.settings,
                          label: "Settings",
                          index: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildTabItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = controller.tabIndex.value == index;
    final Color selectedColor = _themeManager.primaryVibeColor;
    const Color unselectedColor = Colors.grey;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => {
        controller.changeTabIndex(index),
      },
      child: Column(
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedColor,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
