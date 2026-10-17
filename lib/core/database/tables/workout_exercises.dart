import 'package:drift/drift.dart';

import 'workout_sessions.dart';

@DataClassName('WorkoutExerciseRecord')
class WorkoutExercises extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text().references(WorkoutSessions, #id)();

  TextColumn get exerciseId => text()();

  IntColumn get order => integer()();

  @override
  Set<Column> get primaryKey => {id};
}