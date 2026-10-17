import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart' as db;

@lazySingleton
class UserProfileLocalDataSource {
  final db.AppDatabase _database;

  UserProfileLocalDataSource(this._database);

  Future<db.UserProfile?> getProfile() async {
    return (_database.select(_database.userProfiles)
      ..where((table) => table.id.equals(1)))
        .getSingleOrNull();
  }

  Future<void> saveProfile(
      db.UserProfilesCompanion profile,
      ) async {
    await _database
        .into(_database.userProfiles)
        .insertOnConflictUpdate(profile);
  }
}
