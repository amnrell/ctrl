import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Widget showing AI typing indicator with animated dots
class AiTypingIndicatorWidget extends StatefulWidget {
  const AiTypingIndicatorWidget({super.key});

  @override
  State<AiTypingIndicatorWidget> createState() =>
      _AiTypingIndicatorWidgetState();
}

class _AiTypingIndicatorWidgetState extends State<AiTypingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 30.w),
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delay = index * 0.2;
                final value = (_animationController.value + delay) % 1.0;
                final opacity = value < 0.5 ? value * 2 : (1 - value) * 2;

                return Container(
                  width: 2.w,
                  height: 2.w,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3 + (opacity * 0.7)),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
