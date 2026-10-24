import '../../features/recommendation/domain/entities/workout_request.dart';

extension WorkoutFocusImage on WorkoutFocus {
  String get imagePath {
    return switch (this) {
      WorkoutFocus.chest =>
      'assets/images/muscle_groups/chest.svg',
      WorkoutFocus.back =>
      'assets/images/muscle_groups/back.svg',
      WorkoutFocus.legs =>
      'assets/images/muscle_groups/legs.svg',
      WorkoutFocus.shoulders =>
      'assets/images/muscle_groups/shoulders.svg',
      WorkoutFocus.arms =>
      'assets/images/muscle_groups/arms.svg',
      WorkoutFocus.fullBody =>
      'assets/images/muscle_groups/full_body.svg',
    };
  }
}