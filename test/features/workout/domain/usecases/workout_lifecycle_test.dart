
import 'package:ai_gym_assistant/features/progress/domain/entities/exercise_session_summary.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/core/database/app_database.dart';

import 'package:ai_gym_assistant/features/progress/domain/entities/recent_exercise_progress.dart';
import 'package:ai_gym_assistant/features/progress/domain/entities/long_term_exercise_progress.dart';
import 'package:ai_gym_assistant/features/progress/domain/repositories/progress_cache_synchronizer.dart';

import 'package:ai_gym_assistant/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:ai_gym_assistant/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/exercise_set.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_exercise.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_session.dart';
import 'package:ai_gym_assistant/features/workout/domain/usecases/finish_workout.dart';
import 'package:ai_gym_assistant/features/workout/domain/usecases/start_workout.dart';
import 'package:ai_gym_assistant/features/workout/domain/usecases/update_exercise_set.dart';

// Fake chỉ phục vụ test Workout Lifecycle.
class _FakeProgressCacheSynchronizer
    implements ProgressCacheSynchronizer {
  @override
  Future<void> syncAfterWorkout(
      WorkoutSession completedSession,
      ) async {
    // Không xử lý Progress Cache trong test này.
  }

  @override
  Future<({
  RecentExerciseProgress? recent,
  LongTermExerciseProgress? longTerm,
  List<ExerciseSessionSummary> recentWindow,
  })> readValidProgress(String exerciseId) async {
    return (recent: null, longTerm: null, recentWindow: <ExerciseSessionSummary>[],);
  }

  @override
  Future<void> recoverPendingProgressUpdates() async {
  }
}

void main() {
  late AppDatabase database;
  late WorkoutRepositoryImpl repository;

  late StartWorkout startWorkout;
  late UpdateExerciseSet updateExerciseSet;
  late FinishWorkout finishWorkout;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    final localDataSource = WorkoutLocalDataSource(database);

    repository = WorkoutRepositoryImpl(localDataSource);

    startWorkout = StartWorkout(repository);
    updateExerciseSet = UpdateExerciseSet(repository);

    // Constructor mới có thêm Cache Synchronizer.
    finishWorkout = FinishWorkout(
      repository,
      _FakeProgressCacheSynchronizer(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('should complete full workout lifecycle', () async {
    // Start workout.
    final startedSession = await startWorkout(
      exercises: [
        WorkoutExercise(
          id: 'workout_exercise_001',
          exerciseId: 'bench_press',
          order: 1,
          sets: [
            ExerciseSet(
              id: 'set_001',
              setNumber: 1,
              suggestedWeight: 40,
              suggestedReps: 10,
              actualWeight: null,
              actualReps: null,
              status: ExerciseSetStatus.pending,
              note: null,
            ),
          ],
        ),
      ],
    );

    expect(
      startedSession.status,
      WorkoutSessionStatus.inProgress,
    );
    expect(startedSession.endedAt, isNull);

    // Update actual workout result.
    final updatedSession = await updateExerciseSet(
      sessionId: startedSession.id,
      workoutExerciseId: 'workout_exercise_001',
      setId: 'set_001',
      actualWeight: 40,
      actualReps: 8,
      status: ExerciseSetStatus.completed,
    );

    final updatedSet = updatedSession.exercises.first.sets.first;

    expect(updatedSet.suggestedWeight, 40);
    expect(updatedSet.suggestedReps, 10);
    expect(updatedSet.actualWeight, 40);
    expect(updatedSet.actualReps, 8);
    expect(
      updatedSet.status,
      ExerciseSetStatus.completed,
    );

    // Finish workout.
    final completedSession = await finishWorkout(
      sessionId: startedSession.id,
    );

    expect(
      completedSession.status,
      WorkoutSessionStatus.completed,
    );
    expect(completedSession.endedAt, isNotNull);

    // Read again from database.
    final savedSession = await repository.getWorkoutSessionById(
      startedSession.id,
    );

    expect(savedSession, isNotNull);

    expect(
      savedSession!.status,
      WorkoutSessionStatus.completed,
    );
    expect(savedSession.endedAt, isNotNull);

    final savedSet = savedSession.exercises.first.sets.first;

    expect(savedSet.suggestedReps, 10);
    expect(savedSet.actualReps, 8);
    expect(
      savedSet.status,
      ExerciseSetStatus.completed,
    );
  });
}
