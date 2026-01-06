import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/theme_manager_service.dart';
import '../theme/app_theme.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SocialLoginPage extends StatefulWidget {
  final String? loginCheck;
  const SocialLoginPage({super.key, this.loginCheck = ""});

  @override
  State<SocialLoginPage> createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends State<SocialLoginPage>
    with SingleTickerProviderStateMixin {
  String idToken = "", fcmToken = "", accessToken = "";
  GoogleSignInAccount? user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isDarkMode = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final ThemeManagerService _themeManager = ThemeManagerService();
  Color _currentVibeColor = AppTheme.primaryZen;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Load current vibe color from theme manager
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
        });
      }
    });

    // Listen to theme changes
    _themeManager.addListener(() {
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
        });
      }
    });
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {});
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _themeManager.removeListener(() {});
    super.dispose();
  }

  Future<void> handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // ignore: use_build_context_synchronously
        // LoaderX.show(context, 60.0, 60.0);
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        setState(() {
          idToken = googleSignInAuthentication.idToken.toString();
          accessToken = googleSignInAuthentication.accessToken.toString();
        });

        // await authService.socialLogin(accessToken).then(
        //   (value) async {
        //     if (value) {
        //       await FCMNotificationServices().saveFcmToken(fcmToken).then(
        //             (value) => {
        //               if (value)
        //                 {
        //                   if (widget.loginCheck == "profile")
        //                     {
        //                       LoaderX.hide(),
        //                       Get.offAll(
        //                           () => const TabPage(selectedTabIndex: 2)),
        //                     }
        //                   else if (widget.loginCheck == "signup")
        //                     {Get.back(), Get.back()}
        //                   else
        //                     {Get.back()}
        //                 }
        //             },
        //           );
        //     } else {
        //       LoaderX.hide();
        //       SnackbarUtils.showErrorSnackbar(
        //           "Failed to Login", value['message'].toString());
        //     }
        //     return null;
        //   },
        // );
      }
    } catch (error) {
      // LoaderX.hide();
      // SnackbarUtils.showErrorSnackbar("Failed to Login", error.toString());
      throw error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = _currentVibeColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: handleGoogleSignIn,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryColor, width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Google.png',
                  height: 22,
                  width: 22,
                ),
                Text(
                  '  Continue with Google',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
