import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/theme_manager_service.dart';
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
  Color _currentVibeColor = const Color(0xFF4A7C59); // Default Zen
  String _selectedVibe = 'Zen';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Initialize theme manager
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();
      setState(() {
        _currentVibeColor = _themeManager.primaryVibeColor;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _completeOnboarding() async {
    // Save onboarding completion and selected vibe
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    await prefs.setString('selected_vibe', _selectedVibe);

    // Save vibe to theme manager
    await _themeManager.setPrimaryVibeColor(
      _currentVibeColor,
      vibeName: _selectedVibe,
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    }
  }

  Future<void> _skipOnboarding() async {
    // Mark as completed but use default vibe
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    }
  }

  void _onVibeSelected(String vibe, Color color) {
    setState(() {
      _selectedVibe = vibe;
      _currentVibeColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
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
            bottom: MediaQuery.of(context).padding.bottom + 3.h,
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

                SizedBox(height: 3.h),

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
                              padding: EdgeInsets.symmetric(vertical: 1.8.h),
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
    );
  }
}
