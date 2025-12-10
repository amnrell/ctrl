import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

/// Widget for displaying individual message bubbles in the chat interface
class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final Color vibeColor;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.vibeColor,
  });

  void _showMessageOptions(BuildContext context) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10.w,
                  height: 0.5.h,
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.copy,
                    color: theme.colorScheme.onSurface,
                  ),
                  title: Text(
                    'Copy message',
                    style: theme.textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: message));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.share,
                    color: theme.colorScheme.onSurface,
                  ),
                  title: Text(
                    'Share message',
                    style: theme.textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Share functionality would be implemented here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share functionality coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(context),
        child: Container(
          constraints: BoxConstraints(maxWidth: 75.w),
          margin: EdgeInsets.only(bottom: 1.5.h),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isUser
                      ? vibeColor
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isUser ? 16 : 4),
                    topRight: Radius.circular(isUser ? 4 : 16),
                    bottomLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(16),
                  ),
                ),
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isUser
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 0.5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  timeFormat.format(timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.6),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
