import '../entities/exercise_session_summary.dart';
import '../entities/recent_exercise_progress.dart';

class RecentProgressAnalyzer {
  static const int recentSessionLimit = 5;

  RecentExerciseProgress? analyze({
    required String exerciseId,
    required List<ExerciseSessionSummary> summaries,
  }) {
    final exerciseSummaries = summaries
        .where(
          (summary) => summary.exerciseId == exerciseId,
    )
        .toList();

    if (exerciseSummaries.isEmpty) {
      return null;
    }

    exerciseSummaries.sort(
          (a, b) => a.performedAt.compareTo(b.performedAt),
    );

    final recentSummaries =
    exerciseSummaries.length <= recentSessionLimit
        ? exerciseSummaries
        : exerciseSummaries.sublist(
      exerciseSummaries.length - recentSessionLimit,
    );

    final sessionCount = recentSummaries.length;

    final windowStartAt = recentSummaries.first.performedAt;
    final windowEndAt = recentSummaries.last.performedAt;

    final latestSummary = recentSummaries.last;

    final latestSessionHitTarget = _isSessionHitTarget(latestSummary);
    final hitSessionCount = recentSummaries.where(_isSessionHitTarget).length;
    final missedTargetSessionCount = sessionCount - hitSessionCount;
    int currentMissStreak = 0;

    for (final summary in recentSummaries.reversed) {
      if (_isSessionHitTarget(summary)) {
        break;
      }

      currentMissStreak++;
    }
    final totalEvaluatedSetCount = recentSummaries.fold<int>(
      0,
          (total, summary) =>
      total +
          summary.targetHitSetCount +
          summary.underTargetSetCount,
    );

    final totalHitSetCount = recentSummaries.fold<int>(
      0,
          (total, summary) =>
      total + summary.targetHitSetCount,
    );

    final targetHitSetRate = totalEvaluatedSetCount == 0
        ? 0.0
        : totalHitSetCount / totalEvaluatedSetCount;

    final underTargetSetFrequency = <int, int>{};

    for (final summary in recentSummaries) {
      for (final setNumber in summary.underTargetSetNumbers) {
        underTargetSetFrequency[setNumber] =
            (underTargetSetFrequency[setNumber] ?? 0) + 1;
      }
    }
    final latestSuggestedMaxWeight = latestSummary.suggestedMaxWeight;

    final latestActualMaxWeight = latestSummary.actualMaxWeight;

    final latestSuggestedTotalReps = latestSummary.suggestedTotalReps;

    final latestActualTotalReps = latestSummary.actualTotalReps;

    final actualWeights = recentSummaries
        .map((summary) => summary.actualMaxWeight)
        .whereType<double>()
        .toList();

    final weightTrend = _calculateTrend(actualWeights);

    final actualVolumes = recentSummaries
        .map((summary) => summary.actualVolume)
        .toList();

    final volumeTrend = _calculateTrend(actualVolumes);
    return RecentExerciseProgress(
      exerciseId: exerciseId,

      sessionCount: sessionCount,
      windowStartAt: windowStartAt,
      windowEndAt: windowEndAt,

      latestSessionHitTarget: latestSessionHitTarget,
      hitSessionCount: hitSessionCount,
      missedTargetSessionCount: missedTargetSessionCount,
      currentMissStreak: currentMissStreak,

      targetHitSetRate: targetHitSetRate,
      underTargetSetFrequency: underTargetSetFrequency,

      latestSuggestedMaxWeight: latestSuggestedMaxWeight,
      latestActualMaxWeight: latestActualMaxWeight,

      latestSuggestedTotalReps: latestSuggestedTotalReps,
      latestActualTotalReps: latestActualTotalReps,

      weightTrend: weightTrend,
      volumeTrend: volumeTrend,
    );
  }

  bool _isSessionHitTarget(ExerciseSessionSummary summary) {
    return summary.plannedSetCount > 0 &&
        summary.completedSetCount == summary.plannedSetCount &&
        summary.underTargetSetCount == 0;
  }
  ProgressTrend _calculateTrend(List<double> values) {
    if (values.length < 2) {
      return ProgressTrend.insufficientData;
    }

    final firstValue = values.first;
    final lastValue = values.last;

    if (lastValue > firstValue) {
      return ProgressTrend.increasing;
    }

    if (lastValue < firstValue) {
      return ProgressTrend.decreasing;
    }

    return ProgressTrend.stable;
  }
}