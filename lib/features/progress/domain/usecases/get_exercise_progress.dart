// import 'package:injectable/injectable.dart';
//
// import '../../../workout/domain/entities/workout_session.dart';
// import '../../../workout/domain/repositories/workout_repository.dart';
// import '../entities/exercise_session_summary.dart';
// import '../entities/long_term_exercise_progress.dart';
// import '../entities/recent_exercise_progress.dart';
// import '../services/exercise_session_summarizer.dart';
// import '../services/long_term_progress_analyzer.dart';
// import '../services/recent_progress_analyzer.dart';
//
// typedef ExerciseProgressResult = ({
//   RecentExerciseProgress? recent,
//   LongTermExerciseProgress? longTerm,
// });
//
// @LazySingleton()
// class GetExerciseProgress {
//   final WorkoutRepository _workoutRepository;
//   final ExerciseSessionSummarizer _summarizer;
//   final RecentProgressAnalyzer _recentAnalyzer;
//   final LongTermProgressAnalyzer _longTermAnalyzer;
//
//   GetExerciseProgress(
//     this._workoutRepository,
//     this._summarizer,
//     this._recentAnalyzer,
//     this._longTermAnalyzer,
//   );
//
//   Future<ExerciseProgressResult> call({required String exerciseId}) async {
//     final completedSessions = await _workoutRepository
//         .getCompletedWorkoutSessionsByExerciseId(exerciseId);
//
//     final summaries = _buildSummaries(
//       exerciseId: exerciseId,
//       sessions: completedSessions,
//     );
//
//     final recent = _recentAnalyzer.analyze(
//       exerciseId: exerciseId,
//       summaries: summaries,
//     );
//
//     final longTerm = _longTermAnalyzer.analyze(
//       exerciseId: exerciseId,
//       summaries: summaries,
//     );
//
//     return (recent: recent, longTerm: longTerm);
//   }
//
//   List<ExerciseSessionSummary> _buildSummaries({
//     required String exerciseId,
//     required List<WorkoutSession> sessions,
//   }) {
//     final summaries = <ExerciseSessionSummary>[];
//
//     for (final session in sessions) {
//       final matchingExercises = session.exercises.where(
//         (exercise) => exercise.exerciseId == exerciseId,
//       );
//
//       for (final exercise in matchingExercises) {
//         summaries.add(
//           _summarizer.summarize(session: session, exercise: exercise),
//         );
//       }
//     }
//
//     return summaries;
//   }
// }

import 'package:injectable/injectable.dart';

import '../entities/long_term_exercise_progress.dart';
import '../entities/recent_exercise_progress.dart';
import '../repositories/progress_cache_synchronizer.dart';

typedef ExerciseProgressResult = ({
RecentExerciseProgress? recent,
LongTermExerciseProgress? longTerm,
});

@LazySingleton()
class GetExerciseProgress {
  final ProgressCacheSynchronizer _cacheSynchronizer;

  GetExerciseProgress(this._cacheSynchronizer);

  Future<ExerciseProgressResult> call({
    required String exerciseId,
  }) {
    return _cacheSynchronizer.readValidProgress(exerciseId);
  }
}
