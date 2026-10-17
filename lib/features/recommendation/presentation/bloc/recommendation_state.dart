import '../../domain/entities/workout_request.dart';
import '../../domain/entities/workout_recommendation.dart';

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

  const RecommendationFailure(this.message);
}
