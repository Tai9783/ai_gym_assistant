import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/progress/domain/services/exercise_session_summarizer.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/exercise_set.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_exercise.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_session.dart';

void main() {
  late ExerciseSessionSummarizer summarizer;

  setUp(() {
    summarizer = ExerciseSessionSummarizer();
  });

  test(
    'should summarize suggested and actual exercise performance correctly',
    () {
      // Arrange
      final session = WorkoutSession(
        id: 'session_1',
        startedAt: DateTime(2026, 10, 15),
        endedAt: DateTime(2026, 10, 15, 18),
        status: WorkoutSessionStatus.completed,
        exercises: const [],
      );

      const exercise = WorkoutExercise(
        id: 'workout_exercise_1',
        exerciseId: 'bench_press',
        order: 1,
        sets: [
          ExerciseSet(
            id: 'set_1',
            setNumber: 1,
            suggestedWeight: 40,
            suggestedReps: 8,
            actualWeight: 40,
            actualReps: 8,
            status: ExerciseSetStatus.completed,
          ),
          ExerciseSet(
            id: 'set_2',
            setNumber: 2,
            suggestedWeight: 40,
            suggestedReps: 8,
            actualWeight: 40,
            actualReps: 8,
            status: ExerciseSetStatus.completed,
          ),
          ExerciseSet(
            id: 'set_3',
            setNumber: 3,
            suggestedWeight: 40,
            suggestedReps: 8,
            actualWeight: 40,
            actualReps: 7,
            status: ExerciseSetStatus.completed,
          ),
        ],
      );

      // Act
      final summary = summarizer.summarize(
        session: session,
        exercise: exercise,
      );

      // Assert
      expect(summary.sessionId, 'session_1');
      expect(summary.exerciseId, 'bench_press');
      expect(summary.performedAt, DateTime(2026, 10, 15));

      expect(summary.plannedSetCount, 3);
      expect(summary.completedSetCount, 3);
      expect(summary.skippedSetCount, 0);

      expect(summary.suggestedTotalReps, 24);
      expect(summary.actualTotalReps, 23);

      expect(summary.suggestedVolume, 960);
      expect(summary.actualVolume, 920);

      expect(summary.suggestedMaxWeight, 40);
      expect(summary.actualMaxWeight, 40);

      expect(summary.targetHitSetCount, 2);
      expect(summary.underTargetSetCount, 1);
      expect(summary.underTargetSetNumbers, [3]);
    },
  );
}
