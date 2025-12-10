import 'package:dio/dio.dart';

/// Singleton service for OpenAI API integration
/// Manages API key configuration and provides Dio client for API calls
class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  /// Factory constructor to return the singleton instance
  factory OpenAIService() {
    return _instance;
  }

  /// Private constructor for singleton pattern
  OpenAIService._internal() {
    _initializeService();
  }

  void _initializeService() {
    // Load API key from environment variables
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY must be provided via --dart-define');
    }

    // Configure Dio with base URL and headers
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Dio get dio => _dio;
}
