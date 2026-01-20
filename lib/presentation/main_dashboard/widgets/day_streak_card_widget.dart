import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

/// Day Streak Card Widget
/// Displays current streak with visual emphasis
class DayStreakCardWidget extends StatelessWidget {
  final int currentStreak;
  final Color vibeColor;
  final VoidCallback? onTap;

  const DayStreakCardWidget({
    super.key,
    required this.currentStreak,
    required this.vibeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              vibeColor,
              vibeColor.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: vibeColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        currentStreak.toString(),
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 56,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'local_fire_department',
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '+1',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Day Streak 🔥',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Keep the momentum going!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'trending_up',
              color: Colors.white.withValues(alpha: 0.3),
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}
