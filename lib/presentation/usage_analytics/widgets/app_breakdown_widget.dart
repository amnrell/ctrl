import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// App-specific usage breakdown widget with tap-to-drill-down
class AppBreakdownWidget extends StatelessWidget {
  final List<Map<String, dynamic>> apps;
  final Function(Map<String, dynamic>) onAppTap;

  const AppBreakdownWidget({
    super.key,
    required this.apps,
    required this.onAppTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...apps.map((app) => _buildAppItem(context, app)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppItem(BuildContext context, Map<String, dynamic> app) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onAppTap(app),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            // App Icon
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: (app["color"] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomImageWidget(
                  imageUrl: app["icon"] as String,
                  width: 8.w,
                  height: 8.w,
                  fit: BoxFit.contain,
                  semanticLabel: app["semanticLabel"] as String,
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // App Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app["name"] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (app["percentage"] as int) / 100,
                            backgroundColor: theme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              app["color"] as Color,
                            ),
                            minHeight: 0.8.h,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${app["percentage"]}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 3.w),

            // Hours
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${app["hours"]} hrs',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: app["color"] as Color,
                  ),
                ),
                SizedBox(height: 0.5.h),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
