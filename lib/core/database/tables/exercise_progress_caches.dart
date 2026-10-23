
import 'package:drift/drift.dart';

@DataClassName('ExerciseProgressCacheRecord')
class ExerciseProgressCaches extends Table {
  TextColumn get exerciseId => text()();

  TextColumn get recentProgressJson => text().nullable()();
  TextColumn get longTermProgressJson => text().nullable()();

  TextColumn get recentWindowJson => text()();
  TextColumn get longTermStateJson => text()();

  TextColumn get lastProcessedSessionId => text().nullable()();
  IntColumn get calculationVersion =>
      integer().withDefault(const Constant(1))();
  BoolColumn get needsRebuild =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {exerciseId};
}
