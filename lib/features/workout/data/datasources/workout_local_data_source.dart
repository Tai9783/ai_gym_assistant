import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/workout_session.dart';

@LazySingleton()
class WorkoutLocalDataSource {
  final AppDatabase database;

  WorkoutLocalDataSource(this.database);

  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return database.transaction(action);
  }

  Future<void> upsertWorkoutSession({
    required WorkoutSessionsCompanion session,
    required List<WorkoutExercisesCompanion> exercises,
    required List<ExerciseSetsCompanion> sets,
  }) async {
    await database.transaction(() async {
      await database
          .into(database.workoutSessions)
          .insertOnConflictUpdate(session);

      for (final exercise in exercises) {
        await database
            .into(database.workoutExercises)
            .insertOnConflictUpdate(exercise);
      }

      for (final set in sets) {
        await database.into(database.exerciseSets).insertOnConflictUpdate(set);
      }
    });
  }

  Future<WorkoutSessionRecord?> getWorkoutSessionById(String id) async {
    return (database.select(
      database.workoutSessions,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<List<WorkoutExerciseRecord>> getWorkoutExercisesBySessionId(
    String sessionId,
  ) async {
    return (database.select(database.workoutExercises)
          ..where((table) => table.sessionId.equals(sessionId))
          ..orderBy([(table) => OrderingTerm.asc(table.order)]))
        .get();
  }

  Future<List<ExerciseSetRecord>> getExerciseSetsByWorkoutExerciseId(
    String workoutExerciseId,
  ) async {
    return (database.select(database.exerciseSets)
          ..where((table) => table.workoutExerciseId.equals(workoutExerciseId))
          ..orderBy([(table) => OrderingTerm.asc(table.setNumber)]))
        .get();
  }

  Future<List<String>> getCompletedWorkoutSessionIdsByExerciseId(
    String exerciseId,
  ) async {
    final query = database.selectOnly(database.workoutSessions)
      ..addColumns([database.workoutSessions.id])
      ..join([
        innerJoin(
          database.workoutExercises,
          database.workoutExercises.sessionId.equalsExp(
            database.workoutSessions.id,
          ),
        ),
      ])
      ..where(
        database.workoutSessions.status.equals(
          WorkoutSessionStatus.completed.name,
        ),
      )
      ..where(database.workoutExercises.exerciseId.equals(exerciseId))
      ..groupBy([database.workoutSessions.id]);

    final rows = await query.get();

    return rows.map((row) => row.read(database.workoutSessions.id)!).toList();
  }

  Future<List<String>> getCompletedWorkoutSessionIds() async {
    final records =
        await (database.select(database.workoutSessions)
              ..where(
                (table) =>
                    table.status.equals(WorkoutSessionStatus.completed.name),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]))
            .get();

    return records.map((record) => record.id).toList();
  }

  Future<List<String>> getInProgressWorkoutSessionIds() async {
    final records =
        await (database.select(database.workoutSessions)
              ..where(
                (table) =>
                    table.status.equals(WorkoutSessionStatus.inProgress.name),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]))
            .get();

    return records.map((record) => record.id).toList();
  }
  Stream<List<String>> watchInProgressWorkoutSessionIds() {
    final query = database.select(database.workoutSessions)
      ..where(
            (table) => table.status.equals(
          WorkoutSessionStatus.inProgress.name,
        ),
      )
      ..orderBy([
            (table) => OrderingTerm.desc(table.startedAt),
      ]);

    return query.watch().map(
          (records) => records.map((record) => record.id).toList(),
    );
  }

  //đếm số lần tập đã hoàn thành của bài tập để check cache đã cập nhật đủ hay thiếu.
  Future<int> countCompletedWorkoutExercises(String exerciseId) async {
    final countExpression = database.workoutExercises.id.count();

    final query = database.selectOnly(database.workoutExercises)
      ..addColumns([countExpression])
      ..join([
        innerJoin(
          database.workoutSessions,
          database.workoutSessions.id.equalsExp(
            database.workoutExercises.sessionId,
          ),
        ),
      ])
      ..where(database.workoutExercises.exerciseId.equals(exerciseId))
      ..where(
        database.workoutSessions.status.equals(
          WorkoutSessionStatus.completed.name,
        ),
      );

    final row = await query.getSingle();

    return row.read(countExpression) ?? 0;
  }
}
