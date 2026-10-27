import 'package:injectable/injectable.dart';

import '../entities/exercise_session_summary.dart';
import '../entities/long_term_exercise_progress.dart';

import 'session_target_classifier.dart';
import 'progress_trend_calculator.dart';

@injectable
class LongTermProgressAnalyzer {
  final SessionTargetClassifier _classifier;
  final ProgressTrendCalculator _trendCalculator;

  LongTermProgressAnalyzer(this._classifier, this._trendCalculator);

  LongTermExerciseProgress? analyze({
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

    final sessionCount = exerciseSummaries.length;

    final firstPerformedAt = exerciseSummaries.first.performedAt;
    final lastPerformedAt = exerciseSummaries.last.performedAt;

    final sessionResults = exerciseSummaries
        .map((summary) => _classifier.classify(summary))
        .toList();

    final hitSessionCount = sessionResults
        .where((result) => result == SessionTargetResult.hit)
        .length;

    final missedTargetSessionCount = sessionResults
        .where((result) => result == SessionTargetResult.miss)
        .length;

    int totalHitSetCount = 0;
    int totalEvaluatedSetCount = 0;

    for (final summary in exerciseSummaries) {
      totalHitSetCount += summary.targetHitSetCount;

      totalEvaluatedSetCount +=
          summary.targetHitSetCount + summary.underTargetSetCount;
    }

    final double? targetHitSetRate = totalEvaluatedSetCount == 0
        ? null
        : totalHitSetCount / totalEvaluatedSetCount;

    double? bestActualMaxWeight;

    for (final summary in exerciseSummaries) {
      final weight = summary.actualMaxWeight;

      if (weight == null) {
        continue;
      }

      if (bestActualMaxWeight == null || weight > bestActualMaxWeight) {
        bestActualMaxWeight = weight;
      }
    }
    final trendSummaries = exerciseSummaries
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
    return LongTermExerciseProgress(
      exerciseId: exerciseId,

      sessionCount: sessionCount,
      firstPerformedAt: firstPerformedAt,
      lastPerformedAt: lastPerformedAt,

      hitSessionCount: hitSessionCount,
      missedTargetSessionCount: missedTargetSessionCount,
      targetHitSetRate: targetHitSetRate,

      bestActualMaxWeight: bestActualMaxWeight,

      weightTrend: weightTrend,
      volumeTrend: volumeTrend,
    );
  }
}
