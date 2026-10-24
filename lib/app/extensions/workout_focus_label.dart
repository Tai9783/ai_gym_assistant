import '../../features/recommendation/domain/entities/workout_request.dart';

extension WorkoutFocusLabel on WorkoutFocus {
  String get label {
    return switch (this) {
      WorkoutFocus.chest => 'Ngực',
      WorkoutFocus.back => 'Lưng',
      WorkoutFocus.legs => 'Chân',
      WorkoutFocus.shoulders => 'Vai',
      WorkoutFocus.arms => 'Tay',
      WorkoutFocus.fullBody => 'Toàn thân',
    };
  }
}