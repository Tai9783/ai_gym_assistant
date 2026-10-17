
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_local_data_source.dart';
import '../mappers/user_profile_mapper.dart';

@LazySingleton(as: UserProfileRepository)
class UserProfileRepositoryImpl
    implements UserProfileRepository {
  final UserProfileLocalDataSource _localDataSource;

  UserProfileRepositoryImpl(this._localDataSource);

  @override
  Future<UserProfile?> getProfile() async {
    final row = await _localDataSource.getProfile();

    if (row == null) {
      return null;
    }

    return UserProfileMapper.toDomain(row);
  }

  @override
  Future<void> saveProfile(UserProfile profile) {
    final companion = UserProfileMapper.toCompanion(profile);

    return _localDataSource.saveProfile(companion);
  }
}
