
import 'package:injectable/injectable.dart';

import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

@lazySingleton
class GetUserProfile {
  final UserProfileRepository _repository;

  GetUserProfile(this._repository);

  Future<UserProfile?> call() {
    return _repository.getProfile();
  }
}
