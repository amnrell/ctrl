import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// AI-suggested vibes widget displaying recommendations based on social media patterns
/// Shows reasoning and allows quick selection
class AiSuggestedVibesWidget extends StatelessWidget {
  final Function(String, Color) onVibeSelected;
  final String? selectedVibe;

  const AiSuggestedVibesWidget({
    super.key,
    required this.onVibeSelected,
    this.selectedVibe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock AI suggestions based on usage patterns
    final List<Map<String, dynamic>> aiSuggestions = [
      {
        'name': 'Calm',
        'color': Color(0xFF6B73FF),
        'reason':
            'Your recent social media activity shows increased scrolling. A calm vibe might help you reflect.',
        'confidence': 0.85,
        'icon': 'water_drop',
      },
      {
        'name': 'Focused',
        'color': Color(0xFF2C3E50),
        'reason':
            'You\'ve been engaging with productivity content. Stay focused!',
        'confidence': 0.72,
        'icon': 'center_focus_strong',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Recommendations',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Based on your recent activity',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Suggested vibes
          ...aiSuggestions.map((suggestion) {
            final isSelected = selectedVibe == suggestion['name'];

            return Container(
              margin: EdgeInsets.only(bottom: 1.5.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onVibeSelected(
                      suggestion['name'] as String,
                      suggestion['color'] as Color,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (suggestion['color'] as Color)
                              .withValues(alpha: 0.15)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? (suggestion['color'] as Color)
                            : theme.colorScheme.outline.withValues(alpha: 0.15),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Vibe color indicator
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: suggestion['color'] as Color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (suggestion['color'] as Color)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: suggestion['icon'] as String,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        SizedBox(width: 3.w),

                        // Vibe info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    suggestion['name'] as String,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? (suggestion['color'] as Color)
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (suggestion['color'] as Color)
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${((suggestion['confidence'] as double) * 100).toInt()}% match',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: suggestion['color'] as Color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                suggestion['reason'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Selection indicator
                        if (isSelected)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: suggestion['color'] as Color,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
