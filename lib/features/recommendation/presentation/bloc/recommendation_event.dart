import '../../domain/entities/workout_request.dart';

sealed class RecommendationEvent {
  const RecommendationEvent();
}

final class RecommendationGenerateRequested extends RecommendationEvent {
  final WorkoutRequest request;

  const RecommendationGenerateRequested(this.request);
}
final class RecommendationRestorePreviousRequested
    extends RecommendationEvent {
  const RecommendationRestorePreviousRequested();
}