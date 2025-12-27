import 'package:flutter/material.dart';

class DataComplianceService {
  // In-memory placeholder until you wire persistence (SharedPreferences/SecureStorage/etc.)
  final Map<String, bool> _permissions = <String, bool>{
    'share_analytics': true,
    'share_crash_reports': true,
    'personalized_recommendations': true,
    'partner_data_sharing': false,
  };

  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<Map<String, bool>> getDataSharingPermissions() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return Map<String, bool>.from(_permissions);
  }

  Future<void> updateDataSharingPermission(String key, bool value) async {
    _permissions[key] = value;
    await Future.delayed(const Duration(milliseconds: 120));
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete All Data'),
            content: const Text(
              'This will permanently delete all locally stored data. '
              'This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> deleteAllUserData() async {
    _permissions.updateAll((_, __) => false);
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
