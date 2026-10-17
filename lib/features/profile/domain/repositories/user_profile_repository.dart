
import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> getProfile();

  Future<void> saveProfile(UserProfile profile);
}
