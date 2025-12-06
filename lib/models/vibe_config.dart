import 'package:flutter/material.dart';

/// Vibe-specific configuration for dynamic personalization
/// Provides greeting, emotional prompts, and AI recommendation context per vibe
class VibeConfig {
  final String greeting;
  final String emotionalPrompt;
  final String aiRecommendationContext;
  final List<String> suggestedActivities;
  final IconData icon;

  const VibeConfig({
    required this.greeting,
    required this.emotionalPrompt,
    required this.aiRecommendationContext,
    required this.suggestedActivities,
    required this.icon,
  });

  /// Get vibe-specific configuration based on vibe name
  static VibeConfig getConfig(String vibeName) {
    switch (vibeName) {
      case 'Energized':
        return const VibeConfig(
          greeting: 'Ready to Energize',
          emotionalPrompt: 'Ready for an exercise?',
          aiRecommendationContext:
              'high-energy activities, workout routines, productivity hacks',
          suggestedActivities: [
            'Quick workout session',
            'Power walk',
            'Energizing playlist'
          ],
          icon: Icons.bolt,
        );
      case 'Zen':
        return const VibeConfig(
          greeting: 'Peace & Mindfulness',
          emotionalPrompt: 'Ready for some calm?',
          aiRecommendationContext:
              'meditation techniques, breathing exercises, mindfulness practices',
          suggestedActivities: [
            'Guided meditation',
            'Deep breathing',
            'Nature sounds'
          ],
          icon: Icons.self_improvement,
        );
      case 'Reflective':
        return const VibeConfig(
          greeting: 'Time to Reflect',
          emotionalPrompt: 'Ready for introspection?',
          aiRecommendationContext:
              'journaling prompts, self-reflection exercises, thoughtful readings',
          suggestedActivities: [
            'Journal entry',
            'Self-assessment',
            'Thought exploration'
          ],
          icon: Icons.psychology,
        );
      case 'Focused':
        return const VibeConfig(
          greeting: 'Time to Focus',
          emotionalPrompt: 'Ready for deep work?',
          aiRecommendationContext:
              'productivity techniques, concentration exercises, distraction management',
          suggestedActivities: [
            'Pomodoro session',
            'Focus timer',
            'Task prioritization'
          ],
          icon: Icons.center_focus_strong,
        );
      case 'Creative':
        return const VibeConfig(
          greeting: 'Let Creativity Flow',
          emotionalPrompt: 'Ready to create?',
          aiRecommendationContext:
              'creative exercises, brainstorming techniques, artistic inspiration',
          suggestedActivities: [
            'Freewriting session',
            'Visual brainstorming',
            'Creative exploration'
          ],
          icon: Icons.palette,
        );
      case 'Social':
        return const VibeConfig(
          greeting: 'Connect & Share',
          emotionalPrompt: 'Ready to engage?',
          aiRecommendationContext:
              'social interaction tips, meaningful conversations, community building',
          suggestedActivities: [
            'Reach out to a friend',
            'Join a discussion',
            'Share your thoughts'
          ],
          icon: Icons.groups,
        );
      default:
        return const VibeConfig(
          greeting: 'Good Day',
          emotionalPrompt: 'Ready to start?',
          aiRecommendationContext: 'general wellness tips, daily routines',
          suggestedActivities: ['Morning routine', 'Daily check-in'],
          icon: Icons.mood,
        );
    }
  }
}
