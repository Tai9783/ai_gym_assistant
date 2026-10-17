import '../entities/ai_context.dart';
import '../entities/workout_recommendation.dart';

abstract class RecommendationRepository {
  Future<WorkoutRecommendation> generate(AiContext context);
}
