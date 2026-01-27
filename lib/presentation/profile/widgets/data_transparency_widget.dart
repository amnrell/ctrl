import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/data_compliance_service.dart';

/// Widget for data transparency and privacy settings
class DataTransparencyWidget extends StatefulWidget {
  final DataComplianceService complianceService;

  const DataTransparencyWidget({
    super.key,
    required this.complianceService,
  });

  @override
  State<DataTransparencyWidget> createState() => _DataTransparencyWidgetState();
}

class _DataTransparencyWidgetState extends State<DataTransparencyWidget> {
  Map<String, bool> _permissions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final permissions = await widget.complianceService.getDataSharingPermissions();
    if (mounted) {
      setState(() {
        _permissions = permissions;
        _isLoading = false;
      });
    }
  }

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
        if (_isLoading)
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              final success = await widget.complianceService.exportUserDataToFile(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success 
                        ? 'Data exported successfully to Downloads folder'
                        : 'Failed to export data. Please try again.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            icon: Icon(Icons.download_outlined),
            label: Text('Export My Data'),
          ),
          
        ),
          SizedBox(height: 5.h),
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
    final isEnabled = _permissions[permissionKey] ?? true;

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
                  // Update UI immediately
                  setState(() {
                    _permissions[permissionKey] = value;
                  });
                  // Save to service
                  await widget.complianceService.updateDataSharingPermission(
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
  }
}

