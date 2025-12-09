import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Third onboarding page - Initial vibe selection
class OnboardingPageThreeWidget extends StatelessWidget {
  final Color vibeColor;
  final Function(String, Color) onVibeSelected;
  final String selectedVibe;

  const OnboardingPageThreeWidget({
    super.key,
    required this.vibeColor,
    required this.onVibeSelected,
    required this.selectedVibe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final vibes = [
      {
        'name': 'Zen',
        'color': const Color(0xFF4A7C59),
        'icon': Icons.self_improvement,
        'description': 'Calm & Peaceful',
      },
      {
        'name': 'Energized',
        'color': const Color(0xFFE8B86D),
        'icon': Icons.bolt,
        'description': 'Active & Motivated',
      },
      {
        'name': 'Reflective',
        'color': const Color(0xFF6B73FF),
        'icon': Icons.psychology,
        'description': 'Thoughtful & Contemplative',
      },
      {
        'name': 'Focused',
        'color': const Color(0xFF2196F3),
        'icon': Icons.center_focus_strong,
        'description': 'Concentrated & Productive',
      },
      {
        'name': 'Creative',
        'color': const Color(0xFFE91E63),
        'icon': Icons.palette,
        'description': 'Imaginative & Expressive',
      },
      {
        'name': 'Social',
        'color': const Color(0xFFFF9800),
        'icon': Icons.groups,
        'description': 'Connected & Engaging',
      },
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          children: [
            SizedBox(height: 4.h),

            // Title
            Text(
              'How are you feeling?',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Subtitle
            Text(
              'Select your current vibe. You can change this anytime.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Vibe grid
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 0.9,
                ),
                itemCount: vibes.length,
                itemBuilder: (context, index) {
                  final vibe = vibes[index];
                  final isSelected = vibe['name'] == selectedVibe;

                  return GestureDetector(
                    onTap: () {
                      onVibeSelected(
                        vibe['name'] as String,
                        vibe['color'] as Color,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: (vibe['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? (vibe['color'] as Color)
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (vibe['color'] as Color)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              color: (vibe['color'] as Color)
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              vibe['icon'] as IconData,
                              color: vibe['color'] as Color,
                              size: 36,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            vibe['name'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: vibe['color'] as Color,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Text(
                              vibe['description'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),

            // AI assistant introduction
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: vibeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.smart_toy_rounded,
                    color: vibeColor,
                    size: 28,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Your AI assistant will help you maintain healthy digital habits based on your mood',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
