import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../main_dashboard/widgets/dynamic_background_widget.dart';

/// Premium Upgrade Screen
/// Display premium features and subscription options
class PremiumUpgradeScreen extends StatefulWidget {
  const PremiumUpgradeScreen({super.key});

  @override
  State<PremiumUpgradeScreen> createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends State<PremiumUpgradeScreen>
    with SingleTickerProviderStateMixin {
  final ThemeManagerService _themeManager = ThemeManagerService();
  String _selectedPlan = 'monthly';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Color _currentVibeColor = AppTheme.primaryZen;

  final List<Map<String, dynamic>> _features = [
    {
      'icon': 'psychology',
      'title': 'AI Insights & Predictions',
      'description': 'Advanced pattern recognition and behavioral predictions'
    },
    {
      'icon': 'insights',
      'title': 'Trigger Pattern Analysis',
      'description': 'Deep analysis of your impulse triggers and timing'
    },
    {
      'icon': 'notifications_active',
      'title': 'Pre-emptive Nudges',
      'description': 'AI-powered alerts before urges strike'
    },
    {
      'icon': 'assessment',
      'title': 'Monthly Reports',
      'description': 'Comprehensive cognitive and behavioral reports'
    },
    {
      'icon': 'self_improvement',
      'title': 'Cognitive Resets',
      'description': 'Guided exercises for emotional regulation'
    },
    {
      'icon': 'track_changes',
      'title': 'Dopamine Budget',
      'description': 'Smart activity time management system'
    },
    {
      'icon': 'emoji_events',
      'title': 'Identity Goals',
      'description': 'Transform who you are, not just what you do'
    },
    {
      'icon': 'local_hospital',
      'title': 'Therapy Resources',
      'description': 'Access to mental health guides and professionals'
    },
  ];

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
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    await _themeManager.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void _startFreeTrial() {
    HapticFeedback.mediumImpact();

    // TODO: Implement subscription logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Free trial started! 🎉'),
        backgroundColor: _themeManager.primaryVibeColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Upgrade to Premium',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _currentVibeColor,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Premium Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _themeManager.primaryVibeColor,
                        _themeManager.primaryVibeColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'workspace_premium',
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Unlock AI-Powered Insights',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Advanced features for deeper self-awareness',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pricing Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildPricingCard(
                              context,
                              'Monthly',
                              '\$12',
                              'per month',
                              'monthly',
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: _buildPricingCard(
                              context,
                              'Annual',
                              '\$99',
                              'per year',
                              'annual',
                              badge: 'Save 31%',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Features List
                      Text(
                        'Premium Features',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _features.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          final feature = _features[index];
                          return Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: _themeManager.primaryVibeColor
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: feature['icon'],
                                    color: _themeManager.primaryVibeColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feature['title'],
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        feature['description'],
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: _themeManager.primaryVibeColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 3.h),

                      // Trust badges
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTrustBadge(
                                  context,
                                  'lock',
                                  'Secure',
                                ),
                                _buildTrustBadge(
                                  context,
                                  'cancel',
                                  'Cancel Anytime',
                                ),
                                _buildTrustBadge(
                                  context,
                                  'verified_user',
                                  'Private',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Start Free Trial Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _startFreeTrial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeManager.primaryVibeColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Start Free Trial',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      Center(
                        child: Text(
                          '7 days free, then ${_selectedPlan == 'monthly' ? '\$12/month' : '\$99/year'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),
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

  Widget _buildPricingCard(
    BuildContext context,
    String title,
    String price,
    String period,
    String planId, {
    String? badge,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedPlan == planId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = planId;
        });
        HapticFeedback.selectionClick();
      },
      child: Container(
        height: 18.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? _themeManager.primaryVibeColor.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? _themeManager.primaryVibeColor
                : const Color.fromARGB(255, 216, 216, 216),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (badge != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? _themeManager.primaryVibeColor
                        : theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  price,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? _themeManager.primaryVibeColor
                        : theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  period,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            isSelected
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: _themeManager.primaryVibeColor,
                      size: 20,
                    ),
                  )
                : Positioned(
                    top: 0,
                    right: 0,
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: const Color.fromARGB(255, 216, 216, 216),
                      size: 20,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadge(BuildContext context, String icon, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: _themeManager.primaryVibeColor,
          size: 24,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
