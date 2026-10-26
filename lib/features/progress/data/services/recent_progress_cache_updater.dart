
import 'package:injectable/injectable.dart';

import '../../domain/entities/exercise_session_summary.dart';
import '../../domain/entities/recent_exercise_progress.dart';
import '../../domain/services/recent_progress_analyzer.dart';

@lazySingleton
class RecentProgressCacheUpdater {
  final RecentProgressAnalyzer _analyzer;

  const RecentProgressCacheUpdater(this._analyzer);

  ({
  List<ExerciseSessionSummary> window,
  RecentExerciseProgress progress,
  }) update({
    required String exerciseId,
    required List<ExerciseSessionSummary> previousWindow,
    required ExerciseSessionSummary newSummary,
  }) {
    if (newSummary.exerciseId != exerciseId ||
        previousWindow.any(
              (summary) => summary.exerciseId != exerciseId,
        )) {
      throw ArgumentError('Exercise ID mismatch');
    }

    //check Session trùng trong Recent Window.
    if (previousWindow.any(
          (summary) => summary.sessionId == newSummary.sessionId,
    )) {
      throw StateError('Session already exists in recent window');
    }

    //Ghép Window cũ với Summary mới.
    final allSummaries = [
      ...previousWindow,
      newSummary,
    ]..sort(
          (a, b) => a.performedAt.compareTo(b.performedAt),
    );

    //Giữ tối đa 5 Session gần nhất.
    final limit = RecentProgressAnalyzer.recentSessionLimit;

    final updatedWindow = allSummaries.length <= limit
        ? allSummaries
        : allSummaries.sublist(allSummaries.length - limit);

    final updatedProgress = _analyzer.analyze(
      exerciseId: exerciseId,
      summaries: updatedWindow,
    );

    if (updatedProgress == null) {
      throw StateError('Cannot calculate recent progress');
    }

    //Trả về cả Window(LList<ExerciseSessionSummary>) và Progress mới.
    return (
    window: updatedWindow,
    progress: updatedProgress,
    );
  }
}
