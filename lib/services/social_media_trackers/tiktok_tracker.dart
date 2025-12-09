import 'package:dio/dio.dart';

/// TikTok tracking service using TikTok for Developers API
/// Requires TIKTOK_CLIENT_KEY and OAuth access token
class TikTokTracker {
  static const String baseUrl = 'https://open.tiktokapis.com';
  late final Dio _dio;

  TikTokTracker() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<List<Map<String, dynamic>>> getUserVideos() async {
    final token = await _getAccessToken();
    if (token.isEmpty) {
      throw Exception(
        'TikTok OAuth token not available. Please authenticate user.',
      );
    }

    try {
      final response = await _dio.get(
        '/v2/video/list/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {
          'fields': 'id,create_time,share_count,comment_count,like_count'
        },
      );
      return List<Map<String, dynamic>>.from(
        response.data['data']['videos'],
      );
    } catch (e) {
      throw Exception('TikTok API error: $e');
    }
  }

  Future<String> _getAccessToken() async {
    // OAuth token retrieval logic
    // Should be stored securely after OAuth flow
    return String.fromEnvironment('TIKTOK_ACCESS_TOKEN');
  }
}
