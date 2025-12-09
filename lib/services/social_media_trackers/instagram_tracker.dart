import 'package:dio/dio.dart';

/// Instagram tracking service using Instagram Graph API
/// Requires INSTAGRAM_ACCESS_TOKEN environment variable
class InstagramTracker {
  static const String baseUrl = 'https://graph.instagram.com';
  late final Dio _dio;

  InstagramTracker() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<Map<String, dynamic>> getRecentActivity() async {
    final token = String.fromEnvironment('INSTAGRAM_ACCESS_TOKEN');
    if (token.isEmpty) {
      throw Exception(
        'INSTAGRAM_ACCESS_TOKEN not configured. Please set up Instagram API credentials.',
      );
    }

    try {
      final response = await _dio.get(
        '/me/media',
        queryParameters: {
          'fields': 'id,caption,media_type,timestamp,like_count,comments_count',
          'access_token': token,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Instagram API error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String mediaId) async {
    final token = String.fromEnvironment('INSTAGRAM_ACCESS_TOKEN');

    try {
      final response = await _dio.get(
        '/$mediaId/comments',
        queryParameters: {
          'fields': 'text,username,timestamp',
          'access_token': token,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch Instagram comments: $e');
    }
  }
}
