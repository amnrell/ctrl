import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'routes/app_routes.dart';
import 'services/theme_manager_service.dart';

/// 🚀 ENTRYPOINT
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeManager = ThemeManagerService();
  await themeManager.initialize();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(CtrlApp(
    showOnboarding: !onboardingCompleted,
    themeManager: themeManager,
  ));
}

class CtrlApp extends StatefulWidget {
  final bool showOnboarding;
  final ThemeManagerService themeManager;

  const CtrlApp({
    super.key,
    required this.showOnboarding,
    required this.themeManager,
  });

  @override
  State<CtrlApp> createState() => _CtrlAppState();
}

class _CtrlAppState extends State<CtrlApp> {
  @override
  void initState() {
    super.initState();
    widget.themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    widget.themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'CTRL',
          debugShowCheckedModeBanner: false,

          theme: widget.themeManager.getCurrentTheme(),
          darkTheme: widget.themeManager.getCurrentTheme(),
          themeMode: widget.themeManager.isLightMode
              ? ThemeMode.light
              : ThemeMode.dark,

          /// 👇 First screen shown on launch
          initialRoute: widget.showOnboarding
              ? '/onboarding-flow'
              : '/splash-screen',

          /// 👇 Your global routes file
          routes: AppRoutes.routes,

          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          ),
        );
      },
    );
  }
}
