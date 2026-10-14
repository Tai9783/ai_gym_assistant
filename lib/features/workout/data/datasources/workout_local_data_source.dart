import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class WorkoutLocalDataSource {
  final AppDatabase database;

  WorkoutLocalDataSource(this.database);

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
        await database
            .into(database.exerciseSets)
            .insertOnConflictUpdate(set);
      }
    });
  }
  Future<WorkoutSessionRecord?> getWorkoutSessionById(String id) async {
    return (database.select(database.workoutSessions)
      ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<WorkoutExerciseRecord>> getWorkoutExercisesBySessionId(
      String sessionId,
      ) async {
    return (database.select(database.workoutExercises)
      ..where((table) => table.sessionId.equals(sessionId))
      ..orderBy([
            (table) => OrderingTerm.asc(table.order),
      ]))
        .get();
  }

  Future<List<ExerciseSetRecord>> getExerciseSetsByWorkoutExerciseId(
      String workoutExerciseId,
      ) async {
    return (database.select(database.exerciseSets)
      ..where(
            (table) =>
            table.workoutExerciseId.equals(workoutExerciseId),
      )
      ..orderBy([
            (table) => OrderingTerm.asc(table.setNumber),
      ]))
        .get();
  }
}