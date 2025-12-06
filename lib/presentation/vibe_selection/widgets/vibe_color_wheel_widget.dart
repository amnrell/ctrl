import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Color wheel visualization widget for vibe selection
/// Displays vibes in a circular arrangement with interactive selection
class VibeColorWheelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> vibes;
  final String? selectedVibe;
  final Function(String, Color) onVibeSelected;

  const VibeColorWheelWidget({
    super.key,
    required this.vibes,
    required this.selectedVibe,
    required this.onVibeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 35.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerX = constraints.maxWidth / 2;
          final centerY = constraints.maxHeight / 2;
          final radius = math.min(centerX, centerY) * 0.7;

          return Stack(
            children: [
              // Center circle
              Positioned(
                left: centerX - 8.w,
                top: centerY - 8.w,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'psychology',
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                ),
              ),

              // Vibe circles arranged in a wheel
              ...List.generate(vibes.length, (index) {
                final angle =
                    (2 * math.pi * index) / vibes.length - math.pi / 2;
                final x = centerX + radius * math.cos(angle);
                final y = centerY + radius * math.sin(angle);
                final vibe = vibes[index];
                final isSelected = selectedVibe == vibe['name'];

                return Positioned(
                  left: x - (isSelected ? 6.w : 5.w),
                  top: y - (isSelected ? 6.w : 5.w),
                  child: GestureDetector(
                    onTap: () => onVibeSelected(
                      vibe['name'] as String,
                      vibe['color'] as Color,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isSelected ? 12.w : 10.w,
                      height: isSelected ? 12.w : 10.w,
                      decoration: BoxDecoration(
                        color: vibe['color'] as Color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (vibe['color'] as Color)
                                .withValues(alpha: isSelected ? 0.5 : 0.3),
                            blurRadius: isSelected ? 12 : 8,
                            spreadRadius: isSelected ? 3 : 1,
                          ),
                        ],
                        border: isSelected
                            ? Border.all(
                                color: Colors.white,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? Center(
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
