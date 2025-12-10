import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/custom_app_bar.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/emoji_reaction_widget.dart';
import './widgets/feedback_form_widget.dart';
import './widgets/thank_you_widget.dart';

/// Feedback & Rating System Screen
/// Captures user sentiment and prepares for App Store submission
class FeedbackRatingSystem extends StatefulWidget {
  const FeedbackRatingSystem({super.key});

  @override
  State<FeedbackRatingSystem> createState() => _FeedbackRatingSystemState();
}

class _FeedbackRatingSystemState extends State<FeedbackRatingSystem> {
  final ThemeManagerService _themeManager = ThemeManagerService();
  final InAppReview _inAppReview = InAppReview.instance;

  bool _isInitialized = false;
  int _selectedEmojiIndex = -1;
  bool _showFeedbackForm = false;
  bool _showThankYou = false;

  // User interaction tracking
  int _positiveInteractionsCount =
      3; // Mock data - would track real interactions
  int _daysUsed = 7; // Mock data - would track actual usage days

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      await _themeManager.initialize();
      _themeManager.addListener(_handleThemeChange);

      setState(() => _isInitialized = true);
    } catch (e) {
      print('Error initializing services: $e');
      setState(() => _isInitialized = true);
    }
  }

  void _handleThemeChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _themeManager.removeListener(_handleThemeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Feedback & Ratings',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: _showThankYou
          ? ThankYouWidget(
              onClose: () {
                setState(() {
                  _showThankYou = false;
                  _showFeedbackForm = false;
                  _selectedEmojiIndex = -1;
                });
              },
              themeManager: _themeManager,
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(theme),
                      SizedBox(height: 3.h),
                      if (!_showFeedbackForm) ...[
                        _buildQuickFeedbackSection(theme),
                        SizedBox(height: 3.h),
                        _buildRatingSection(theme),
                        SizedBox(height: 3.h),
                        _buildShareSection(theme),
                      ] else ...[
                        FeedbackFormWidget(
                          initialSentiment:
                              _getEmojiSentiment(_selectedEmojiIndex),
                          onSubmit: _handleFeedbackSubmit,
                          onCancel: () {
                            setState(() {
                              _showFeedbackForm = false;
                              _selectedEmojiIndex = -1;
                            });
                          },
                          themeManager: _themeManager,
                        ),
                      ],
                      SizedBox(height: 3.h),
                      _buildUsageStatsSection(theme),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _themeManager.primaryVibeColor.withValues(alpha: 0.1),
            _themeManager.primaryVibeColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _themeManager.primaryVibeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'stars',
            color: _themeManager.primaryVibeColor,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Your Feedback Matters',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: _themeManager.primaryVibeColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Help us improve CTRL and make digital wellbeing better for everyone',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFeedbackSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was your experience?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          EmojiReactionWidget(
            selectedIndex: _selectedEmojiIndex,
            onEmojiSelected: (index) {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedEmojiIndex = index;
                _showFeedbackForm = true;
              });
            },
            themeManager: _themeManager,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: Colors.amber,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Rate on App Store',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Love CTRL? Help others discover it by rating us on the App Store!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleRateApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeManager.primaryVibeColor,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Rate CTRL',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: _themeManager.primaryVibeColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Share with Friends',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Help your friends take control of their digital wellbeing',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _handleShareApp,
              style: OutlinedButton.styleFrom(
                foregroundColor: _themeManager.primaryVibeColor,
                side: BorderSide(
                  color: _themeManager.primaryVibeColor,
                  width: 1.5,
                ),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'share',
                    color: _themeManager.primaryVibeColor,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Share CTRL',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: _themeManager.primaryVibeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageStatsSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your CTRL Journey',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme,
                  'Days Active',
                  _daysUsed.toString(),
                  Icons.calendar_today,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  theme,
                  'Positive Actions',
                  _positiveInteractionsCount.toString(),
                  Icons.thumb_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      ThemeData theme, String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _themeManager.primaryVibeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: _themeManager.primaryVibeColor,
            size: 28,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _themeManager.primaryVibeColor,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmojiSentiment(int index) {
    switch (index) {
      case 0:
        return 'terrible';
      case 1:
        return 'bad';
      case 2:
        return 'okay';
      case 3:
        return 'good';
      case 4:
        return 'excellent';
      default:
        return 'neutral';
    }
  }

  Future<void> _handleRateApp() async {
    HapticFeedback.mediumImpact();

    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      } else {
        // Fallback to store listing
        final Uri appStoreUrl = Uri.parse(
            'https://apps.apple.com/app/id123456789'); // Replace with actual App Store ID
        final Uri playStoreUrl = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.ctrl.app');

        if (Theme.of(context).platform == TargetPlatform.iOS) {
          if (await canLaunchUrl(appStoreUrl)) {
            await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
          }
        } else {
          if (await canLaunchUrl(playStoreUrl)) {
            await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to open store at this time'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleShareApp() async {
    HapticFeedback.lightImpact();

    try {
      await Share.share(
        'Take control of your digital wellbeing with CTRL! 🎯\n\n'
        'Track your social media usage, manage your vibes, and build healthier digital habits.\n\n'
        'Download now: [App Store Link]', // Replace with actual store link
        subject: 'Check out CTRL - Digital Wellbeing App',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to share at this time'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleFeedbackSubmit(Map<String, dynamic> feedbackData) {
    // In production, send to backend/analytics
    print('Feedback submitted: $feedbackData');

    HapticFeedback.mediumImpact();
    setState(() => _showThankYou = true);

    // Auto-close thank you screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showThankYou = false;
          _showFeedbackForm = false;
          _selectedEmojiIndex = -1;
        });
      }
    });
  }
}
