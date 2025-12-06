import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

/// Data compliance service for handling user data deletion and privacy permissions
/// Implements GDPR, CCPA, and general data protection regulations
class DataComplianceService {
  static final DataComplianceService _instance =
      DataComplianceService._internal();
  factory DataComplianceService() => _instance;
  DataComplianceService._internal();

  // Data sharing permissions
  bool _analyticsDataSharing = false;
  bool _crashReportingSharing = false;
  bool _usageDataSharing = false;
  bool _aiTrainingDataSharing = false;

  // Getters
  bool get analyticsDataSharing => _analyticsDataSharing;
  bool get crashReportingSharing => _crashReportingSharing;
  bool get usageDataSharing => _usageDataSharing;
  bool get aiTrainingDataSharing => _aiTrainingDataSharing;

  /// Initialize compliance settings from shared preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _analyticsDataSharing = prefs.getBool('analytics_data_sharing') ?? false;
    _crashReportingSharing = prefs.getBool('crash_reporting_sharing') ?? false;
    _usageDataSharing = prefs.getBool('usage_data_sharing') ?? false;
    _aiTrainingDataSharing = prefs.getBool('ai_training_data_sharing') ?? false;
  }

  /// Update analytics data sharing permission
  Future<void> setAnalyticsDataSharing(bool enabled) async {
    _analyticsDataSharing = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_data_sharing', enabled);
  }

  /// Update crash reporting permission
  Future<void> setCrashReportingSharing(bool enabled) async {
    _crashReportingSharing = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('crash_reporting_sharing', enabled);
  }

  /// Update usage data sharing permission
  Future<void> setUsageDataSharing(bool enabled) async {
    _usageDataSharing = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('usage_data_sharing', enabled);
  }

  /// Update AI training data sharing permission
  Future<void> setAITrainingDataSharing(bool enabled) async {
    _aiTrainingDataSharing = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ai_training_data_sharing', enabled);
  }

  /// Get current data sharing permissions
  Future<Map<String, bool>> getDataSharingPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'analytics': prefs.getBool('permission_analytics') ?? true,
      'ai_training': prefs.getBool('permission_ai_training') ?? false,
      'personalization': prefs.getBool('permission_personalization') ?? true,
      'third_party': prefs.getBool('permission_third_party') ?? false,
    };
  }

  /// Update specific data sharing permission
  Future<void> updateDataSharingPermission(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permission_$key', value);
  }

  /// Export user data as JSON file
  Future<bool> exportUserDataToFile(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Collect all user data
      final userData = {
        'exported_at': DateTime.now().toIso8601String(),
        'vibe_preferences': {
          'current_vibe': prefs.getString('current_vibe') ?? 'Unknown',
          'vibe_history': prefs.getStringList('vibe_history') ?? [],
        },
        'theme_settings': {
          'primary_color': prefs.getInt('primary_vibe_color'),
          'font_size': prefs.getDouble('font_size_multiplier') ?? 1.0,
          'font_style': prefs.getString('font_style') ?? 'Inter',
        },
        'permissions': await getDataSharingPermissions(),
        'usage_statistics': {
          'total_sessions': prefs.getInt('total_sessions') ?? 0,
          'last_active': prefs.getString('last_active_date'),
        },
      };

      // Convert to JSON
      final jsonData = json.encode(userData);
      final fileName =
          'ctrl_app_data_${DateTime.now().millisecondsSinceEpoch}.json';

      // Download file based on platform
      if (kIsWeb) {
        // Web download
        final bytes = utf8.encode(jsonData);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // Mobile download
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(jsonData);

        // Show success message with file path
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data exported to: ${file.path}'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete all user data (GDPR Right to Erasure)
  Future<bool> deleteAllUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all shared preferences
      await prefs.clear();

      // Reset compliance settings to default
      _analyticsDataSharing = false;
      _crashReportingSharing = false;
      _usageDataSharing = false;
      _aiTrainingDataSharing = false;

      // TODO: Delete server-side data if using backend
      // await _deleteServerData();

      return true;
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      return false;
    }
  }

  /// Export user data (GDPR Right to Data Portability)
  Future<Map<String, dynamic>> exportUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    final Map<String, dynamic> userData = {};
    for (final key in allKeys) {
      userData[key] = prefs.get(key);
    }

    return {
      'export_date': DateTime.now().toIso8601String(),
      'user_data': userData,
      'privacy_settings': {
        'analytics_data_sharing': _analyticsDataSharing,
        'crash_reporting_sharing': _crashReportingSharing,
        'usage_data_sharing': _usageDataSharing,
        'ai_training_data_sharing': _aiTrainingDataSharing,
      },
    };
  }

  /// Show data deletion confirmation dialog
  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete All Data',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action will permanently delete:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDataItem(theme, '• All vibe preferences'),
                _buildDataItem(theme, '• Usage analytics history'),
                _buildDataItem(theme, '• AI conversation history'),
                _buildDataItem(theme, '• Theme and font settings'),
                _buildDataItem(theme, '• Notification preferences'),
                const SizedBox(height: 16),
                Text(
                  'This action cannot be undone.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                child: const Text('Delete All Data'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildDataItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
