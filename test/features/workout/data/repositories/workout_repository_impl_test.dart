import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_gym_assistant/core/database/app_database.dart';
import 'package:ai_gym_assistant/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:ai_gym_assistant/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/exercise_set.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_exercise.dart';
import 'package:ai_gym_assistant/features/workout/domain/entities/workout_session.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    final localDataSource = WorkoutLocalDataSource(database);

    repository = WorkoutRepositoryImpl(localDataSource);
  });

  tearDown(() async {
    await database.close();
  });


  test('should save and read workout session correctly', () async {
    final session = WorkoutSession(
      id: 'session_001',
      startedAt: DateTime(2026, 10, 14, 10),
      endedAt: null,
      status: WorkoutSessionStatus.inProgress,
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

    await repository.saveWorkoutSession(session);

    final result = await repository.getWorkoutSessionById(
      'session_001',
    );

    expect(result, isNotNull);

    expect(result!.id, 'session_001');
    expect(result.status, WorkoutSessionStatus.inProgress);

    expect(result.exercises.length, 1);
    expect(result.exercises.first.exerciseId, 'bench_press');

    expect(result.exercises.first.sets.length, 1);

    final set = result.exercises.first.sets.first;

    expect(set.suggestedWeight, 40);
    expect(set.suggestedReps, 10);
    expect(set.actualWeight, isNull);
    expect(set.actualReps, isNull);
    expect(set.status, ExerciseSetStatus.pending);
  });
  test('should update existing workout session without duplicate', () async {
    final originalSession = WorkoutSession(
      id: 'session_001',
      startedAt: DateTime(2026, 10, 14, 10),
      endedAt: null,
      status: WorkoutSessionStatus.inProgress,
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

    await repository.saveWorkoutSession(originalSession);

    final updatedSession = originalSession.copyWith(
      exercises: [
        originalSession.exercises.first.copyWith(
          sets: [
            originalSession.exercises.first.sets.first.copyWith(
              actualWeight: 40,
              actualReps: 8,
              status: ExerciseSetStatus.completed,
            ),
          ],
        ),
      ],
    );

    await repository.saveWorkoutSession(updatedSession);

    final result =
    await repository.getWorkoutSessionById('session_001');

    expect(result, isNotNull);

    final updatedSet = result!.exercises.first.sets.first;

    expect(updatedSet.actualWeight, 40);
    expect(updatedSet.actualReps, 8);
    expect(updatedSet.status, ExerciseSetStatus.completed);

    final sessionCount =
    await database.select(database.workoutSessions).get();

    expect(sessionCount.length, 1);
  });
}