import '../../domain/entities/workout_session.dart';

sealed class WorkoutState {
  const WorkoutState();
}

final class WorkoutInitial extends WorkoutState {
  const WorkoutInitial();
}

final class WorkoutLoading extends WorkoutState {
  const WorkoutLoading();
}

final class WorkoutInProgress extends WorkoutState {
  final WorkoutSession session;

  const WorkoutInProgress({
    required this.session,
  });
}

final class WorkoutCompleted extends WorkoutState {
  final WorkoutSession session;

  const WorkoutCompleted({
    required this.session,
  });
}

final class WorkoutFailure extends WorkoutState {
  final String message;

  const WorkoutFailure({
    required this.message,
  });
}