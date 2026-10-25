import '../../domain/entities/workout_session.dart';

sealed class ActiveWorkoutState {
  const ActiveWorkoutState();
}

final class ActiveWorkoutInitial extends ActiveWorkoutState {
  const ActiveWorkoutInitial();
}

final class ActiveWorkoutLoading extends ActiveWorkoutState {
  const ActiveWorkoutLoading();
}

final class ActiveWorkoutLoaded extends ActiveWorkoutState {
  final List<WorkoutSession> sessions;

  const ActiveWorkoutLoaded(this.sessions);
}

final class ActiveWorkoutFailure extends ActiveWorkoutState {
  final String message;

  const ActiveWorkoutFailure(this.message);
}
