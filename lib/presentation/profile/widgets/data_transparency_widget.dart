import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/data_compliance_service.dart';

/// Widget for data transparency and privacy settings
class DataTransparencyWidget extends StatelessWidget {
  final DataComplianceService complianceService;

  const DataTransparencyWidget({
    super.key,
    required this.complianceService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Transparency',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Control what data is collected and how it\'s used. You have full transparency and control.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 2.h),
        _buildDataCard(
          context,
          theme,
          'Emotional Analysis',
          'Tracks mood patterns and emotional states to provide personalized recommendations',
          Icons.mood_outlined,
          'emotional_analysis',
        ),
        SizedBox(height: 1.5.h),
        _buildDataCard(
          context,
          theme,
          'Screen Time Correlation',
          'Correlates app usage with emotional states to identify patterns',
          Icons.access_time_outlined,
          'screen_time_correlation',
        ),
        SizedBox(height: 1.5.h),
        _buildDataCard(
          context,
          theme,
          'Analytics Data',
          'Aggregated usage statistics for app improvement',
          Icons.analytics_outlined,
          'analytics',
        ),
        SizedBox(height: 1.5.h),
        _buildDataCard(
          context,
          theme,
          'AI Training Data',
          'Allows AI to learn from your patterns (Premium feature)',
          Icons.smart_toy_outlined,
          'ai_training',
        ),
        SizedBox(height: 1.5.h),
        _buildDataCard(
          context,
          theme,
          'Educational Content',
          'Personalized educational content based on your usage',
          Icons.school_outlined,
          'educational_content',
        ),
        SizedBox(height: 1.5.h),
        _buildDataCard(
          context,
          theme,
          'Personalization',
          'Customize your experience based on your preferences',
          Icons.person_outline,
          'personalization',
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await complianceService.exportUserData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Data export initiated'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.download_outlined),
                label: Text('Export My Data'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await complianceService.showDeleteConfirmationDialog(context);
                  if (confirmed == true && context.mounted) {
                    await complianceService.deleteAllUserData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('All data deleted'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                icon: Icon(Icons.delete_outline),
                label: Text('Delete All Data'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataCard(
    BuildContext context,
    ThemeData theme,
    String title,
    String description,
    IconData icon,
    String permissionKey,
  ) {
    return FutureBuilder<Map<String, bool>>(
      future: complianceService.getDataSharingPermissions(),
      builder: (context, snapshot) {
        final isEnabled = snapshot.data?[permissionKey] ?? true;

        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 24),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: (value) async {
                  await complianceService.updateDataSharingPermission(
                    permissionKey,
                    value,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$title ${value ? "enabled" : "disabled"}'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

