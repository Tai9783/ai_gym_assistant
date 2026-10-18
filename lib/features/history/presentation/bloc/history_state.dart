import '../../../workout/domain/entities/workout_session.dart';

sealed class HistoryState {
  const HistoryState();
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

final class HistoryLoaded extends HistoryState {
  final List<WorkoutSession> sessions;
  final Map<String, String> exerciseNames;

  const HistoryLoaded({required this.sessions, required this.exerciseNames});
}

final class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

final class HistoryFailure extends HistoryState {
  final String message;

  const HistoryFailure(this.message);
}
