
import 'package:injectable/injectable.dart';

import '../../domain/entities/exercise_session_summary.dart';
import '../mapper/long_term_state_cache_codec.dart';

@lazySingleton
class LongTermAggregateStateUpdater {
  const LongTermAggregateStateUpdater();

  static const int _sampleLimit = 5;

  LongTermAggregateState update({
    required LongTermAggregateState previous,
    required ExerciseSessionSummary newSummary,
  }) {
    //Cộng dồn số sets được đánh giá.
    final totalHitSets =
        previous.totalHitSets + newSummary.targetHitSetCount;

    final totalEvaluatedSets =
        previous.totalEvaluatedSets +
            newSummary.targetHitSetCount +
            newSummary.underTargetSetCount;

    var weightSampleCount = previous.weightSampleCount;
    var firstWeightSamples = previous.firstWeightSamples;
    var lastWeightSamples = previous.lastWeightSamples;

    var volumeSampleCount = previous.volumeSampleCount;
    var firstVolumeSamples = previous.firstVolumeSamples;
    var lastVolumeSamples = previous.lastVolumeSamples;

    //Chỉ lấy mẫu trend từ buổi có completed sets.
    if (newSummary.completedSetCount > 0) {
      final weight = newSummary.actualMaxWeight;

      if (weight != null) {
        weightSampleCount++;

        firstWeightSamples = _appendFirst(
          firstWeightSamples,
          weight,
        );

        lastWeightSamples = _appendLast(
          lastWeightSamples,
          weight,
        );
      }

      volumeSampleCount++;

      firstVolumeSamples = _appendFirst(
        firstVolumeSamples,
        newSummary.actualVolume,
      );

      lastVolumeSamples = _appendLast(
        lastVolumeSamples,
        newSummary.actualVolume,
      );
    }

    return LongTermAggregateState(
      totalHitSets: totalHitSets,
      totalEvaluatedSets: totalEvaluatedSets,
      weightSampleCount: weightSampleCount,
      firstWeightSamples: firstWeightSamples,
      lastWeightSamples: lastWeightSamples,
      volumeSampleCount: volumeSampleCount,
      firstVolumeSamples: firstVolumeSamples,
      lastVolumeSamples: lastVolumeSamples,
    );
  }

  // Giữ tối đa 5 mẫu đầu tiên.
  List<double> _appendFirst(
      List<double> samples,
      double value,
      ) {
    if (samples.length >= _sampleLimit) {
      return samples;
    }

    return [...samples, value];
  }

  // Giữ tối đa 5 mẫu gần nhất.
  List<double> _appendLast(
      List<double> samples,
      double value,
      ) {
    final updated = [...samples, value];

    if (updated.length <= _sampleLimit) {
      return updated;
    }

    return updated.sublist(updated.length - _sampleLimit);
  }
}
