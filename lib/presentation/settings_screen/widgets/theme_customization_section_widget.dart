import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../services/theme_manager_service.dart';

/// Widget for vibe color theme customization with color combinations
class ThemeCustomizationSectionWidget extends StatelessWidget {
  final ThemeManagerService themeManager;
  final VoidCallback onThemeChanged;

  const ThemeCustomizationSectionWidget({
    super.key,
    required this.themeManager,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Icon(
                Icons.palette_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Theme & Vibes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Theme mode toggle
          _buildThemeModeToggle(theme),
          SizedBox(height: 2.h),

          // Vibe color combinations
          Text(
            'Vibe Color Combinations',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          _buildVibeColorCombinations(theme),
        ],
      ),
    );
  }

  Widget _buildThemeModeToggle(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                themeManager.isLightMode ? Icons.light_mode : Icons.dark_mode,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                themeManager.isLightMode ? 'Light Mode' : 'Dark Mode',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          Switch(
            value: !themeManager.isLightMode,
            onChanged: (value) async {
              HapticFeedback.lightImpact();
              await themeManager.toggleThemeMode();
              onThemeChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVibeColorCombinations(ThemeData theme) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: ThemeManagerService.vibeColorCombinations.entries.map((entry) {
        final isSelected = _isCurrentCombination(entry.key);

        return GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();
            await themeManager.setVibeColorCombination(entry.key);
            onThemeChanged();
          },
          child: Container(
            width: 28.w,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
              gradient: LinearGradient(
                colors: entry.value.length > 1
                    ? [entry.value[0], entry.value[1]]
                    : [entry.value[0], entry.value[0].withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                SizedBox(height: 1.h),
                Text(
                  _getCombinationName(entry.key),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isCurrentCombination(String key) {
    final colors = ThemeManagerService.vibeColorCombinations[key];
    if (colors == null) return false;

    final primaryMatch = colors[0].value == themeManager.primaryVibeColor.value;

    if (colors.length > 1) {
      final secondaryMatch = themeManager.secondaryVibeColor != null &&
          colors[1].value == themeManager.secondaryVibeColor!.value;
      return primaryMatch && secondaryMatch;
    }

    return primaryMatch && themeManager.secondaryVibeColor == null;
  }

  String _getCombinationName(String key) {
    return key
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' + ');
  }
}
