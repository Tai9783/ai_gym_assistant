import 'package:injectable/injectable.dart';

import '../../domain/entities/ai_context.dart';
import '../../domain/entities/workout_recommendation.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../../domain/services/recommendation_validator.dart';
import '../datasources/gemini_remote_data_source.dart';
import '../mappers/workout_recommendation_mapper.dart';

@LazySingleton(as: RecommendationRepository)
class RecommendationRepositoryImpl implements RecommendationRepository {
  final GeminiRemoteDataSource _remoteDataSource;
  final RecommendationValidator _validator;

  RecommendationRepositoryImpl(this._remoteDataSource, this._validator);

  @override
  Future<WorkoutRecommendation> generate(AiContext context) async {
    final json = await _remoteDataSource.generate(context);

    final recommendation = WorkoutRecommendationMapper.fromJson(json);

    _validator.validate(context: context, recommendation: recommendation);

    return recommendation;
  }
}
