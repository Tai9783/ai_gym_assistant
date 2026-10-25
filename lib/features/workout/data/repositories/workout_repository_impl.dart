import 'package:injectable/injectable.dart';

import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_data_source.dart';
import '../mappers/exercise_set_mapper.dart';
import '../mappers/workout_exercise_mapper.dart';
import '../mappers/workout_session_mapper.dart';

@LazySingleton(as: WorkoutRepository)
class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource localDataSource;

  WorkoutRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    final sessionCompanion = WorkoutSessionMapper.toCompanion(session);

    final exerciseCompanions = session.exercises
        .map(
          (exercise) => WorkoutExerciseMapper.toCompanion(
            exercise,
            sessionId: session.id,
          ),
        )
        .toList();

    final setCompanions = session.exercises
        .expand(
          (exercise) => exercise.sets.map(
            (set) => ExerciseSetMapper.toCompanion(
              set,
              workoutExerciseId: exercise.id,
            ),
          ),
        )
        .toList();

    await localDataSource.upsertWorkoutSession(
      session: sessionCompanion,
      exercises: exerciseCompanions,
      sets: setCompanions,
    );
  }

  @override
  Future<WorkoutSession?> getWorkoutSessionById(String id) async {
    final sessionRecord = await localDataSource.getWorkoutSessionById(id);

    if (sessionRecord == null) {
      return null;
    }

    final exerciseRecords = await localDataSource
        .getWorkoutExercisesBySessionId(id);

    final exercises = <WorkoutExercise>[];

    for (final exerciseRecord in exerciseRecords) {
      final setRecords = await localDataSource
          .getExerciseSetsByWorkoutExerciseId(exerciseRecord.id);

      final exercise = WorkoutExerciseMapper.toDomain(
        exerciseRecord,
        setRecords,
      );

      exercises.add(exercise);
    }

    return WorkoutSessionMapper.toDomain(sessionRecord, exercises);
  }

  @override
  Future<List<WorkoutSession>> getCompletedWorkoutSessionsByExerciseId(
    String exerciseId,
  ) async {
    final sessionIds = await localDataSource
        .getCompletedWorkoutSessionIdsByExerciseId(exerciseId);

    final sessions = <WorkoutSession>[];

    for (final sessionId in sessionIds) {
      final session = await getWorkoutSessionById(sessionId);

      if (session != null) {
        sessions.add(session);
      }
    }

    return sessions;
  }

  @override
  Future<int> countCompletedWorkoutExercises(String exerciseId) {
    return localDataSource.countCompletedWorkoutExercises(exerciseId);
  }

  @override
  Future<List<WorkoutSession>> getCompletedWorkoutSessions() async {
    final sessionIds = await localDataSource.getCompletedWorkoutSessionIds();

    final sessions = <WorkoutSession>[];

    for (final sessionId in sessionIds) {
      final session = await getWorkoutSessionById(sessionId);

      if (session != null) {
        sessions.add(session);
      }
    }

    return sessions;
  }

  @override
  Future<List<WorkoutSession>> getInProgressWorkoutSessions() async {
    final sessionIds = await localDataSource.getInProgressWorkoutSessionIds();

    final sessions = <WorkoutSession>[];

    for (final sessionId in sessionIds) {
      final session = await getWorkoutSessionById(sessionId);

      if (session != null) {
        sessions.add(session);
      }
    }

    return sessions;
  }
  @override
  Stream<List<WorkoutSession>> watchInProgressWorkoutSessions() {
    return localDataSource
        .watchInProgressWorkoutSessionIds()
        .asyncMap((sessionIds) async {
      final sessions = <WorkoutSession>[];

      for (final sessionId in sessionIds) {
        final session = await getWorkoutSessionById(sessionId);

        if (session != null) {
          sessions.add(session);
        }
      }

      return sessions;
    });
  }
  @override
  Future<WorkoutSession> cancelWorkoutSession({
    required String sessionId,
  }) async {
    return localDataSource.runInTransaction(() async {
      final session = await getWorkoutSessionById(sessionId);

      if (session == null) {
        throw StateError('Không tìm thấy buổi tập.');
      }

      if (session.status == WorkoutSessionStatus.cancelled) {
        return session;
      }

      if (session.status != WorkoutSessionStatus.inProgress) {
        throw StateError('Chỉ có thể hủy buổi tập đang dở.');
      }

      final cancelledSession = session.copyWith(
        status: WorkoutSessionStatus.cancelled,
        endedAt: DateTime.now(),
      );

      await saveWorkoutSession(cancelledSession);

      return cancelledSession;
    });
  }

  @override
  Future<WorkoutSession> completeWorkoutSession({
    required String sessionId,
  }) async {
    return localDataSource.runInTransaction(() async {
      final session = await getWorkoutSessionById(sessionId);

      if (session == null) {
        throw StateError('Workout session not found');
      }

      if (session.status == WorkoutSessionStatus.completed) {
        return session;
      }

      final completedSession = session.copyWith(
        endedAt: DateTime.now(),
        status: WorkoutSessionStatus.completed,
      );

      await saveWorkoutSession(completedSession);

      return completedSession;
    });
  }
}
