// KEEP ALL YOUR IMPORTS THE SAME
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../core/app_export.dart';
import '../../utils/responsive_helper.dart';
import './widgets/ai_recommendation_banner_widget.dart';
import './widgets/dynamic_background_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/usage_summary_card_widget.dart';
import './widgets/vibe_indicator_card_widget.dart';
import './widgets/day_streak_card_widget.dart';
import '../../services/theme_manager_service.dart';
import '../../models/vibe_config.dart';
import '../../theme/app_theme.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with SingleTickerProviderStateMixin {
  String _currentVibe = 'Zen';
  Color _currentVibeColor = const Color(0xFF4A7C59);

  final ThemeManagerService _themeManager = ThemeManagerService();
  final Random _random = Random();

  bool _showAiRecommendation = true;
  bool _showDetectedPatterns = true;

  String _aiRecommendationMessage = '';

  // CTRL title animation
  late AnimationController _ctrlController;
  late Animation<double> _ctrlScale;
  late Animation<double> _ctrlOpacity;

  bool _isGlitching = false;

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

  @override
  void initState() {
    super.initState();

    _ctrlController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _ctrlScale =
        Tween<double>(begin: 0.85, end: 1).animate(CurvedAnimation(
      parent: _ctrlController,
      curve: Curves.elasticOut,
    ));

    _ctrlOpacity =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _ctrlController,
      curve: Curves.easeIn,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();
      if (!mounted) return;

      setState(() {
        _currentVibeColor = _themeManager.primaryVibeColor;
        _currentVibe = _themeManager.currentVibeName;
        _updateAiRecommendation();
      });

      _startGlitch();
    });

    _themeManager.addListener(() {
      if (!mounted) return;
      setState(() {
        _currentVibeColor = _themeManager.primaryVibeColor;
        _currentVibe = _themeManager.currentVibeName;
        _updateAiRecommendation();
      });
      _startGlitch();
    });
  }

  void _startGlitch() {
    _isGlitching = true;
    _ctrlController.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isGlitching = false);
    });
  }

  void _updateAiRecommendation() {
    final vibeConfig = VibeConfig.getConfig(_currentVibe);
    _aiRecommendationMessage =
        'Your usage patterns suggest ${vibeConfig.aiRecommendationContext}. '
        'Try: ${vibeConfig.suggestedActivities.first}.';
  }

  @override
  void dispose() {
    _ctrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        titleWidget: _buildAnimatedCtrlTitle(theme),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _currentVibeColor,
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreetingHeaderWidget(
                    currentTime: DateTime.now(),
                    vibeColor: _currentVibeColor,
                    currentVibe: _currentVibe,
                  ),

                  SizedBox(height: 3.h),

                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/vibe-selection'),
                    child: VibeIndicatorCardWidget(
                      currentVibe: _currentVibe,
                      vibeColor: _currentVibeColor,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  if (_showAiRecommendation)
                    AiRecommendationBannerWidget(
                      message: _aiRecommendationMessage,
                      vibeColor: _currentVibeColor,
                      onTap: () =>
                          Navigator.pushNamed(context, '/ctrl-center'),
                      onDismiss: () =>
                          setState(() => _showAiRecommendation = false),
                    ),

                  SizedBox(height: 3.h),

                  Text('Today’s Usage', style: theme.textTheme.titleLarge),

                  SizedBox(height: 2.h),

                 UsageSummaryCardWidget(
  usageData: {
  ..._usageData,
  'detectedPatterns': <String>[],
},

  vibeColor: _currentVibeColor,
  onTap: () {
    Navigator.pushNamed(context, '/usage-analytics');
  },
),


                  SizedBox(height: 2.h),

                  // 🟡 DISMISSIBLE DETECTED PATTERNS
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _showDetectedPatterns
                        ? Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color:
                                  _currentVibeColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _currentVibeColor.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded,
                                        color: _currentVibeColor),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        'Detected Patterns',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => setState(() =>
                                          _showDetectedPatterns = false),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                ..._usageData['detectedPatterns']
                                    .map<Widget>(
                                  (p) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.3.h),
                                    child: Text('• $p'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ResponsiveHelper.isDesktop(context)
          ? null
          : FloatingActionButton.extended(
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
    );
  }
Widget _buildAnimatedCtrlTitle(ThemeData theme) {
  final double jitterX =
      _isGlitching ? (_random.nextDouble() * 4 - 2) : 0;
  final double jitterY =
      _isGlitching ? (_random.nextDouble() * 2 - 1) : 0;

  return AnimatedBuilder(
    animation: _ctrlController,
    builder: (_, __) {
      return Transform.translate(
        offset: Offset(jitterX, jitterY),
        child: Transform.scale(
          scale: _ctrlScale.value,
          child: Opacity(
            opacity: _ctrlOpacity.value,
            child: Text(
              'CTRL',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: _currentVibeColor,
                fontWeight: FontWeight.w900,
                letterSpacing: _isGlitching ? 4 : 2,
                shadows: _isGlitching
                    ? [
                        Shadow(
                          color: _currentVibeColor.withOpacity(0.6),
                          blurRadius: 12,
                          offset: const Offset(2, 2),
                        ),
                        Shadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(-2, -2),
                        ),
                      ]
                    : [],
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

  /// Build quick action card
  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    String subtitle,
    String icon,
    Color color,
    String route,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      {'name': 'Zen', 'color': AppTheme.primaryZen, 'icon': 'self_improvement'},
      {'name': 'Energized', 'color': AppTheme.primaryEnergy, 'icon': 'bolt'},
      {
        'name': 'Reflective',
        'color': AppTheme.primaryReflection,
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
