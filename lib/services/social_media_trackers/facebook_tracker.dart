import 'package:dio/dio.dart';

/// Facebook tracking service using Facebook Graph API
/// Requires FACEBOOK_ACCESS_TOKEN environment variable
class FacebookTracker {
  static const String baseUrl = 'https://graph.facebook.com/v18.0';
  late final Dio _dio;

  FacebookTracker() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<List<Map<String, dynamic>>> getUserPosts() async {
    final token = String.fromEnvironment('FACEBOOK_ACCESS_TOKEN');
    if (token.isEmpty) {
      throw Exception(
        'FACEBOOK_ACCESS_TOKEN not configured. Please set up Facebook API credentials.',
      );
    }

    try {
      final response = await _dio.get(
        '/me/posts',
        queryParameters: {
          'fields':
              'id,message,created_time,likes.summary(true),comments.summary(true)',
          'access_token': token,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Facebook API error: $e');
    }
  }

  Future<int> getTotalEngagement() async {
    try {
      final posts = await getUserPosts();
      return posts.fold(
        0,
        (sum, post) =>
            sum +
            (post['likes']?['summary']?['total_count'] ?? 0) +
            (post['comments']?['summary']?['total_count'] ?? 0),
      );
    } catch (e) {
      throw Exception('Failed to calculate Facebook engagement: $e');
    }
  }
}
