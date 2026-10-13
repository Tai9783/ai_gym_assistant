import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

class FinishWorkout {
  final WorkoutRepository repository;

  FinishWorkout(this.repository);

  Future<WorkoutSession> call({
    required String sessionId,
  }) async {
    final session = await repository.getWorkoutSessionById(sessionId);

    if (session == null) {
      throw StateError('Workout session not found');
    }

    final completedSession = session.copyWith(
      endedAt: DateTime.now(),
      status: WorkoutSessionStatus.completed,
    );

    await repository.saveWorkoutSession(completedSession);

    return completedSession;
  }
}