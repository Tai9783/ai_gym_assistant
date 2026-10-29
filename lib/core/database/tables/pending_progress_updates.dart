import 'package:drift/drift.dart';

class PendingProgressUpdates extends Table {
  TextColumn get workoutId => text()();

  @override
  Set<Column> get primaryKey => {workoutId};
}