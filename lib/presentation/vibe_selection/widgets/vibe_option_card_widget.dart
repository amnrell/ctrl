import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Individual vibe option card widget with color preview and description
/// Supports tap selection and long-press customization
class VibeOptionCardWidget extends StatelessWidget {
  final String vibeName;
  final Color vibeColor;
  final String vibeDescription;
  final String vibeIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const VibeOptionCardWidget({
    super.key,
    required this.vibeName,
    required this.vibeColor,
    required this.vibeDescription,
    required this.vibeIcon,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? vibeColor.withValues(alpha: 0.15)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? vibeColor
                : theme.colorScheme.outline.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: vibeColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Color circle with icon
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: vibeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: vibeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: vibeIcon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            SizedBox(height: 1.5.h),

            // Vibe name
            Text(
              vibeName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? vibeColor : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 0.5.h),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                vibeDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Selection indicator
            if (isSelected) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: vibeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Selected',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
