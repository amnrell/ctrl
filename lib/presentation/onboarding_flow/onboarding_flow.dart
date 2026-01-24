import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/theme_manager_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';
import './widgets/onboarding_page_one_widget.dart';
import './widgets/onboarding_page_two_widget.dart';
import './widgets/onboarding_page_three_widget.dart';

/// Onboarding Flow introducing new users to CTRL with progressive disclosure
/// Three sequential screens with smooth transitions and skip functionality
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final ThemeManagerService _themeManager = ThemeManagerService();

  int _currentPage = 0;
  Color _currentVibeColor = AppTheme.primaryZen; // Default Zen
  String _selectedVibe = 'Zen';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: ResponsiveHelper.wrapWithMaxWidth(
          context,
          Stack(
            children: [
              // Animated background gradient
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _currentVibeColor.withValues(alpha: 0.1),
                      theme.colorScheme.surface,
                      _currentVibeColor.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),

              // PageView with onboarding screens
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: OnboardingPageOneWidget(
                      vibeColor: _currentVibeColor,
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: OnboardingPageTwoWidget(
                      vibeColor: _currentVibeColor,
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: OnboardingPageThreeWidget(
                      vibeColor: _currentVibeColor,
                      onVibeSelected: _onVibeSelected,
                      selectedVibe: _selectedVibe,
                    ),
                  ),
                ],
              ),

              // Skip button (shown on first two pages only)
              if (_currentPage < 2)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 2.h,
                  right: 4.w,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: _currentVibeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Bottom navigation section
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 2.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          width: _currentPage == index ? 8.w : 2.w,
                          height: 1.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _currentVibeColor
                                : _currentVibeColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Navigation buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Row(
                        children: [
                          // Back button (hidden on first page)
                          if (_currentPage > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: _currentVibeColor),
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.8.h),
                                ),
                                child: Text(
                                  'Back',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: _currentVibeColor,
                                  ),
                                ),
                              ),
                            ),

                          if (_currentPage > 0) SizedBox(width: 3.w),

                          // Next/Get Started button
                          Expanded(
                            flex: _currentPage == 0 ? 1 : 1,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_currentPage < 2) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _completeOnboarding();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _currentVibeColor,
                                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                              ),
                              child: Text(
                                _currentPage == 2 ? 'Get Started' : 'Next',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
