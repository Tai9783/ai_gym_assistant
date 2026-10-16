import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/core/database/app_database.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/exercise_session_summarizer.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_progress_analyzer.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_trend_calculator.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/recent_progress_analyzer.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/session_target_classifier.dart';
import 'package:ai_gym_assistant/features/progress/domain/usecases/get_exercise_progress.dart';
import 'package:ai_gym_assistant/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:ai_gym_assistant/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/exercise_set.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_exercise.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_session.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepositoryImpl repository;
  late GetExerciseProgress getExerciseProgress;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    final localDataSource = WorkoutLocalDataSource(database);

    repository = WorkoutRepositoryImpl(localDataSource);

    final classifier = SessionTargetClassifier();

    getExerciseProgress = GetExerciseProgress(
      repository,
      ExerciseSessionSummarizer(),
      RecentProgressAnalyzer(classifier),
      LongTermProgressAnalyzer(classifier, LongTermTrendCalculator()),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'returns null Recent and LongTerm when there is no history for the '
    'exerciseId',
        () async {
      final result = await getExerciseProgress(
        exerciseId: 'bench_press',
      );

      expect(result.recent, isNull);
      expect(result.longTerm, isNull);
    },
  );

  test(
    'ignores sessions that are not completed',
        () async {
      await repository.saveWorkoutSession(
        WorkoutSession(
          id: 'session_in_progress',
          startedAt: DateTime(2026, 10, 1),
          endedAt: null,
          status: WorkoutSessionStatus.inProgress,
          exercises: [
            WorkoutExercise(
              id: 'ex_1',
              exerciseId: 'bench_press',
              order: 1,
              sets: [
                ExerciseSet(
                  id: 'set_1',
                  setNumber: 1,
                  status: ExerciseSetStatus.pending,
                ),
              ],
            ),
          ],
        ),
      );

      final result = await getExerciseProgress(
        exerciseId: 'bench_press',
      );

      expect(result.recent, isNull);
      expect(result.longTerm, isNull);
    },
  );

  test(
    'builds Recent and LongTerm progress from multiple completed sessions, '
    'excluding other exercises in the same workout',
        () async {
      await repository.saveWorkoutSession(
        WorkoutSession(
          id: 'session_1',
          startedAt: DateTime(2026, 10, 1),
          endedAt: DateTime(2026, 10, 1),
          status: WorkoutSessionStatus.completed,
          exercises: [
            WorkoutExercise(
              id: 'session_1_bench',
              exerciseId: 'bench_press',
              order: 1,
              sets: [
                ExerciseSet(
                  id: 'session_1_bench_set1',
                  setNumber: 1,
                  suggestedWeight: 40,
                  suggestedReps: 8,
                  actualWeight: 40,
                  actualReps: 8,
                  status: ExerciseSetStatus.completed,
                ),
              ],
            ),
          ],
        ),
      );

      await repository.saveWorkoutSession(
        WorkoutSession(
          id: 'session_2',
          startedAt: DateTime(2026, 10, 3),
          endedAt: DateTime(2026, 10, 3),
          status: WorkoutSessionStatus.completed,
          exercises: [
            WorkoutExercise(
              id: 'session_2_bench',
              exerciseId: 'bench_press',
              order: 1,
              sets: [
                ExerciseSet(
                  id: 'session_2_bench_set1',
                  setNumber: 1,
                  suggestedWeight: 40,
                  suggestedReps: 8,
                  actualWeight: 42.5,
                  actualReps: 8,
                  status: ExerciseSetStatus.completed,
                ),
              ],
            ),
            WorkoutExercise(
              id: 'session_2_squat',
              exerciseId: 'squat',
              order: 2,
              sets: [
                ExerciseSet(
                  id: 'session_2_squat_set1',
                  setNumber: 1,
                  suggestedWeight: 60,
                  suggestedReps: 5,
                  actualWeight: 60,
                  actualReps: 5,
                  status: ExerciseSetStatus.completed,
                ),
              ],
            ),
          ],
        ),
      );

      final benchResult = await getExerciseProgress(
        exerciseId: 'bench_press',
      );

      expect(benchResult.recent, isNotNull);
      expect(benchResult.longTerm, isNotNull);

      expect(benchResult.recent!.exerciseId, 'bench_press');
      expect(benchResult.recent!.sessionCount, 2);

      expect(benchResult.longTerm!.exerciseId, 'bench_press');
      expect(benchResult.longTerm!.sessionCount, 2);
      expect(benchResult.longTerm!.bestActualMaxWeight, 42.5);
      expect(
        benchResult.longTerm!.firstPerformedAt,
        DateTime(2026, 10, 1),
      );
      expect(
        benchResult.longTerm!.lastPerformedAt,
        DateTime(2026, 10, 3),
      );

      final squatResult = await getExerciseProgress(
        exerciseId: 'squat',
      );

      expect(squatResult.recent!.sessionCount, 1);
      expect(squatResult.longTerm!.sessionCount, 1);
    },
  );
}
