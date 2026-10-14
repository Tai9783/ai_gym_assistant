import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/workout_sessions.dart';
import 'tables/workout_exercises.dart';
import 'tables/exercise_sets.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    WorkoutSessions,
    WorkoutExercises,
    ExerciseSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
    driftDatabase(
      name: 'ai_gym_assistant',
    ),
  );

  @override
  int get schemaVersion => 1;
}