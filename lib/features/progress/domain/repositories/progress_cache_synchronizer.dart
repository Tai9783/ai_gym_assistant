
import '../../../workout/domain/entities/workout_session.dart';
import '../entities/exercise_session_summary.dart';
import '../entities/long_term_exercise_progress.dart';
import '../entities/recent_exercise_progress.dart';

abstract class ProgressCacheSynchronizer {
  Future<void> syncAfterWorkout(
      WorkoutSession completedSession,
      );

  // Đọc cache an toàn, tự rebuild nếu không đồng bộ.
  Future<({
  RecentExerciseProgress? recent,
  LongTermExerciseProgress? longTerm,
  List<ExerciseSessionSummary> recentWindow,
  })> readValidProgress(String exerciseId);

  Future<void> recoverPendingProgressUpdates();
}
