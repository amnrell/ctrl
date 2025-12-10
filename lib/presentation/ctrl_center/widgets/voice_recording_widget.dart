import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for voice recording interface with waveform animation
class VoiceRecordingWidget extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const VoiceRecordingWidget({
    super.key,
    required this.isRecording,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isRecording) ...[
          // Waveform animation
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final value = (_animationController.value + delay) % 1.0;
                    final height = 2.h + (3.h * value);

                    return Container(
                      width: 1.w,
                      height: height,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          SizedBox(width: 4.w),
        ],

        // Recording button
        GestureDetector(
          onTap: widget.isRecording
              ? widget.onStopRecording
              : widget.onStartRecording,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isRecording ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isRecording
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isRecording
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary)
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: widget.isRecording ? 'stop' : 'mic',
                      color: theme.colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (widget.isRecording) ...[
          SizedBox(width: 4.w),
          Text(
            'Recording...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
