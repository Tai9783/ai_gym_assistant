import '../entities/workout_session.dart';

abstract class WorkoutRepository {
  Future<void> saveWorkoutSession(WorkoutSession session);

  Future<WorkoutSession?> getWorkoutSessionById(String id);

  Future<List<WorkoutSession>> getCompletedWorkoutSessionsByExerciseId(
    String exerciseId,
  );
  Future<List<WorkoutSession>> getCompletedWorkoutSessions();

  Future<WorkoutSession> completeWorkoutSession({
    required String sessionId,
  });
  //đếm số lần tập đã hoàn thành của bài tập để check cache đã cập nhật đủ hay thiếu.
  Future<int> countCompletedWorkoutExercises(String exerciseId);
}
