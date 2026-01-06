import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/social_login_widget.dart';
import '../../../utils/responsive_helper.dart';
import '../../main_dashboard/widgets/dynamic_background_widget.dart';
import '../../../services/theme_manager_service.dart';

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
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); //
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String fcmToken = '';
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
                        SizedBox(height: ResponsiveHelper.isDesktop(context) ? 2.h : 4.h),
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
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        Text(
                          "Welcome Back",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontSize: ResponsiveHelper.isDesktop(context) ? 28 : null,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        SizedBox(
                          width: ResponsiveHelper.isDesktop(context) ? 600 : double.infinity,
                          child: CustomTextFormField(
                            hintText: 'Email',
                            maxLines: 1,
                            ctrl: emailController,
                            name: "email",
                            formSubmitted: isFormSubmitted,
                            validationMsg: 'Please enter email',
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 1.5, tablet: 2.0, desktop: 2.0)),
                        SizedBox(
                          width: ResponsiveHelper.isDesktop(context) ? 600 : double.infinity,
                          child: CustomTextFormField(
                            hintText: 'Password',
                            maxLines: 1,
                            ctrl: passwordController,
                            name: "password",
                            formSubmitted: isFormSubmitted,
                            validationMsg: 'Please enter password',
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        SizedBox(
                          width: ResponsiveHelper.isDesktop(context) ? 600 : double.infinity,
                          height: ResponsiveHelper.getButtonHeight(context),
                          child: CupertinoButton(
                            borderRadius: BorderRadius.circular(25),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            color: primaryColor,
                            onPressed: onLoginButtonPress,
                            child: Text(
                              'Login',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.surface,
                                letterSpacing: 1.5,
                                fontSize: ResponsiveHelper.isDesktop(context) ? 18 : 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                        "Forgot your Password?",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: ResponsiveHelper.isDesktop(context) ? 16 : 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: ResponsiveHelper.isDesktop(context) ? 230 : 80,
                          child: Divider(
                                thickness: 1,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.isDesktop(context) ? 15 : 10),
                            Text(
                              "Or",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontSize: ResponsiveHelper.isDesktop(context) ? 16 : 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.isDesktop(context) ? 15 : 10),
                            SizedBox(
                              width: ResponsiveHelper.isDesktop(context) ? 230 : 80,
                              child: Divider(
                                thickness: 1,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        SocialLoginPage(
                          loginCheck: widget.logincheck,
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context, mobile: 2.0, tablet: 2.5, desktop: 3.0)),
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

  onLoginButtonPress() {
    Navigator.pushReplacementNamed(context, '/main-dashboard');
    setState(() {
      isFormSubmitted = true;
    });
    // FocusScope.of(context).requestFocus(FocusNode());
    // Future.delayed(const Duration(milliseconds: 100), () async {
    //   if (_loginFormKey.currentState!.validate()) {
    //     loginController.email(emailController.text);
    //     loginController.password(passwordController.text);
    //     loginController.fcmToken(fcmToken);
    //     LoaderX.show(context, 60.0, 60.0);
    //     loginController.login();
    //   }
    // });
  }
}
