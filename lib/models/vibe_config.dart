import 'package:flutter/material.dart';

/// Vibe-specific configuration for dynamic personalization
/// Provides greeting, emotional prompts, and AI recommendation context per vibe
class VibeConfig {
  final String greeting;
  final String emotionalPrompt;
  final String aiRecommendationContext;
  final List<String> suggestedActivities;
  final IconData icon;
  final Color color;
  final String name;

  const VibeConfig({
    required this.greeting,
    required this.emotionalPrompt,
    required this.aiRecommendationContext,
    required this.suggestedActivities,
    required this.icon,
    required this.color,
    required this.name,
  });

  /// Get all available vibes for color selection
  static List<VibeConfig> getAllVibes() {
    return [
      getConfig('Energized'),
      getConfig('Zen'),
      getConfig('Reflective'),
      getConfig('Focused'),
      getConfig('Creative'),
      getConfig('Social'),
    ];
  }

  /// Get vibe-specific configuration based on vibe name
  static VibeConfig getConfig(String vibeName) {
    switch (vibeName) {
      case 'Energized':
        return const VibeConfig(
          name: 'Energized',
          greeting: 'Ready to Energize',
          emotionalPrompt: 'Ready for an exercise?',
          aiRecommendationContext:
              'high-energy activities, workout routines, productivity hacks',
          suggestedActivities: [
            'Quick workout session',
            'Power walk',
            'Energizing playlist',
          ],
          icon: Icons.bolt,
          color: Color(0xFFE8B86D),
        );
      case 'Zen':
        return const VibeConfig(
          name: 'Zen',
          greeting: 'Peace & Mindfulness',
          emotionalPrompt: 'Ready for some calm?',
          aiRecommendationContext:
              'meditation techniques, breathing exercises, mindfulness practices',
          suggestedActivities: [
            'Guided meditation',
            'Deep breathing',
            'Nature sounds',
          ],
          icon: Icons.self_improvement,
          color: Color(0xFF4A7C59),
        );
      case 'Reflective':
        return const VibeConfig(
          name: 'Reflective',
          greeting: 'Time to Reflect',
          emotionalPrompt: 'Ready for introspection?',
          aiRecommendationContext:
              'journaling prompts, self-reflection exercises, thoughtful readings',
          suggestedActivities: [
            'Journal entry',
            'Self-assessment',
            'Thought exploration',
          ],
          icon: Icons.psychology,
          color: Color(0xFF6B73FF),
        );
      case 'Focused':
        return const VibeConfig(
          name: 'Focused',
          greeting: 'Time to Focus',
          emotionalPrompt: 'Ready for deep work?',
          aiRecommendationContext:
              'productivity techniques, concentration exercises, distraction management',
          suggestedActivities: [
            'Pomodoro session',
            'Focus timer',
            'Task prioritization',
          ],
          icon: Icons.center_focus_strong,
          color: Color(0xFF9C27B0),
        );
      case 'Creative':
        return const VibeConfig(
          name: 'Creative',
          greeting: 'Let Creativity Flow',
          emotionalPrompt: 'Ready to create?',
          aiRecommendationContext:
              'creative exercises, brainstorming techniques, artistic inspiration',
          suggestedActivities: [
            'Freewriting session',
            'Visual brainstorming',
            'Creative exploration',
          ],
          icon: Icons.palette,
          color: Color(0xFFFF6B9D),
        );
      case 'Social':
        return const VibeConfig(
          name: 'Social',
          greeting: 'Connect & Share',
          emotionalPrompt: 'Ready to engage?',
          aiRecommendationContext:
              'social interaction tips, meaningful conversations, community building',
          suggestedActivities: [
            'Reach out to a friend',
            'Join a discussion',
            'Share your thoughts',
          ],
          icon: Icons.groups,
          color: Color(0xFF00BCD4),
        );
      default:
        return const VibeConfig(
          name: 'Default',
          greeting: 'Good Day',
          emotionalPrompt: 'Ready to start?',
          aiRecommendationContext: 'general wellness tips, daily routines',
          suggestedActivities: ['Morning routine', 'Daily check-in'],
          icon: Icons.mood,
          color: Color(0xFF4CAF50),
        );
    }
  }
}
