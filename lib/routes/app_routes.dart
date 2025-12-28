import 'package:flutter/material.dart';

import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/register_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String onboarding = '/onboarding-flow';
  static const String mainDashboard = '/main-dashboard';
  static const String login = '/login';
  static const String register = '/register';

  static final Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingFlow(),
    mainDashboard: (context) => const MainDashboard(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
  };
}
