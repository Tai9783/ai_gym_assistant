import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';

@lazySingleton
class ExerciseLocalDataSource {
  final AppDatabase database;

  ExerciseLocalDataSource(this.database);

  Future<void> seedDefaultExercisesIfEmpty() async {
    final existingExercises = await database
        .select(database.exerciseDefinitions)
        .get();

    if (existingExercises.isNotEmpty) {
      return;
    }

    await database.batch((batch) {
      batch.insertAll(database.exerciseDefinitions, [
        ExerciseDefinitionsCompanion.insert(
          id: 'bench_press',
          name: 'Bench Press',
          muscleGroup: 'chest',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'incline_dumbbell_press',
          name: 'Incline Dumbbell Press',
          muscleGroup: 'chest',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'chest_fly',
          name: 'Chest Fly',
          muscleGroup: 'chest',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'lat_pulldown',
          name: 'Lat Pulldown',
          muscleGroup: 'back',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'seated_cable_row',
          name: 'Seated Cable Row',
          muscleGroup: 'back',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'squat',
          name: 'Squat',
          muscleGroup: 'legs',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'leg_press',
          name: 'Leg Press',
          muscleGroup: 'legs',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'shoulder_press',
          name: 'Shoulder Press',
          muscleGroup: 'shoulders',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'bicep_curl',
          name: 'Bicep Curl',
          muscleGroup: 'arms',
        ),
        ExerciseDefinitionsCompanion.insert(
          id: 'triceps_pushdown',
          name: 'Triceps Pushdown',
          muscleGroup: 'arms',
        ),
      ]);
    });
  }

  Future<List<ExerciseDefinitionRecord>> getAllExercises() async {
    return (database.select(
      database.exerciseDefinitions,
    )..orderBy([(table) => OrderingTerm.asc(table.name)])).get();
  }
}
