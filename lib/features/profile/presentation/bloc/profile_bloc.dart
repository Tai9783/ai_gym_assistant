import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/save_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final SaveUserProfile _saveUserProfile;

  ProfileBloc(this._getUserProfile, this._saveUserProfile)
    : super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileSaveRequested>(_onSaveRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      final profile = await _getUserProfile();

      emit(ProfileLoaded(profile));
    } catch (_) {
      emit(const ProfileFailure('Could not load profile'));
    }
  }

  Future<void> _onSaveRequested(
    ProfileSaveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileSaving());

    try {
      await _saveUserProfile(event.profile);

      emit(ProfileSaved(event.profile));
    } catch (_) {
      emit(const ProfileFailure('Could not save profile'));
    }
  }
}
