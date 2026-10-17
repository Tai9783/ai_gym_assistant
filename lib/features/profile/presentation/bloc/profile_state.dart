
import '../../domain/entities/user_profile.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final UserProfile? profile;

  const ProfileLoaded(this.profile);
}

final class ProfileSaving extends ProfileState {
  const ProfileSaving();
}

final class ProfileSaved extends ProfileState {
  final UserProfile profile;

  const ProfileSaved(this.profile);
}

final class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}
