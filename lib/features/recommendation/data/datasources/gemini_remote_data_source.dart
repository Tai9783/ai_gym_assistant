import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../domain/entities/ai_context.dart';
import '../prompts/recommendation_prompt.dart';
import '../schemas/workout_recommendation_schema.dart';
import '../serializers/ai_context_serializer.dart';

@lazySingleton
class GeminiRemoteDataSource {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static final Uri _url = Uri.parse(
    'https://generativelanguage.googleapis.com/'
    'v1beta/models/gemini-3.8-flash:generateContent',
  );

  Future<Map<String, dynamic>> generate(AiContext context) async {
    if (_apiKey.isEmpty) {
      throw StateError('Gemini API key is missing');
    }

    final contextJson = AiContextSerializer.toJson(context);
    final contextText = jsonEncode(contextJson);

    final requestBody = {
      'systemInstruction': {
        'parts': [
          {'text': RecommendationPrompt.systemInstruction},
        ],
      },
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': contextText},
          ],
        },
      ],
      'generationConfig': {
        'responseFormat': {
          'text': {
            'mimeType': 'APPLICATION_JSON',
            'schema': WorkoutRecommendationSchema.value,
          },
        },
      },
    };

    final response = await http
        .post(
          _url,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': _apiKey,
          },
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: 90));

    if (response.statusCode != 200) {
      String message = 'Unknown API error';

      try {
        final errorData = jsonDecode(response.body);

        if (errorData is Map<String, dynamic>) {
          final error = errorData['error'];

          if (error is Map<String, dynamic>) {
            message = error['message']?.toString() ?? message;
          }
        }
      } catch (_) {
      }

      throw Exception(
        'Gemini HTTP ${response.statusCode}: $message',
      );
    }

    // Decode Gemini HTTP response.
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException('Invalid Gemini response');
    }

    final candidates = responseData['candidates'];

    if (candidates is! List || candidates.isEmpty) {
      throw const FormatException('Gemini returned no candidates');
    }

    final candidate = candidates.first;

    if (candidate is! Map<String, dynamic>) {
      throw const FormatException('Invalid Gemini candidate');
    }

    final finishReason = candidate['finishReason'];

    if (finishReason != null && finishReason != 'STOP') {
      throw FormatException('Gemini stopped: $finishReason');
    }

    final content = candidate['content'];

    if (content is! Map<String, dynamic>) {
      throw const FormatException('Gemini returned no content');
    }

    final parts = content['parts'];

    if (parts is! List || parts.isEmpty) {
      throw const FormatException('Gemini returned no parts');
    }

    // Extract generated text.
    final textBuffer = StringBuffer();

    for (final part in parts) {
      if (part is Map<String, dynamic> &&
          part['thought'] != true &&
          part['text'] is String) {
        textBuffer.write(part['text'] as String);
      }
    }

    final responseText = textBuffer.toString();

    if (responseText.isEmpty) {
      throw const FormatException('Gemini returned empty text');
    }

    // Convert generated JSON text to Map.
    final recommendationJson = jsonDecode(responseText);

    if (recommendationJson is! Map<String, dynamic>) {
      throw const FormatException('Invalid recommendation JSON');
    }

    return recommendationJson;
  }
}
