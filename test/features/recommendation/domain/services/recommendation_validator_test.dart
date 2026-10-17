
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/exercise_catalog/domain/entities/exercise_definition.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/ai_context.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_request.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/entities/workout_recommendation.dart';
import 'package:ai_gym_assistant/features/recommendation/domain/services/recommendation_validator.dart';

void main() {
  final validator = RecommendationValidator();

  AiContext makeContext({
    List<String> selectedIds = const [],
  }) {
    return AiContext(
      request: WorkoutRequest(
        focus: WorkoutFocus.chest,
        exerciseIds: selectedIds,
        note: null,
      ),
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
        AiExerciseContext(
          exercise: ExerciseDefinition(
            id: 'chest_fly',
            name: 'Chest Fly',
            muscleGroup: MuscleGroup.chest,
          ),
          recent: null,
          longTerm: null,
        ),
      ],
    );
  }

  RecommendedExercise makeExercise(
      String id, {
        List<RecommendedSet>? sets,
      }) {
    return RecommendedExercise(
      exerciseId: id,
      sets: sets ??
          [
            const RecommendedSet(
              suggestedWeight: 40,
              suggestedReps: 10,
            ),
          ],
    );
  }

  test('Should allow selected exercises', () {
    final context = makeContext(
      selectedIds: ['bench_press', 'chest_fly'],
    );

    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise('bench_press'),
        makeExercise('chest_fly'),
      ],
    );

    expect(
          () => validator.validate(
        context: context,
        recommendation: recommendation,
      ),
      returnsNormally,
    );
  });

  test('Should allow a subset for focus only', () {
    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise('bench_press'),
      ],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      returnsNormally,
    );
  });

  test('Should reject exercises outside catalog', () {
    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise('squat'),
      ],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      throwsFormatException,
    );
  });

  test('Should reject missing selected exercises', () {
    final context = makeContext(
      selectedIds: ['bench_press', 'chest_fly'],
    );

    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise('bench_press'),
      ],
    );

    expect(
          () => validator.validate(
        context: context,
        recommendation: recommendation,
      ),
      throwsFormatException,
    );
  });

  test('Should reject duplicate exercises', () {
    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise('bench_press'),
        makeExercise('bench_press'),
      ],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      throwsFormatException,
    );
  });

  test('Should reject empty recommendation', () {
    const recommendation = WorkoutRecommendation(
      exercises: [],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      throwsFormatException,
    );
  });

  test('Should reject empty sets', () {
    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise('bench_press', sets: []),
      ],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      throwsFormatException,
    );
  });

  test('Should reject negative weight', () {
    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise(
          'bench_press',
          sets: [
            const RecommendedSet(
              suggestedWeight: -10,
              suggestedReps: 10,
            ),
          ],
        ),
      ],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      throwsFormatException,
    );
  });

  test('Should reject invalid reps', () {
    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise(
          'bench_press',
          sets: [
            const RecommendedSet(
              suggestedWeight: 40,
              suggestedReps: 0,
            ),
          ],
        ),
      ],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      throwsFormatException,
    );
  });

  test('Should allow zero weight', () {
    final recommendation = WorkoutRecommendation(
      exercises: [
        makeExercise(
          'bench_press',
          sets: [
            const RecommendedSet(
              suggestedWeight: 0,
              suggestedReps: 12,
            ),
          ],
        ),
      ],
    );

    expect(
          () => validator.validate(
        context: makeContext(),
        recommendation: recommendation,
      ),
      returnsNormally,
    );
  });
}
