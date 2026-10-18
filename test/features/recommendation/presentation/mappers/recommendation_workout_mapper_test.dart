
import 'package:ai_gym_assistant/features/recommendation/presentation/mappers/recommendation_workout_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_recommendation.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/exercise_set.dart';

void main() {
  const recommendation = WorkoutRecommendation(
    exercises: [
      RecommendedExercise(
        exerciseId: 'bench_press',
        sets: [
          RecommendedSet(
            suggestedWeight: 40,
            suggestedReps: 10,
          ),
          RecommendedSet(
            suggestedWeight: 42.5,
            suggestedReps: 8,
          ),
        ],
      ),
      RecommendedExercise(
        exerciseId: 'chest_fly',
        sets: [
          RecommendedSet(
            suggestedWeight: 15,
            suggestedReps: 12,
          ),
        ],
      ),
    ],
  );

  test('Should map recommendation to workout exercises', () {
    final exercises =
    RecommendationWorkoutMapper.toWorkoutExercises(
      recommendation,
    );

    expect(exercises.length, 2);

    expect(exercises[0].exerciseId, 'bench_press');
    expect(exercises[0].order, 1);
    expect(exercises[0].sets.length, 2);

    expect(exercises[1].exerciseId, 'chest_fly');
    expect(exercises[1].order, 2);
    expect(exercises[1].sets.length, 1);

    final firstSet = exercises[0].sets[0];
    final secondSet = exercises[0].sets[1];

    expect(firstSet.setNumber, 1);
    expect(firstSet.suggestedWeight, 40);
    expect(firstSet.suggestedReps, 10);

    expect(secondSet.setNumber, 2);
    expect(secondSet.suggestedWeight, 42.5);
    expect(secondSet.suggestedReps, 8);

    expect(firstSet.actualWeight, isNull);
    expect(firstSet.actualReps, isNull);
    expect(firstSet.status, ExerciseSetStatus.pending);
  });

  test('Should generate unique IDs for exercises and sets', () {
    final exercises =
    RecommendationWorkoutMapper.toWorkoutExercises(
      recommendation,
    );

    final ids = <String>[
      for (final exercise in exercises) ...[
        exercise.id,
        for (final set in exercise.sets) set.id,
      ],
    ];

    expect(ids.every((id) => id.isNotEmpty), isTrue);
    expect(ids.toSet().length, ids.length);
  });
}
