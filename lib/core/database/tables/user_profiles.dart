import 'package:drift/drift.dart';

class UserProfiles extends Table {
  IntColumn get id => integer()();

  TextColumn get goal => text()();

  RealColumn get weightKg => real().nullable()();

  RealColumn get heightCm => real().nullable()();

  IntColumn get age => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
