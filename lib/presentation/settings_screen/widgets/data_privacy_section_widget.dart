import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/data_compliance_service.dart';
import '../../../widgets/custom_icon_widget.dart';

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

class _DataPrivacySectionWidgetState
    extends State<DataPrivacySectionWidget> {
  Map<String, bool> _permissions = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    setState(() => _loading = true);
    final data =
        await widget.complianceService.getDataSharingPermissions();
    if (!mounted) return;
    setState(() {
      _permissions = data;
      _loading = false;
    });
  }

  Future<void> _updatePermission(String key, bool value) async {
    setState(() => _permissions[key] = value);
    await widget.complianceService
        .updateDataSharingPermission(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─────────────────────────
        // DELETE ACCOUNT (SERIOUS, NOT LOUD)
        // ─────────────────────────
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.error.withOpacity(0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Account Deletion',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                'This permanently deletes your account and all associated data.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete My Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: widget.onDataDeleted,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // ─────────────────────────
        // DATA PERMISSIONS
        // ─────────────────────────
        Text(
          'Data Permissions',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Control how your data is used. Changes take effect immediately.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 2.h),

        ..._permissions.entries.map(
          (entry) => Container(
            margin: EdgeInsets.only(bottom: 1.5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.25),
              ),
            ),
            child: SwitchListTile(
              value: entry.value,
              title: Text(
                entry.key.replaceAll('_', ' '),
                style: theme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Allow this data usage',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              onChanged: (v) =>
                  _updatePermission(entry.key, v),
            ),
          ),
        ),
      ],
    );
  }
}
