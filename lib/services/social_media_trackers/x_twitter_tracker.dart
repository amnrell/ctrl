import 'package:dio/dio.dart';

/// X (Twitter) tracking service using X API v2
/// Requires X_BEARER_TOKEN environment variable
class XTwitterTracker {
  static const String baseUrl = 'https://api.x.com';
  late final Dio _dio;

  XTwitterTracker() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<List<Map<String, dynamic>>> getUserTweets(String userId) async {
    final token = String.fromEnvironment('X_BEARER_TOKEN');
    if (token.isEmpty) {
      throw Exception(
          'X_BEARER_TOKEN not configured. Please set up X API credentials.');
    }

    try {
      final response = await _dio.get(
        '/2/users/$userId/tweets',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'tweet.fields': 'created_at,public_metrics,text',
          'max_results': 100,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('X API error: $e');
    }
  }

  Future<List<String>> getRetweets(String tweetId) async {
    final token = String.fromEnvironment('X_BEARER_TOKEN');

    try {
      final response = await _dio.get(
        '/2/tweets/$tweetId/retweeted_by',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return List<String>.from(
        response.data['data'].map((u) => u['username']),
      );
    } catch (e) {
      throw Exception('Failed to fetch retweets: $e');
    }
  }
}
