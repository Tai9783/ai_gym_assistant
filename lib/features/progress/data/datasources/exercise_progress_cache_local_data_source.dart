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
}
