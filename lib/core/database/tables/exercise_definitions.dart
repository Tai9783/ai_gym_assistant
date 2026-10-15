import 'package:drift/drift.dart';

@DataClassName('ExerciseDefinitionRecord')
class ExerciseDefinitions extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get muscleGroup => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}