import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';

@lazySingleton
class ExerciseProgressCacheLocalDataSource {
  final AppDatabase _database;

  ExerciseProgressCacheLocalDataSource(this._database);
  Future<T> runInTransaction<T>(
      Future<T> Function() action,
      ) {
    return _database.transaction(action);
  }

  Future<ExerciseProgressCacheRecord?> getByExerciseId(
      String exerciseId,
      ) async {
    return (_database.select(_database.exerciseProgressCaches)
      ..where((table) => table.exerciseId.equals(exerciseId)))
        .getSingleOrNull();
  }

  Future<void> upsert(
      ExerciseProgressCachesCompanion cache,
      ) async {
    await _database
        .into(_database.exerciseProgressCaches)
        .insertOnConflictUpdate(cache);
  }
  Future<void> deletePendingProgressUpdate(
      String workoutId,
      ) async {
    await (_database.delete(_database.pendingProgressUpdates)
      ..where((table) => table.workoutId.equals(workoutId)))
        .go();
  }

  Future<List<String>> getPendingWorkoutIds() async {
    final pending = _database.pendingProgressUpdates;
    final sessions = _database.workoutSessions;

    final query = _database.select(pending).join([
      leftOuterJoin(
        sessions,
        sessions.id.equalsExp(pending.workoutId),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(sessions.startedAt),
        OrderingTerm.asc(pending.workoutId),
      ]);

    final rows = await query.get();

    return rows
        .map((row) => row.readTable(pending).workoutId)
        .toList();
  }
  Future<bool> hasPendingProgressUpdate(
      String workoutId,
      ) async {
    final record = await (_database
        .select(_database.pendingProgressUpdates)
      ..where(
            (table) => table.workoutId.equals(workoutId),
      ))
        .getSingleOrNull();

    return record != null;
  }
}
