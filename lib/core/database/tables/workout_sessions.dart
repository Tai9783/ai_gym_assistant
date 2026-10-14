import 'package:drift/drift.dart';

@DataClassName('WorkoutSessionRecord')
class WorkoutSessions extends Table {
  TextColumn get id => text()();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime().nullable()();

  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}