import 'package:ai_gym_assistant/core/database/tables/exercise_definitions.dart';
import 'package:ai_gym_assistant/core/database/tables/user_profiles.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

import 'tables/workout_sessions.dart';
import 'tables/workout_exercises.dart';
import 'tables/exercise_sets.dart';

part 'app_database.g.dart';
@lazySingleton
@DriftDatabase(
  tables: [
    WorkoutSessions,
    WorkoutExercises,
    ExerciseSets,
    ExerciseDefinitions,
    UserProfiles,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
    driftDatabase(
      name: 'ai_gym_assistant',
    ),
  );
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(exerciseDefinitions);
      }
      if (from < 3) {
        await m.createTable(userProfiles);
      }
    },
  );
}