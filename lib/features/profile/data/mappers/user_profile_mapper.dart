
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/user_profile.dart' as domain;

class UserProfileMapper {
  static domain.UserProfile toDomain(db.UserProfile row) {
    return domain.UserProfile(
      goal: row.goal,
      weightKg: row.weightKg,
      heightCm: row.heightCm,
      age: row.age,
    );
  }

  static db.UserProfilesCompanion toCompanion(
      domain.UserProfile profile,
      ) {
    return db.UserProfilesCompanion.insert(
      id: const Value(1),
      goal: profile.goal,
      weightKg: Value(profile.weightKg),
      heightCm: Value(profile.heightCm),
      age: Value(profile.age),
    );
  }
}
