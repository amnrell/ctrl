import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../presentation/tab_page/tab_page.dart';
import '../services/theme_manager_service.dart';
import '../theme/app_theme.dart';
import '../utils/constant.dart';

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
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return; // user cancelled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // 🔐 Firebase Auth
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;
      getStorage.write('user',user);

      if (user == null) {
        throw Exception("Google login failed");
      }

      // 🔍 CHECK: new user or existing user
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        debugPrint("Existing user Signup");
      } else {
        // ✅ Existing user → normal login
        debugPrint("Existing user logged in");
      }

      // Save login state
      await getStorage.write('isLogin', 1);
      var isFirstTime = getStorage.read('isFirstTime');
      if (mounted) {
        if (isFirstTime == null) {
          getStorage.write('isFirstTime', true);
          Navigator.pushReplacementNamed(context, '/onboarding-flow');
        } else {
          Get.offAll(() => const TabPage());
        }
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      rethrow;
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
