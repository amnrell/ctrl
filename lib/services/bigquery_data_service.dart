import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// BigQuery integration service for data collection and analytics
class BigQueryDataService {
  static final BigQueryDataService _instance = BigQueryDataService._internal();
  factory BigQueryDataService() => _instance;
  BigQueryDataService._internal();

  late Dio _dio;
  String? _accessToken;

  // Environment configuration
  static const String projectId = String.fromEnvironment('BIGQUERY_PROJECT_ID');
  static const String datasetId = String.fromEnvironment('BIGQUERY_DATASET_ID');
  static const String apiKey = String.fromEnvironment('BIGQUERY_API_KEY');

  /// Initialize BigQuery service
  Future<void> initialize() async {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://bigquery.googleapis.com/bigquery/v2',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // For Flutter applications, use API key authentication instead of service account
    if (apiKey.isNotEmpty) {
      _dio.options.queryParameters['key'] = apiKey;
    }
  }

  /// Send usage data to BigQuery
  Future<bool> sendUsageData(Map<String, dynamic> usageData) async {
    if (projectId.isEmpty || datasetId.isEmpty) {
      print(
          'BigQuery not configured - skipping data send (set BIGQUERY_PROJECT_ID and BIGQUERY_DATASET_ID)');
      return false;
    }

    try {
      // Add timestamp if not present
      if (!usageData.containsKey('timestamp')) {
        usageData['timestamp'] = DateTime.now().toIso8601String();
      }

      // Prepare BigQuery insert request
      final tableName = 'social_media_usage';
      final rows = [
        {
          'json': usageData,
        }
      ];

      final response = await _dio.post(
        '/projects/$projectId/datasets/$datasetId/tables/$tableName/insertAll',
        data: {
          'rows': rows,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending data to BigQuery: $e');
      return false;
    }
  }

  /// Batch send multiple data points
  Future<bool> sendBatchData(List<Map<String, dynamic>> dataPoints) async {
    if (projectId.isEmpty || datasetId.isEmpty) {
      print('BigQuery not configured - skipping batch send');
      return false;
    }

    try {
      final tableName = 'social_media_usage';
      final rows = dataPoints
          .map((data) => {
                'json': {
                  ...data,
                  'timestamp':
                      data['timestamp'] ?? DateTime.now().toIso8601String(),
                }
              })
          .toList();

      final response = await _dio.post(
        '/projects/$projectId/datasets/$datasetId/tables/$tableName/insertAll',
        data: {
          'rows': rows,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending batch data to BigQuery: $e');
      return false;
    }
  }

  /// Query data from BigQuery
  Future<List<Map<String, dynamic>>?> queryData(String query) async {
    if (projectId.isEmpty || datasetId.isEmpty) {
      print('BigQuery not configured - cannot query data');
      return null;
    }

    try {
      final response = await _dio.post(
        '/projects/$projectId/queries',
        data: {
          'query': query,
          'useLegacySql': false,
        },
      );

      if (response.statusCode == 200) {
        final rows = response.data['rows'] as List?;
        if (rows != null) {
          return rows.map((row) => row['f'] as Map<String, dynamic>).toList();
        }
      }
      return null;
    } catch (e) {
      print('Error querying BigQuery: $e');
      return null;
    }
  }

  /// Get aggregated analytics
  Future<Map<String, dynamic>?> getAggregatedAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (projectId.isEmpty || datasetId.isEmpty) {
      return _getMockAnalytics(startDate, endDate);
    }

    try {
      final query = '''
        SELECT
          platform,
          COUNT(*) as total_interactions,
          SUM(scroll_depth) as total_scroll,
          AVG(session_duration) as avg_session_duration,
          COUNT(DISTINCT user_id) as unique_users
        FROM `$projectId.$datasetId.social_media_usage`
        WHERE timestamp BETWEEN @start_date AND @end_date
        GROUP BY platform
        ORDER BY total_interactions DESC
      ''';

      final result = await queryData(query);
      if (result != null && result.isNotEmpty) {
        return {
          'data': result,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        };
      }
      return null;
    } catch (e) {
      print('Error getting aggregated analytics: $e');
      return _getMockAnalytics(startDate, endDate);
    }
  }

  /// Mock analytics for development/testing
  Map<String, dynamic> _getMockAnalytics(DateTime start, DateTime end) {
    return {
      'data': [
        {
          'platform': 'Instagram',
          'total_interactions': 245,
          'total_scroll': 1250,
          'avg_session_duration': 18.5,
          'unique_users': 1,
        },
        {
          'platform': 'TikTok',
          'total_interactions': 189,
          'total_scroll': 980,
          'avg_session_duration': 22.3,
          'unique_users': 1,
        },
        {
          'platform': 'X',
          'total_interactions': 167,
          'total_scroll': 750,
          'avg_session_duration': 12.8,
          'unique_users': 1,
        },
      ],
      'start_date': start.toIso8601String(),
      'end_date': end.toIso8601String(),
      'is_mock': true,
    };
  }

  /// Store data point locally for later batch upload
  Future<void> storeLocalDataPoint(Map<String, dynamic> dataPoint) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getStringList('pending_bigquery_data') ?? [];
      existingData.add(jsonEncode(dataPoint));
      await prefs.setStringList('pending_bigquery_data', existingData);
    } catch (e) {
      print('Error storing local data point: $e');
    }
  }

  /// Upload pending local data
  Future<bool> uploadPendingData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingData = prefs.getStringList('pending_bigquery_data') ?? [];

      if (pendingData.isEmpty) return true;

      final dataPoints = pendingData
          .map((jsonStr) => jsonDecode(jsonStr) as Map<String, dynamic>)
          .toList();

      final success = await sendBatchData(dataPoints);

      if (success) {
        await prefs.remove('pending_bigquery_data');
      }

      return success;
    } catch (e) {
      print('Error uploading pending data: $e');
      return false;
    }
  }

  /// Check if BigQuery is properly configured
  bool isConfigured() {
    return projectId.isNotEmpty && datasetId.isNotEmpty;
  }
}
