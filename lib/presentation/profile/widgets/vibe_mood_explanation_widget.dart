import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/theme_manager_service.dart';
import '../../../theme/app_theme.dart';

/// Widget explaining how different vibe colors affect moods and emotions
class VibeMoodExplanationWidget extends StatelessWidget {
  final ThemeManagerService themeManager;

  const VibeMoodExplanationWidget({
    super.key,
    required this.themeManager,
  });

  // Vibe mood explanations
  static const Map<String, Map<String, dynamic>> vibeMoodData = {
    'Zen': {
      'color': AppTheme.primaryZen,
      'mood': 'Calm & Grounded',
      'benefits': [
        'Reduces anxiety and stress',
        'Promotes mindfulness and presence',
        'Helps with emotional regulation',
        'Encourages peaceful reflection',
      ],
      'bestFor': 'Meditation, reflection, stress management',
      'psychology': 'Green tones are associated with nature, balance, and tranquility. They can lower heart rate and create a sense of stability.',
    },
    'Energy': {
      'color': AppTheme.primaryEnergy,
      'mood': 'Motivated & Active',
      'benefits': [
        'Boosts motivation and drive',
        'Enhances focus and productivity',
        'Increases energy levels',
        'Encourages action and movement',
      ],
      'bestFor': 'Workouts, creative projects, goal achievement',
      'psychology': 'Warm amber and yellow tones stimulate the mind, increase alertness, and can boost dopamine production.',
    },
    'Reflection': {
      'color': AppTheme.primaryReflection,
      'mood': 'Thoughtful & Introspective',
      'benefits': [
        'Encourages deep thinking',
        'Promotes self-awareness',
        'Facilitates problem-solving',
        'Supports creative insights',
      ],
      'bestFor': 'Journaling, planning, creative thinking',
      'psychology': 'Blue-purple tones are calming yet stimulating, promoting introspection while maintaining mental clarity.',
    },
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentVibe = themeManager.currentVibeName;
    final currentData = vibeMoodData[currentVibe] ?? vibeMoodData['Zen']!;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (currentData['color'] as Color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.color_lens_outlined,
                  color: currentData['color'] as Color,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Vibe: $currentVibe',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      currentData['mood'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildSection(
            context,
            theme,
            'Mood Benefits',
            currentData['benefits'] as List<String>,
            Icons.favorite_outline,
          ),
          SizedBox(height: 2.h),
          _buildInfoCard(
            context,
            theme,
            'Best For',
            currentData['bestFor'] as String,
            Icons.check_circle_outline,
          ),
          SizedBox(height: 2.h),
          _buildInfoCard(
            context,
            theme,
            'Color Psychology',
            currentData['psychology'] as String,
            Icons.psychology_outlined,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Premium AI can learn from your vibe choices and suggest optimal themes based on your patterns and goals.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    ThemeData theme,
    String title,
    List<String> items,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            SizedBox(width: 1.w),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ...items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 0.8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    ThemeData theme,
    String title,
    String content,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              SizedBox(width: 1.w),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            content,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

