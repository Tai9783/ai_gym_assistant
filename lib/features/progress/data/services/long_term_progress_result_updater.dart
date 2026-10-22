
import 'package:injectable/injectable.dart';

import '../../domain/entities/exercise_session_summary.dart';
import '../../domain/entities/long_term_exercise_progress.dart';
import '../../domain/services/long_term_trend_calculator.dart';
import '../../domain/services/session_target_classifier.dart';
import '../mapper/long_term_state_cache_codec.dart';

@lazySingleton
class LongTermProgressResultUpdater {
  final SessionTargetClassifier _classifier;
  final LongTermTrendCalculator _trendCalculator;

  const LongTermProgressResultUpdater(
      this._classifier,
      this._trendCalculator,
      );

  LongTermExerciseProgress update({
    required LongTermExerciseProgress? previous,
    required LongTermAggregateState state,
    required ExerciseSessionSummary newSummary,
  }) {
    // Phân loại Session đạt hay ko
    final sessionResult = _classifier.classify(newSummary);

    final sessionCount = (previous?.sessionCount ?? 0) + 1;

    final hitSessionCount =
        (previous?.hitSessionCount ?? 0) +
            (sessionResult == SessionTargetResult.hit ? 1 : 0);

    final missedTargetSessionCount =
        (previous?.missedTargetSessionCount ?? 0) +
            (sessionResult == SessionTargetResult.miss ? 1 : 0);

    final double? targetHitSetRate =
    state.totalEvaluatedSets == 0
        ? null
        : state.totalHitSets / state.totalEvaluatedSets;

    double? bestActualMaxWeight =
        previous?.bestActualMaxWeight;

    final newWeight = newSummary.actualMaxWeight;

    if (newWeight != null &&
        (bestActualMaxWeight == null ||
            newWeight > bestActualMaxWeight)) {
      bestActualMaxWeight = newWeight;
    }

    //
    final weightValues = _trendValues(
      count: state.weightSampleCount,
      first: state.firstWeightSamples,
      last: state.lastWeightSamples,
    );

    final volumeValues = _trendValues(
      count: state.volumeSampleCount,
      first: state.firstVolumeSamples,
      last: state.lastVolumeSamples,
    );

    // tính trend
    final weightTrend = _trendCalculator.calculate(
      chronologicalValues: weightValues,
      thresholdRatio: 0.05,
    );

    final volumeTrend = _trendCalculator.calculate(
      chronologicalValues: volumeValues,
      thresholdRatio: 0.10,
    );

    return LongTermExerciseProgress(
      exerciseId: newSummary.exerciseId,
      sessionCount: sessionCount,
      firstPerformedAt:
      previous?.firstPerformedAt ?? newSummary.performedAt,
      lastPerformedAt: newSummary.performedAt,
      hitSessionCount: hitSessionCount,
      missedTargetSessionCount: missedTargetSessionCount,
      targetHitSetRate: targetHitSetRate,
      bestActualMaxWeight: bestActualMaxWeight,
      weightTrend: weightTrend,
      volumeTrend: volumeTrend,
    );
  }

  // Tạo lại chuỗi mẫu cần thiết cho Trend Calculator.
  List<double> _trendValues({
    required int count,
    required List<double> first,
    required List<double> last,
  }) {
    if (count <= 5) {
      return [...first];
    }

    if (count < 10) {
      final remaining = count - 5;

      return [
        ...first,
        ...last.skip(last.length - remaining),
      ];
    }

    return [
      ...first,
      ...last,
    ];
  }
}
