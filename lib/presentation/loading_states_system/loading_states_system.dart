import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Loading States System providing consistent feedback across all app interactions
/// Three patterns: skeleton screens, spinner overlays, and progress bars
class LoadingStatesSystem {
  /// Skeleton screen for content-heavy areas
  static Widget skeletonScreen({
    required BuildContext context,
    Color? primaryColor,
    int itemCount = 3,
  }) {
    final theme = Theme.of(context);
    final color = primaryColor ?? theme.colorScheme.primary;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: _SkeletonCard(shimmerColor: color),
          );
        }),
      ),
    );
  }

  /// Spinner overlay for quick actions
  static Widget spinnerOverlay({
    required BuildContext context,
    Color? spinnerColor,
    String? message,
  }) {
    final theme = Theme.of(context);
    final color = spinnerColor ?? theme.colorScheme.primary;

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 3,
            ),
            if (message != null) ...[
              SizedBox(height: 2.h),
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Progress bar for data-intensive operations
  static Widget progressBar({
    required BuildContext context,
    required double progress,
    Color? progressColor,
    String? message,
  }) {
    final theme = Theme.of(context);
    final color = progressColor ?? theme.colorScheme.primary;

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 80.w,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message != null) ...[
                Text(
                  message,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 1.5.h,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${(progress * 100).toInt()}%',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Small inline spinner for in-widget loading
  static Widget inlineSpinner({
    required BuildContext context,
    Color? spinnerColor,
    double? size,
  }) {
    final theme = Theme.of(context);
    final color = spinnerColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: size ?? 6.w,
      height: size ?? 6.w,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 2,
      ),
    );
  }

  /// Error state widget with retry
  static Widget errorState({
    required BuildContext context,
    required String message,
    required VoidCallback onRetry,
    Color? accentColor,
  }) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.error;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: color,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 1.8.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state widget
  static Widget emptyState({
    required BuildContext context,
    required String message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Color? accentColor,
  }) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_rounded,
              color: color.withValues(alpha: 0.5),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 4.h),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 1.8.h,
                  ),
                ),
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton card with shimmer effect
class _SkeletonCard extends StatefulWidget {
  final Color shimmerColor;

  const _SkeletonCard({required this.shimmerColor});

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title skeleton
              Container(
                width: 60.w,
                height: 2.5.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + _shimmerController.value * 2, 0),
                    end: Alignment(1.0 + _shimmerController.value * 2, 0),
                    colors: [
                      widget.shimmerColor.withValues(alpha: 0.1),
                      widget.shimmerColor.withValues(alpha: 0.3),
                      widget.shimmerColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 1.5.h),
              // Subtitle skeleton
              Container(
                width: 40.w,
                height: 1.8.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + _shimmerController.value * 2, 0),
                    end: Alignment(1.0 + _shimmerController.value * 2, 0),
                    colors: [
                      widget.shimmerColor.withValues(alpha: 0.1),
                      widget.shimmerColor.withValues(alpha: 0.3),
                      widget.shimmerColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 2.h),
              // Content skeleton
              Container(
                width: double.infinity,
                height: 8.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + _shimmerController.value * 2, 0),
                    end: Alignment(1.0 + _shimmerController.value * 2, 0),
                    colors: [
                      widget.shimmerColor.withValues(alpha: 0.1),
                      widget.shimmerColor.withValues(alpha: 0.3),
                      widget.shimmerColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
