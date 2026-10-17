import '../../domain/entities/user_profile.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileSaveRequested extends ProfileEvent {
  final UserProfile profile;

  const ProfileSaveRequested(this.profile);
}
