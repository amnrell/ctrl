import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/theme_manager_service.dart';

/// Emoji reaction selector for quick sentiment capture
class EmojiReactionWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onEmojiSelected;
  final ThemeManagerService themeManager;

  const EmojiReactionWidget({
    super.key,
    required this.selectedIndex,
    required this.onEmojiSelected,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> emojis = [
      {'emoji': '😢', 'label': 'Terrible'},
      {'emoji': '😕', 'label': 'Bad'},
      {'emoji': '😐', 'label': 'Okay'},
      {'emoji': '😊', 'label': 'Good'},
      {'emoji': '🤩', 'label': 'Excellent'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(emojis.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onEmojiSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? themeManager.primaryVibeColor.withValues(alpha: 0.15)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? themeManager.primaryVibeColor
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  emojis[index]['emoji'],
                  style: TextStyle(fontSize: 32.sp),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  emojis[index]['label'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? themeManager.primaryVibeColor
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
