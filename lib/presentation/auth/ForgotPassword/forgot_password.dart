import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../../services/theme_manager_service.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../utils/responsive_helper.dart';
import '../../main_dashboard/widgets/dynamic_background_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  bool isFormSubmitted = false;
  final _forgotpasswordFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
          SingleChildScrollView(
            child: SafeArea(
              child: ResponsiveHelper.wrapWithMaxWidth(
                context,
                Form(
                  key: _forgotpasswordFormKey,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: ResponsiveHelper.getScreenPadding(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: ResponsiveHelper.isDesktop(context)
                                  ? 2.h
                                  : 4.h),
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
                          SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Forgot Password",
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: ResponsiveHelper.isDesktop(context)
                                      ? 36
                                      : 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveHelper.getSpacing(context,
                                      mobile: 1.5, tablet: 2.0, desktop: 2.0)),
                              Text(
                                "Please enter your email address to receive\nyour password reset link",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: ResponsiveHelper.isDesktop(context)
                                      ? 16
                                      : 12,
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveHelper.getSpacing(context,
                                      mobile: 3.0, tablet: 3.5, desktop: 4.0)),
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
                            ],
                          ),
                          SizedBox(
                              height: ResponsiveHelper.getSpacing(context,
                                  mobile: 3.0, tablet: 3.5, desktop: 4.0)),
                          SizedBox(
                            width: ResponsiveHelper.isDesktop(context)
                                ? 600
                                : double.infinity,
                            height: ResponsiveHelper.getButtonHeight(context),
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(25),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              color: primaryColor,
                              onPressed: () {
                                // Handle forgot password logic here
                                if (_forgotpasswordFormKey.currentState
                                        ?.validate() ??
                                    false) {
                                  // Implement password reset logic
                                }
                              },
                              child: Text(
                                "Reset Password",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.surface,
                                  letterSpacing: 1.5,
                                  fontSize: ResponsiveHelper.isDesktop(context)
                                      ? 18
                                      : 17,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: ResponsiveHelper.getSpacing(context,
                                  mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Back to",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: ResponsiveHelper.isDesktop(context)
                                      ? 16
                                      : 12.5,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Login",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize:
                                        ResponsiveHelper.isDesktop(context)
                                            ? 16
                                            : 12.5,
                                          decoration: TextDecoration.underline,
                                          decorationColor: primaryColor,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: ResponsiveHelper.getSpacing(context,
                                  mobile: 2.0, tablet: 2.5, desktop: 3.0)),
                        ],
                      ),
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
}
