
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/recommendation/data/mappers/workout_recommendation_mapper.dart';

void main() {
  test('Should parse workout recommendation', () {
    final json = {
      'exercises': [
        {
          'exerciseId': 'bench_press',
          'sets': [
            {
              'suggestedWeight': 40,
              'suggestedReps': 10,
            },
            {
              'suggestedWeight': 42.5,
              'suggestedReps': 8,
            },
          ],
        },
      ],
    };

    final result = WorkoutRecommendationMapper.fromJson(json);

    expect(result.exercises.length, 1);

    final exercise = result.exercises.first;

    expect(exercise.exerciseId, 'bench_press');
    expect(exercise.sets.length, 2);

    expect(exercise.sets[0].suggestedWeight, 40.0);
    expect(exercise.sets[0].suggestedReps, 10);

    expect(exercise.sets[1].suggestedWeight, 42.5);
    expect(exercise.sets[1].suggestedReps, 8);
  });

  test('Should throw when exercises is missing', () {
    final json = <String, dynamic>{};

    expect(
          () => WorkoutRecommendationMapper.fromJson(json),
      throwsFormatException,
    );
  });

  test('Should throw when set data is invalid', () {
    final json = {
      'exercises': [
        {
          'exerciseId': 'bench_press',
          'sets': [
            {
              'suggestedWeight': 'heavy',
              'suggestedReps': 10,
            },
          ],
        },
      ],
    };

    expect(
          () => WorkoutRecommendationMapper.fromJson(json),
      throwsFormatException,
    );
  });
}
