
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/exercise_catalog/domain/entities/exercise_definition.dart';
import 'package:ai_gym_assistant/features/recommendation/data/datasources/gemini_remote_data_source.dart';
import 'package:ai_gym_assistant/features/recommendation/data/repositories/recommendation_repository_impl.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/ai_context.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_request.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/services/recommendation_validator.dart';

class FakeGeminiRemoteDataSource extends GeminiRemoteDataSource {
  final Map<String, dynamic> responseJson;

  FakeGeminiRemoteDataSource(this.responseJson);

  @override
  Future<Map<String, dynamic>> generate(
      AiContext context,
      ) async {
    return responseJson;
  }
}

void main() {
  AiContext makeContext() {
    return AiContext(
      request: WorkoutRequest(
        focus: WorkoutFocus.chest,
        exerciseIds: ['bench_press'],
        note: null,
      ),
      profile: null,
      exercises: [
        AiExerciseContext(
          exercise: ExerciseDefinition(
            id: 'bench_press',
            name: 'Bench Press',
            muscleGroup: MuscleGroup.chest,
          ),
          recent: null,
          longTerm: null,
        ),
      ],
    );
  }

  test('Should generate a valid recommendation', () async {
    final dataSource = FakeGeminiRemoteDataSource({
      'exercises': [
        {
          'exerciseId': 'bench_press',
          'sets': [
            {
              'suggestedWeight': 40,
              'suggestedReps': 10,
            },
          ],
        },
      ],
    });

    final repository = RecommendationRepositoryImpl(
      dataSource,
      RecommendationValidator(),
    );

    final result = await repository.generate(makeContext());

    expect(result.exercises.length, 1);
    expect(result.exercises.first.exerciseId, 'bench_press');
    expect(result.exercises.first.sets.length, 1);
    expect(
      result.exercises.first.sets.first.suggestedWeight,
      40.0,
    );
    expect(
      result.exercises.first.sets.first.suggestedReps,
      10,
    );
  });

  test('Should reject an invalid recommendation', () async {
    final dataSource = FakeGeminiRemoteDataSource({
      'exercises': [
        {
          'exerciseId': 'squat',
          'sets': [
            {
              'suggestedWeight': 50,
              'suggestedReps': 10,
            },
          ],
        },
      ],
    });

    final repository = RecommendationRepositoryImpl(
      dataSource,
      RecommendationValidator(),
    );

    await expectLater(
      repository.generate(makeContext()),
      throwsFormatException,
    );
  });
}
