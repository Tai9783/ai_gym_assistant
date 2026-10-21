import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../../core/auth/anonymous_auth_service.dart';
import '../../domain/entities/ai_context.dart';
import '../../domain/exceptions/recommendation_rate_limited_exception.dart';
import '../serializers/ai_context_serializer.dart';

@lazySingleton
class GeminiRemoteDataSource {
  final AnonymousAuthService _authService;
  final FirebaseAuth _firebaseAuth;

  GeminiRemoteDataSource(
      this._authService,
      this._firebaseAuth,
      );

  static final Uri _url = Uri.parse(
    'https://ai-gym-assistant-api.votai130504.workers.dev/recommendation',
  );

  Future<Map<String, dynamic>> generate(AiContext context) async {
      await _authService.ensureSignedIn();

      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw StateError('Firebase user is missing');
      }

      final idToken = await user.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw StateError('Firebase ID Token is missing');
      }

      final contextJson = AiContextSerializer.toJson(context);

      final response = await http.post(
        _url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'aiContext': contextJson,
        }),
      ).timeout(const Duration(seconds: 90));


      if (response.statusCode == 429) {
        Map<String, dynamic>? errorBody;

        try {
          final decoded = jsonDecode(
            utf8.decode(response.bodyBytes),
          );

          if (decoded is Map<String, dynamic>) {
            errorBody = decoded;
          }
        } on FormatException {
          // Phản hồi lỗi không phải JSON hợp lệ.
        }

        final errorCode = errorBody?['error'];

        if (errorCode == 'daily_limit_reached') {
          final rawResetAt = errorBody?['resetAt'];

          final resetAt = rawResetAt is String
              ? DateTime.tryParse(rawResetAt)
              : null;

          throw RecommendationRateLimitedException(
            reason: RecommendationRateLimitReason.dailyLimit,
            resetAt: resetAt,
          );
        }

        if (errorCode == 'cooldown_active') {
          final rawSeconds = errorBody?['retryAfterSeconds'];

          final seconds = rawSeconds is int && rawSeconds > 0
              ? rawSeconds
              : null;

          throw RecommendationRateLimitedException(
            reason: RecommendationRateLimitReason.cooldown,
            retryAfterSeconds: seconds,
          );
        }

        // Fallback nếu Worker trả HTTP 429 không rõ lý do.
        throw const RecommendationRateLimitedException();
      }


      if (response.statusCode != 200) {
        throw Exception(
          'AI backend error: HTTP ${response.statusCode}',
        );
      }

      final responseData =
      jsonDecode(utf8.decode(response.bodyBytes));

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid recommendation response',
        );
      }

      return responseData;
    }
}
