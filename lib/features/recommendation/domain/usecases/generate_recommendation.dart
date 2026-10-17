import 'package:injectable/injectable.dart';

import '../entities/workout_request.dart';
import '../entities/workout_recommendation.dart';
import '../repositories/recommendation_repository.dart';
import 'prepare_ai_context.dart';

@lazySingleton
class GenerateRecommendation {
  final PrepareAiContext _prepareAiContext;
  final RecommendationRepository _repository;

  GenerateRecommendation(this._prepareAiContext, this._repository);

  Future<WorkoutRecommendation> call({required WorkoutRequest request}) async {
    final context = await _prepareAiContext(request: request);

    return _repository.generate(context);
  }
}
