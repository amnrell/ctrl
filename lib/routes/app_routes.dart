import 'package:flutter/material.dart';

import '../presentation/ctrl_center/ctrl_center.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/usage_analytics/usage_analytics.dart';
import '../presentation/vibe_selection/vibe_selection.dart';
import '../presentation/feedback_rating_system/feedback_rating_system.dart';
import '../presentation/social_media_o_auth_connection/social_media_o_auth_connection.dart';
import '../presentation/data_analytics_dashboard/data_analytics_dashboard.dart';
import '../presentation/backend_infrastructure_monitor/backend_infrastructure_monitor.dart';

class AppRoutes {
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String vibeSelection = '/vibe-selection';
  static const String splash = '/splash-screen';
  static const String usageAnalytics = '/usage-analytics';
  static const String ctrlCenter = '/ctrl-center';
  static const String settingsScreen = '/settings-screen';
  static const String feedbackRatingSystem = '/feedback-rating-system';
  static const String socialMediaOAuthConnection =
      '/social-media-o-auth-connection';
  static const String dataAnalyticsDashboard = '/data-analytics-dashboard';
  static const String backendInfrastructureMonitor =
      '/backend-infrastructure-monitor';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    vibeSelection: (context) => const VibeSelection(),
    splash: (context) => const SplashScreen(),
    usageAnalytics: (context) => const UsageAnalytics(),
    ctrlCenter: (context) => const CtrlCenter(),
    settingsScreen: (context) => const SettingsScreen(),
    feedbackRatingSystem: (context) => const FeedbackRatingSystem(),
    socialMediaOAuthConnection: (context) => const SocialMediaOAuthConnection(),
    dataAnalyticsDashboard: (context) => const DataAnalyticsDashboard(),
    backendInfrastructureMonitor: (context) =>
        const BackendInfrastructureMonitor(),
  };
}
