import 'package:dio/dio.dart';

/// Reddit tracking service using Reddit API
/// Requires REDDIT_CLIENT_ID and REDDIT_CLIENT_SECRET
class RedditTracker {
  static const String baseUrl = 'https://oauth.reddit.com';
  late final Dio _dio;

  RedditTracker() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<List<Map<String, dynamic>>> getUserPosts(String username) async {
    final token = await _getAccessToken();
    if (token.isEmpty) {
      throw Exception(
          'Reddit OAuth token not available. Please authenticate user.');
    }

    try {
      final response = await _dio.get(
        '/user/$username/submitted',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'limit': 100},
      );
      return List<Map<String, dynamic>>.from(
        response.data['data']['children'].map((item) => item['data']),
      );
    } catch (e) {
      throw Exception('Reddit API error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserComments(String username) async {
    final token = await _getAccessToken();

    try {
      final response = await _dio.get(
        '/user/$username/comments',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'limit': 100},
      );
      return List<Map<String, dynamic>>.from(
        response.data['data']['children'].map((item) => item['data']),
      );
    } catch (e) {
      throw Exception('Failed to fetch Reddit comments: $e');
    }
  }

  Future<String> _getAccessToken() async {
    // OAuth token retrieval logic
    return String.fromEnvironment('REDDIT_ACCESS_TOKEN');
  }
}
