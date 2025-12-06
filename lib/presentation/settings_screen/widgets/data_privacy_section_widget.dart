import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/data_compliance_service.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Data Privacy Section Widget with enhanced transparency features
/// Includes delete all data, export data, and granular permissions management
class DataPrivacySectionWidget extends StatefulWidget {
  final DataComplianceService complianceService;
  final VoidCallback onDataDeleted;

  const DataPrivacySectionWidget({
    super.key,
    required this.complianceService,
    required this.onDataDeleted,
  });

  @override
  State<DataPrivacySectionWidget> createState() =>
      _DataPrivacySectionWidgetState();
}

class _DataPrivacySectionWidgetState extends State<DataPrivacySectionWidget> {
  Map<String, bool> _permissions = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    setState(() => _isLoading = true);
    _permissions = await widget.complianceService.getDataSharingPermissions();
    setState(() => _isLoading = false);
  }

  Future<void> _updatePermission(String key, bool value) async {
    setState(() {
      _permissions[key] = value;
    });
    await widget.complianceService.updateDataSharingPermission(key, value);
  }

  Future<void> _exportData() async {
    setState(() => _isLoading = true);
    final success =
        await widget.complianceService.exportUserDataToFile(context);
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Data exported successfully' : 'Failed to export data',
          ),
          backgroundColor: success
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Delete All Data Button
          _buildActionTile(
            context,
            icon: 'delete_forever',
            title: 'Delete All Data',
            subtitle: 'Permanently remove all your data from our servers',
            color: theme.colorScheme.error,
            onTap: widget.onDataDeleted,
            isDestructive: true,
          ),

          Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),

          // Export Data Button
          _buildActionTile(
            context,
            icon: 'download',
            title: 'Export My Data',
            subtitle: 'Download a copy of all your data',
            color: theme.colorScheme.primary,
            onTap: _exportData,
          ),

          Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),

          // Permissions Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'psychology',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'AI Data Collection & Permissions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How Adaptive Emotional Intelligence Works',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      _buildInfoBullet(
                        context,
                        'Analyzes conversation sentiment and emotional keywords to detect patterns',
                      ),
                      _buildInfoBullet(
                        context,
                        'Tracks vibe preferences and usage timing for personalized recommendations',
                      ),
                      _buildInfoBullet(
                        context,
                        'Correlates social media activity with emotional states for insights',
                      ),
                      _buildInfoBullet(
                        context,
                        'Uses anonymized aggregated data to improve prediction accuracy',
                      ),
                      _buildInfoBullet(
                        context,
                        'References research-backed stress reduction strategies and articles',
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Control your data permissions below to customize what the AI can access.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Permission Toggles
          _buildPermissionTile(
            context,
            title: 'Emotional Pattern Analysis',
            description:
                'Allow AI to analyze your conversations for emotional insights',
            permissionKey: 'emotional_analysis',
          ),

          _buildPermissionTile(
            context,
            title: 'Screen Time Correlation',
            description:
                'Connect screen time data with emotional states for personalized recommendations',
            permissionKey: 'screen_time_correlation',
          ),

          _buildPermissionTile(
            context,
            title: 'Usage Analytics',
            description:
                'Allow anonymous usage data collection for app improvement',
            permissionKey: 'analytics',
          ),

          _buildPermissionTile(
            context,
            title: 'AI Training',
            description:
                'Use my anonymized conversations to improve AI responses',
            permissionKey: 'ai_training',
          ),

          _buildPermissionTile(
            context,
            title: 'Educational Content Access',
            description:
                'Allow AI to reference stress-reducing articles and research',
            permissionKey: 'educational_content',
          ),

          _buildPermissionTile(
            context,
            title: 'Personalization',
            description:
                'Store preferences and vibe history for better recommendations',
            permissionKey: 'personalization',
          ),

          _buildPermissionTile(
            context,
            title: 'Third-Party Sharing',
            description:
                'Share data with social media platforms for enhanced features',
            permissionKey: 'third_party',
          ),

          SizedBox(height: 2.h),

          // Privacy Policy Link
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'shield',
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                InkWell(
                  onTap: () {
                    // Open privacy policy
                  },
                  child: Text(
                    'View Privacy Policy',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isDestructive ? color : theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(
    BuildContext context, {
    required String title,
    required String description,
    required String permissionKey,
  }) {
    final theme = Theme.of(context);
    final isEnabled = _permissions[permissionKey] ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Switch(
            value: isEnabled,
            onChanged: (value) => _updatePermission(permissionKey, value),
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBullet(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h, left: 1.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: Container(
              width: 1.5.w,
              height: 1.5.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
