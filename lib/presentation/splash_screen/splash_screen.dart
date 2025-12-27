import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/ctrl_glitch_logo.dart';
import '../../services/theme_manager_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _showButtons = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _start();
  }

  void _setupAnimation() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _showButtons = true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final vibeColor = ThemeManagerService.instance.primaryVibeColor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            CtrlGlitchLogo(
              fontSize: 64.sp,
              glitchInterval: const Duration(milliseconds: 450),
            ),

            SizedBox(height: 2.h),
            const Spacer(),

            if (_showButtons) ...[
              _button("Sign in with Google", vibeColor, () {
                Navigator.pushReplacementNamed(context, '/login');
              }),
              SizedBox(height: 1.5.h),
              _button("Create Account", Colors.white, () {
                Navigator.pushNamed(context, '/register');
              }),
              SizedBox(height: 1.5.h),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/main-dashboard'),
                child: Text("Continue as Guest", style: TextStyle(color: vibeColor)),
              ),
            ],

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 70.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 1.8.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
}
