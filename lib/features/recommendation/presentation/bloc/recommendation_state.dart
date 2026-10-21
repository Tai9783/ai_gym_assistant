import '../../domain/entities/workout_request.dart';
import '../../domain/entities/workout_recommendation.dart';
import '../../domain/exceptions/recommendation_rate_limited_exception.dart';

sealed class RecommendationState {
  const RecommendationState();
}

final class RecommendationInitial extends RecommendationState {
  const RecommendationInitial();
}

final class RecommendationLoading extends RecommendationState {
  const RecommendationLoading();
}

final class RecommendationLoaded extends RecommendationState {
  final WorkoutRequest request;
  final WorkoutRecommendation recommendation;

  const RecommendationLoaded({
    required this.request,
    required this.recommendation,
  });
}


final class RecommendationFailure extends RecommendationState {
  final String message;

  final RecommendationRateLimitReason? rateLimitReason;
  final DateTime? resetAt;
  final int? retryAfterSeconds;
  // Giữ lại đề xuất thành công trước đó, nếu có.
  final RecommendationLoaded? previousLoaded;

  const RecommendationFailure(
      this.message, {
        this.rateLimitReason,
        this.resetAt,
        this.retryAfterSeconds,
        this.previousLoaded,
      });
}
