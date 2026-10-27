import 'package:ai_gym_assistant/features/progress/domain/services/session_target_classifier.dart';
import 'package:injectable/injectable.dart';

import '../entities/exercise_session_summary.dart';
import '../entities/recent_exercise_progress.dart';
import 'long_term_trend_calculator.dart';

@injectable
class RecentProgressAnalyzer {
  static const int recentSessionLimit = 5;
  final SessionTargetClassifier _classifier;
  final LongTermTrendCalculator _trendCalculator;

  RecentProgressAnalyzer(this._classifier,this._trendCalculator,);

  RecentExerciseProgress? analyze({
    required String exerciseId,
    required List<ExerciseSessionSummary> summaries,
  }) {
    final exerciseSummaries = summaries
        .where((summary) => summary.exerciseId == exerciseId)
        .toList();

    if (exerciseSummaries.isEmpty) {
      return null;
    }

    exerciseSummaries.sort((a, b) => a.performedAt.compareTo(b.performedAt));

    final recentSummaries = exerciseSummaries.length <= recentSessionLimit
        ? exerciseSummaries
        : exerciseSummaries.sublist(
            exerciseSummaries.length - recentSessionLimit,
          );

    final sessionCount = recentSummaries.length;

    final windowStartAt = recentSummaries.first.performedAt;
    final windowEndAt = recentSummaries.last.performedAt;

    final latestSummary = recentSummaries.last;

    final sessionResults = recentSummaries
        .map((summary) => _classifier.classify(summary))
        .toList();

    final latestSessionHitTarget =
        sessionResults.last == SessionTargetResult.hit;

    final hitSessionCount = sessionResults
        .where((result) => result == SessionTargetResult.hit)
        .length;

    final missedTargetSessionCount = sessionResults
        .where((result) => result == SessionTargetResult.miss)
        .length;

    int currentMissStreak = 0;

    for (final result in sessionResults.reversed) {
      if (result != SessionTargetResult.miss) {
        break;
      }

      currentMissStreak++;
    }
    final totalEvaluatedSetCount = recentSummaries.fold<int>(
      0,
      (total, summary) =>
          total + summary.targetHitSetCount + summary.underTargetSetCount,
    );

    final totalHitSetCount = recentSummaries.fold<int>(
      0,
      (total, summary) => total + summary.targetHitSetCount,
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

    // Chỉ lấy những buổi có ít nhất một set hoàn thành.
    final trendSummaries = recentSummaries
        .where((summary) => summary.completedSetCount > 0)
        .toList();

    final actualWeights = trendSummaries
        .map((summary) => summary.actualMaxWeight)
        .whereType<double>()
        .toList();

    final actualVolumes = trendSummaries
        .map((summary) => summary.actualVolume)
        .toList();

    final weightTrend = _trendCalculator.calculate(
      chronologicalValues: actualWeights,
      thresholdRatio: 0.05,
    );

    final volumeTrend = _trendCalculator.calculate(
      chronologicalValues: actualVolumes,
      thresholdRatio: 0.10,
    );
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
}
