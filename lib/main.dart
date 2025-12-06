import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import './routes/app_routes.dart';
import './services/theme_manager_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme manager
  final themeManager = ThemeManagerService();
  await themeManager.initialize();

  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatefulWidget {
  final ThemeManagerService themeManager;

  const MyApp({super.key, required this.themeManager});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    widget.themeManager.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'ctrl',
          theme: widget.themeManager.getCurrentTheme(),
          darkTheme: widget.themeManager.getCurrentTheme(),
          themeMode: widget.themeManager.isLightMode
              ? ThemeMode.light
              : ThemeMode.dark,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.initial,
        );
      },
    );
  }
}
