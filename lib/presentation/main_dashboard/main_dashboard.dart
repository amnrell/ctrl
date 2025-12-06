import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/ai_recommendation_banner_widget.dart';
import './widgets/dynamic_background_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/usage_summary_card_widget.dart';
import './widgets/vibe_indicator_card_widget.dart';
import '../../services/theme_manager_service.dart';
import '../../models/vibe_config.dart';

/// Main Dashboard screen serving as central hub for CTRL app
/// Displays current vibe status and social media usage overview with dynamic theming
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with SingleTickerProviderStateMixin {
  // Current vibe state
  String _currentVibe = 'Zen';
  Color _currentVibeColor = const Color(0xFF4A7C59); // Zen green

  final ThemeManagerService _themeManager = ThemeManagerService();
  final Random _random = Random();

  // CTRL title animation controller with glitching effects
  late AnimationController _ctrlAnimationController;
  late Animation<double> _ctrlScaleAnimation;
  late Animation<double> _ctrlRotationAnimation;
  late Animation<double> _ctrlOpacityAnimation;

  // Glitch effect state
  bool _isGlitching = false;
  int _currentGlitchIndex = 0;

  // Enhanced glitch variations matching splash screen style
  final List<Map<String, dynamic>> _glitchVariations = [
    {
      'font': GoogleFonts.inter,
      'weight': FontWeight.w900,
      'italic': false,
    },
    {
      'font': GoogleFonts.robotoMono,
      'weight': FontWeight.w700,
      'italic': false,
    },
    {
      'font': GoogleFonts.poppins,
      'weight': FontWeight.w800,
      'italic': true,
    },
    {
      'font': GoogleFonts.sourceCodePro,
      'weight': FontWeight.w800,
      'italic': false,
    },
    {
      'font': GoogleFonts.montserrat,
      'weight': FontWeight.w700,
      'italic': true,
    },
    {
      'font': GoogleFonts.ubuntu,
      'weight': FontWeight.w800,
      'italic': false,
    },
  ];

  // Usage data with refined terminology
  final Map<String, dynamic> _usageData = {
    'totalScreenTime': '4h 32m',
    'topApp': 'Twitter',
    'topAppTime': '2h 15m',
    'detectedPatterns': [
      'Excessive content consumption detected',
      'High-frequency interaction pattern observed'
    ],
    'appsBreakdown': [
      {'name': 'Twitter', 'time': '2h 15m', 'percentage': 0.5},
      {'name': 'Instagram', 'time': '1h 30m', 'percentage': 0.33},
      {'name': 'TikTok', 'time': '47m', 'percentage': 0.17},
    ],
  };

  // AI recommendation state with vibe-specific context
  bool _showAiRecommendation = true;
  String _aiRecommendationMessage = '';

  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    // Initialize CTRL title animation with dynamic effects
    _ctrlAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Elastic scale animation for "bounce" effect
    _ctrlScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrlAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Rotation animation for dynamic reload
    _ctrlRotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrlAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Opacity fade-in
    _ctrlOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrlAnimationController,
        curve: Curves.easeIn,
      ),
    );

    // Load current vibe from theme manager
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();
      setState(() {
        _currentVibeColor = _themeManager.primaryVibeColor;
        _currentVibe = _themeManager.currentVibeName;
        _updateAiRecommendation();
      });

      // Start CTRL animation with glitch
      _ctrlAnimationController.forward();
      _startGlitchSequence();
    });

    // Listen to theme changes and replay animation with glitch
    _themeManager.addListener(() {
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
          _currentVibe = _themeManager.currentVibeName;
          _updateAiRecommendation();
        });

        // Replay CTRL animation with glitch on vibe change
        _ctrlAnimationController.reset();
        _ctrlAnimationController.forward();
        _startGlitchSequence();
      }
    });
  }

  /// Start glitch sequence for CTRL title (2-3 seconds)
  void _startGlitchSequence() {
    setState(() {
      _isGlitching = true;
    });

    // Rapid glitch cycling for 2.5 seconds
    final glitchTimer = Future.doWhile(() async {
      if (!mounted || !_isGlitching) return false;

      await Future.delayed(Duration(milliseconds: 60 + _random.nextInt(60)));

      if (mounted && _isGlitching) {
        setState(() {
          _currentGlitchIndex = _random.nextInt(_glitchVariations.length);
        });
        return true;
      }
      return false;
    });

    // Stop glitching after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isGlitching = false;
          _currentGlitchIndex = 0; // Reset to default
        });
      }
    });
  }

  /// Update AI recommendation based on current vibe using VibeConfig
  void _updateAiRecommendation() {
    final vibeConfig = VibeConfig.getConfig(_currentVibe);
    _aiRecommendationMessage =
        'Your usage patterns suggest ${vibeConfig.aiRecommendationContext}. '
        'Try: ${vibeConfig.suggestedActivities.first}.';
  }

  @override
  void dispose() {
    _ctrlAnimationController.dispose();
    _themeManager.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        titleWidget: _buildAnimatedCtrlTitle(theme),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notification-settings');
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
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
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: _currentVibeColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting header with vibe-specific message
                      GreetingHeaderWidget(
                        currentTime: DateTime.now(),
                        vibeColor: _currentVibeColor,
                        currentVibe: _currentVibe,
                      ),

                      SizedBox(height: 3.h),

                      // Vibe indicator card with emotional state
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/vibe-selection');
                        },
                        child: VibeIndicatorCardWidget(
                          currentVibe: _currentVibe,
                          vibeColor: _currentVibeColor,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // AI recommendation banner with vibe-specific suggestions
                      if (_showAiRecommendation)
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: AiRecommendationBannerWidget(
                            message: _aiRecommendationMessage,
                            vibeColor: _currentVibeColor,
                            onTap: () {
                              Navigator.pushNamed(context, '/ctrl-center');
                            },
                            onDismiss: () {
                              setState(() {
                                _showAiRecommendation = false;
                              });
                            },
                          ),
                        ),

                      // Section header
                      Text(
                        'Today\'s Usage',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Usage summary cards
                      UsageSummaryCardWidget(
                        usageData: _usageData,
                        vibeColor: _currentVibeColor,
                        onTap: () {
                          Navigator.pushNamed(context, '/usage-analytics');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showVibeSelector,
        backgroundColor: _currentVibeColor,
        icon: CustomIconWidget(
          iconName: 'psychology',
          color: theme.colorScheme.surface,
          size: 24,
        ),
        label: Text(
          'Change Vibe',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.surface,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/main-dashboard',
        vibeColor: _currentVibeColor,
        onNavigate: (route) {
          if (route != '/main-dashboard') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }

  /// Build animated CTRL title with glitching style changes
  Widget _buildAnimatedCtrlTitle(ThemeData theme) {
    final glitchVariation = _glitchVariations[_currentGlitchIndex];
    final fontFunction = glitchVariation['font'] as TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
    });

    return AnimatedBuilder(
      animation: _ctrlAnimationController,
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          child: Transform.scale(
            key: ValueKey(_currentGlitchIndex),
            scale: _ctrlScaleAnimation.value,
            child: Transform.rotate(
              angle: _ctrlRotationAnimation.value * (_isGlitching ? 2 : 1),
              child: Opacity(
                opacity: _ctrlOpacityAnimation.value,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      _currentVibeColor,
                      _currentVibeColor.withValues(alpha: 0.7),
                      _themeManager.secondaryVibeColor ?? _currentVibeColor,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'CTRL',
                    style: fontFunction(
                      fontSize: _isGlitching ? 26.sp : 24.sp,
                      fontWeight: glitchVariation['weight'],
                      fontStyle: glitchVariation['italic']
                          ? FontStyle.italic
                          : FontStyle.normal,
                      color: Colors.white,
                      letterSpacing: glitchVariation['italic'] ? 1.5 : 2.0,
                      shadows: [
                        Shadow(
                          color: _currentVibeColor.withValues(alpha: 0.5),
                          blurRadius: _isGlitching ? 12 : 8,
                          offset: Offset(
                            glitchVariation['italic'] ? -1 : 0,
                            _isGlitching ? 4 : 2,
                          ),
                        ),
                        if (_isGlitching)
                          Shadow(
                            color: _themeManager.secondaryVibeColor ??
                                _currentVibeColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(2, -2),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Handle pull-to-refresh
  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data sync
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
      // Update usage data here in real implementation
    });
  }

  /// Show vibe selector bottom sheet
  void _showVibeSelector() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _VibeQuickSelector(
        currentVibe: _currentVibe,
        onVibeSelected: (vibe, color) async {
          // Save with vibe name to ThemeManagerService for global sync
          await _themeManager.setPrimaryVibeColor(color, vibeName: vibe);

          setState(() {
            _currentVibe = vibe;
            _currentVibeColor = color;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Quick vibe selector bottom sheet
class _VibeQuickSelector extends StatelessWidget {
  final String currentVibe;
  final Function(String vibe, Color color) onVibeSelected;

  const _VibeQuickSelector({
    required this.currentVibe,
    required this.onVibeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final vibes = [
      {
        'name': 'Zen',
        'color': const Color(0xFF4A7C59),
        'icon': 'self_improvement'
      },
      {'name': 'Energized', 'color': const Color(0xFFE8B86D), 'icon': 'bolt'},
      {
        'name': 'Reflective',
        'color': const Color(0xFF6B73FF),
        'icon': 'psychology'
      },
      {
        'name': 'Focused',
        'color': const Color(0xFF2196F3),
        'icon': 'center_focus_strong'
      },
      {'name': 'Creative', 'color': const Color(0xFFE91E63), 'icon': 'palette'},
      {'name': 'Social', 'color': const Color(0xFFFF9800), 'icon': 'groups'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              'Quick Vibe Change',
              style: theme.textTheme.titleLarge,
            ),

            SizedBox(height: 2.h),

            // Vibe options grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1,
              ),
              itemCount: vibes.length,
              itemBuilder: (context, index) {
                final vibe = vibes[index];
                final isSelected = vibe['name'] == currentVibe;

                return GestureDetector(
                  onTap: () {
                    onVibeSelected(
                      vibe['name'] as String,
                      vibe['color'] as Color,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: (vibe['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? (vibe['color'] as Color)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: vibe['icon'] as String,
                          color: vibe['color'] as Color,
                          size: 32,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          vibe['name'] as String,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: vibe['color'] as Color,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 2.h),

            // View all button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/vibe-selection');
                },
                child: const Text('View All Vibes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
