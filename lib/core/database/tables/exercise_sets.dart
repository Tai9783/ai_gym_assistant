import 'package:drift/drift.dart';

import 'workout_exercises.dart';

@DataClassName('ExerciseSetRecord')
class ExerciseSets extends Table {
  TextColumn get id => text()();

  TextColumn get workoutExerciseId => text().references(WorkoutExercises, #id)();

  IntColumn get setNumber => integer()();

  RealColumn get suggestedWeight => real().nullable()();

  IntColumn get suggestedReps => integer().nullable()();

  RealColumn get actualWeight => real().nullable()();

  IntColumn get actualReps => integer().nullable()();

  TextColumn get status => text()();

  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}