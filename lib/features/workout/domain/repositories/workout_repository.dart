import '../entities/workout_session.dart';

abstract class WorkoutRepository {
  Future<void> saveWorkoutSession(WorkoutSession session);

  Future<WorkoutSession?> getWorkoutSessionById(String id);

  Future<List<WorkoutSession>> getCompletedWorkoutSessionsByExerciseId(
    String exerciseId,
  );
}
