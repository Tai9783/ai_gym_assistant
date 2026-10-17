import 'package:injectable/injectable.dart';

import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

@lazySingleton
class SaveUserProfile {
  final UserProfileRepository _repository;

  SaveUserProfile(this._repository);

  Future<void> call(UserProfile profile) {
    return _repository.saveProfile(profile);
  }
}
