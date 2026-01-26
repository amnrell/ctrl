import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/profile_preferences_service.dart';

/// Widget for premium AI learning features
class PremiumAILearningWidget extends StatelessWidget {
  final ProfilePreferencesService preferencesService;

  const PremiumAILearningWidget({
    super.key,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremium = preferencesService.isPremium;
    final aiEnabled = preferencesService.aiLearningEnabled;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: isPremium
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !isPremium
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPremium
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: isPremium
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adaptive Intelligence',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!isPremium)
                      Text(
                        'Premium Feature',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              if (!isPremium)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'UPGRADE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          if (!isPremium)
            Text(
              'Enable AI to learn from your choices and provide personalized recommendations for vibe themes, regulation styles, and intervention timing.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            )
          else ...[
            SwitchListTile(
              title: Text('Enable AI Learning'),
              subtitle: Text(
                'Allow AI to learn from your vibe choices and patterns',
              ),
              value: aiEnabled,
              onChanged: (value) async {
                await preferencesService.setAILearning(value);
              },
            ),
            SizedBox(height: 2.h),
            if (aiEnabled) ...[
              _buildFeature(
                context,
                theme,
                'Personalized Models',
                'AI creates a unique model based on your behavior patterns',
                Icons.model_training_outlined,
              ),
              SizedBox(height: 1.5.h),
              _buildFeature(
                context,
                theme,
                'Trigger Prediction',
                'Predicts when you might need interventions before urges occur',
                Icons.trending_up_outlined,
              ),
              SizedBox(height: 1.5.h),
              _buildFeature(
                context,
                theme,
                'Relapse Probability',
                'Estimates risk of returning to compulsive behaviors',
                Icons.warning_amber_outlined,
              ),
              SizedBox(height: 1.5.h),
              _buildFeature(
                context,
                theme,
                'Tone Optimization',
                'Adjusts intervention tone based on your emotional state',
                Icons.tune_outlined,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context,
    ThemeData theme,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
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

