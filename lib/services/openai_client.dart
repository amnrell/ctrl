import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:dio/dio.dart';

/// OpenAI API client providing methods for chat, vision, audio, and image generation
class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  // =============================================================================
  // CHAT COMPLETION METHODS
  // =============================================================================

  /// Standard chat completion - blocks until response is complete
  /// Supports reasoning_effort and verbosity parameters for GPT-5 models
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-5-mini',
    Map<String, dynamic>? options,
    String? reasoningEffort,
    String? verbosity,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'model': model,
        'messages': messages
            .map((m) => {
                  'role': m.role,
                  'content': m.content,
                })
            .toList(),
      };

      // Handle options based on model type
      if (options != null) {
        final filteredOptions = Map<String, dynamic>.from(options);

        // For GPT-5 models, remove unsupported parameters
        if (model.startsWith('gpt-5') ||
            model.startsWith('o3') ||
            model.startsWith('o4')) {
          filteredOptions.removeWhere((key, value) => [
                'temperature',
                'top_p',
                'presence_penalty',
                'frequency_penalty',
                'logit_bias'
              ].contains(key));

          // Convert max_tokens to max_completion_tokens for GPT-5
          if (filteredOptions.containsKey('max_tokens')) {
            filteredOptions['max_completion_tokens'] =
                filteredOptions.remove('max_tokens');
          }
        }

        requestData.addAll(filteredOptions);
      }

      // Add GPT-5 specific parameters
      if (model.startsWith('gpt-5') ||
          model.startsWith('o3') ||
          model.startsWith('o4')) {
        if (reasoningEffort != null)
          requestData['reasoning_effort'] = reasoningEffort;
        if (verbosity != null) requestData['verbosity'] = verbosity;
      }

      final response = await dio.post('/chat/completions', data: requestData);

      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error',
      );
    }
  }

  /// Streams a text response with support for new model parameters
  Stream<StreamCompletion> streamChatCompletion({
    required List<Message> messages,
    String model = 'gpt-5-mini',
    Map<String, dynamic>? options,
    String? reasoningEffort,
    String? verbosity,
  }) async* {
    try {
      final requestData = <String, dynamic>{
        'model': model,
        'messages': messages
            .map((m) => {
                  'role': m.role,
                  'content': m.content,
                })
            .toList(),
        'stream': true,
        if (options != null) ...options,
      };

      // Add GPT-5 specific parameters
      if (model.startsWith('gpt-5') ||
          model.startsWith('o3') ||
          model.startsWith('o4')) {
        if (reasoningEffort != null)
          requestData['reasoning_effort'] = reasoningEffort;
        if (verbosity != null) requestData['verbosity'] = verbosity;
      }

      final response = await dio.post(
        '/chat/completions',
        data: requestData,
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
          final content = delta['content'] ?? '';
          final finishReason = json['choices'][0]['finish_reason'];
          final systemFingerprint = json['system_fingerprint'];

          yield StreamCompletion(
            content: content,
            finishReason: finishReason,
            systemFingerprint: systemFingerprint,
          );

          if (finishReason != null) break;
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error',
      );
    }
  }

  /// User-friendly wrapper for streaming that yields content strings
  Stream<String> streamContentOnly({
    required List<Message> messages,
    String model = 'gpt-5-mini',
    Map<String, dynamic>? options,
    String? reasoningEffort,
    String? verbosity,
  }) async* {
    await for (final chunk in streamChatCompletion(
      messages: messages,
      model: model,
      options: options,
      reasoningEffort: reasoningEffort,
      verbosity: verbosity,
    )) {
      if (chunk.content.isNotEmpty) {
        yield chunk.content;
      }
    }
  }

  // =============================================================================
  // AUDIO PROCESSING METHODS
  // =============================================================================

  /// Convert speech audio to text using Whisper
  Future<Transcription> transcribeAudio({
    required File audioFile,
    String model = 'whisper-1',
    String? prompt,
    String responseFormat = 'json',
    String? language,
    double? temperature,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
        'model': model,
        if (prompt != null) 'prompt': prompt,
        'response_format': responseFormat,
        if (language != null) 'language': language,
        if (temperature != null) 'temperature': temperature,
      });

      final response = await dio.post('/audio/transcriptions', data: formData);

      if (responseFormat == 'json') {
        return Transcription(text: response.data['text']);
      } else {
        return Transcription(text: response.data.toString());
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Unknown error',
      );
    }
  }
}

// =============================================================================
// SUPPORT CLASSES
// =============================================================================

class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class StreamCompletion {
  final String content;
  final String? finishReason;
  final String? systemFingerprint;

  StreamCompletion({
    required this.content,
    this.finishReason,
    this.systemFingerprint,
  });
}

class Transcription {
  final String text;

  Transcription({required this.text});
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAIException: $statusCode - $message';
}
