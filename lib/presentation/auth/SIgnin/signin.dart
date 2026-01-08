import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/constant.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/social_login_widget.dart';
import '../../../utils/responsive_helper.dart';
import '../../main_dashboard/widgets/dynamic_background_widget.dart';
import '../../../services/theme_manager_service.dart';
import '../../../services/firebase_auth_service.dart';

class SignInPage extends StatefulWidget {
  final String? logincheck;
  final String? signupcheck;
  const SignInPage({super.key, this.logincheck = "", this.signupcheck = ""});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  bool isFormSubmitted = false;
  bool _isLoading = false;
  bool _isSignUpMode = false;
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String fcmToken = '';
  final ThemeManagerService _themeManager = ThemeManagerService();
  final FirebaseAuthService _authService = FirebaseAuthService();
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
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _themeManager.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = _currentVibeColor;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Dynamic animated background
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _currentVibeColor,
              secondaryColor: _themeManager.secondaryVibeColor,
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: SafeArea(
              child: ResponsiveHelper.wrapWithMaxWidth(
                context,
                Form(
                  key: _loginFormKey,
                  child: Padding(
                    padding: ResponsiveHelper.getScreenPadding(context),
                    child: Column(
                      children: [
                        SizedBox(
                            height: ResponsiveHelper.isDesktop(context)
                                ? 1.h
                                : 7.h),
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      primaryColor.withValues(alpha: 0.3),
                                      primaryColor.withValues(alpha: 0.1),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: CustomImageWidget(
                                    imageUrl:
                                        'assets/images/ctrl-logo-png-transparent-1765008694800.png',
                                    width: 20.w,
                                    height: 20.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 5.0, tablet: 2.5, desktop: 3.0)),
                        Text(
                          "Welcome Back",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontSize:
                                ResponsiveHelper.isDesktop(context) ? 28 : null,
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 5.0, tablet: 2.5, desktop: 3.0)),
                        SizedBox(
                          width: ResponsiveHelper.isDesktop(context)
                              ? 600
                              : double.infinity,
                          child: CustomTextFormField(
                            hintText: 'Email',
                            maxLines: 1,
                            ctrl: emailController,
                            name: "email",
                            formSubmitted: isFormSubmitted,
                            validationMsg: 'Please enter email',
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 1.5, tablet: 2.0, desktop: 2.0)),
                        SizedBox(
                          width: ResponsiveHelper.isDesktop(context)
                              ? 600
                              : double.infinity,
                          child: CustomTextFormField(
                            hintText: 'Password',
                            maxLines: 1,
                            ctrl: passwordController,
                            name: "password",
                            formSubmitted: isFormSubmitted,
                            validationMsg: 'Please enter password',
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        SizedBox(
                          width: ResponsiveHelper.isDesktop(context)
                              ? 600
                              : double.infinity,
                          height: ResponsiveHelper.getButtonHeight(context),
                          child: CupertinoButton(
                            borderRadius: BorderRadius.circular(8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            color: primaryColor,
                            onPressed: _isLoading ? null : onLoginButtonPress,
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.surface,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.surface,
                                      letterSpacing: 1.5,
                                      fontSize:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 18
                                              : 17,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                            "Forgot your Password?",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize:
                                  ResponsiveHelper.isDesktop(context) ? 16 : 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 230
                                  : 80,
                              child: Divider(
                                thickness: 1,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            SizedBox(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 15
                                    : 10),
                            Text(
                              "Or",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontSize: ResponsiveHelper.isDesktop(context)
                                    ? 16
                                    : 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 15
                                    : 10),
                            SizedBox(
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 230
                                  : 80,
                              child: Divider(
                                thickness: 1,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        SocialLoginPage(
                          loginCheck: widget.logincheck,
                        ),
                        SizedBox(
                            height: ResponsiveHelper.getSpacing(context,
                                mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don’t  have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/signUp');
                                },
                                child: Text(
                                  "Signup",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: primaryColor,
                                      decoration: TextDecoration.underline,
                                      decorationColor: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onLoginButtonPress() async {
    // Validate form
    if (!_loginFormKey.currentState!.validate()) {
      setState(() {
        isFormSubmitted = true;
      });
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      isFormSubmitted = true;
    });

    try {
      UserCredential? userCredential;

      userCredential = await _authService.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        try {
          await getStorage.write('isLogin', 1);
        } catch (storageError) {
          debugPrint('Storage error: $storageError');
        }
        var isFirstTime = getStorage.read('isFirstTime');
        if (mounted) {
          if (isFirstTime == null) {
            getStorage.write('isFirstTime', true);
            Navigator.pushReplacementNamed(context, '/onboarding-flow');
          } else {
            Navigator.pushReplacementNamed(context, '/main-dashboard');
          }
        }
      } else {
        throw Exception('Login failed: User credential is null');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (mounted) {
        String errorMessage = _getFirebaseErrorMessage(e);
        debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Handle all other errors including type casting errors
      debugPrint('Login Error: $e');

      // Workaround for Firebase Android Pigeon serialization bug:
      // Sometimes auth succeeds but throws a type casting error.
      // Check if user is actually signed in before showing error.

      // Wait a moment for auth state to update
      await Future.delayed(const Duration(milliseconds: 500));
      final currentUser = _authService.currentUser;

      if (currentUser != null &&
          currentUser.email == emailController.text.trim()) {
        debugPrint('Auth succeeded despite serialization error. Proceeding...');
        // User is actually signed in, proceed with login
        try {
          await getStorage.write('isLogin', 1);
        } catch (storageError) {
          debugPrint('Storage error: $storageError');
          // Continue even if storage fails
        }

        if (mounted) {
          // Show success message instead of error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login successful!'),
              backgroundColor: _currentVibeColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacementNamed(context, '/main-dashboard');
          return; // Exit early, login succeeded
        }
      }

      // Show error message only if login actually failed
      if (mounted) {
        String errorMessage = _getErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address. Please check your email or sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again or use "Forgot Password" to reset.';
      case 'invalid-email':
        return 'The email address is invalid. Please check and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later or reset your password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials and try again.';
      default:
        return e.message ??
            'An authentication error occurred. Please try again.';
    }
  }

  String _getErrorMessage(dynamic e) {
    final errorString = e.toString();

    // Return the error message or a generic one
    return errorString.isNotEmpty
        ? errorString
        : 'An unexpected error occurred. Please try again.';
  }
}
