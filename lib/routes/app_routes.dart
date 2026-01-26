import 'package:flutter/material.dart';

import '../presentation/auth/ForgotPassword/forgot_password.dart';
import '../presentation/auth/SIgnin/signin.dart';
import '../presentation/auth/SignUp/signup.dart';
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
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/tab_page/tab_page.dart';
import '../presentation/impulse_checkin/impulse_checkin_screen.dart';
import '../presentation/ctrl_journal/ctrl_journal_screen.dart';
import '../presentation/mood_check/mood_check_screen.dart';
import '../presentation/urge_log/urge_log_screen.dart';
import '../presentation/cooldown_timer/cooldown_timer_screen.dart';
import '../presentation/weekly_summary/weekly_summary_screen.dart';
import '../presentation/premium_upgrade/premium_upgrade_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String vibeSelection = '/vibe-selection';
  static const String splash = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String signIn = '/signIn';
  static const String signUpPage = '/signUp';
  static const String forgotPassword = '/forgot-password';
  static const String usageAnalytics = '/usage-analytics';
  static const String ctrlCenter = '/ctrl-center';
  static const String settingsScreen = '/settings-screen';
  static const String feedbackRatingSystem = '/feedback-rating-system';
  static const String socialMediaOAuthConnection =
      '/social-media-o-auth-connection';
  static const String dataAnalyticsDashboard = '/data-analytics-dashboard';
  static const String backendInfrastructureMonitor =
      '/backend-infrastructure-monitor';
  static const String tabPage = '/tab-page';
  static const String impulseCheckin = '/impulse-checkin';
  static const String ctrlJournal = '/ctrl-journal';
  static const String moodCheck = '/mood-check';
  static const String urgeLog = '/urge-log';
  static const String cooldownTimer = '/cooldown-timer';
  static const String weeklySummary = '/weekly-summary';
  static const String premiumUpgrade = '/premium-upgrade';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    vibeSelection: (context) => const VibeSelection(),
    splash: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    signIn: (context) => const SignInPage(),
    signUpPage: (context) => const SignUpPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
    usageAnalytics: (context) => const UsageAnalytics(),
    ctrlCenter: (context) => const CtrlCenter(),
    settingsScreen: (context) => const SettingsScreen(),
    feedbackRatingSystem: (context) => const FeedbackRatingSystem(),
    socialMediaOAuthConnection: (context) => const SocialMediaOAuthConnection(),
    dataAnalyticsDashboard: (context) => const DataAnalyticsDashboard(),
    backendInfrastructureMonitor: (context) =>
        const BackendInfrastructureMonitor(),
    tabPage: (context) => const TabPage(),
    impulseCheckin: (context) => const ImpulseCheckinScreen(),
    ctrlJournal: (context) => const CtrlJournalScreen(),
    moodCheck: (context) => const MoodCheckScreen(),
    urgeLog: (context) => const UrgeLogScreen(),
    cooldownTimer: (context) => const CooldownTimerScreen(),
    weeklySummary: (context) => const WeeklySummaryScreen(),
    premiumUpgrade: (context) => const PremiumUpgradeScreen(),
  };
}
