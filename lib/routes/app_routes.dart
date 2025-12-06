import 'package:flutter/material.dart';

import '../presentation/ctrl_center/ctrl_center.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/notification_settings/notification_settings.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/usage_analytics/usage_analytics.dart';
import '../presentation/vibe_selection/vibe_selection.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String vibeSelection = '/vibe-selection';
  static const String splash = '/splash-screen';
  static const String usageAnalytics = '/usage-analytics';
  static const String notificationSettings = '/notification-settings';
  static const String ctrlCenter = '/ctrl-center';
  static const String settingsScreen = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    vibeSelection: (context) => const VibeSelection(),
    splash: (context) => const SplashScreen(),
    usageAnalytics: (context) => const UsageAnalytics(),
    notificationSettings: (context) => const NotificationSettings(),
    ctrlCenter: (context) => const CtrlCenter(),
    settingsScreen: (context) => const SettingsScreen(),
    // TODO: Add your other routes here
  };
}
