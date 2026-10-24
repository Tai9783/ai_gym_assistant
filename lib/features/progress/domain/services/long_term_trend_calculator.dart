import 'package:injectable/injectable.dart';

import '../entities/progress_trend.dart';
@injectable
class LongTermTrendCalculator {
  ProgressTrend calculate({
    required List<double> chronologicalValues,
    required double thresholdRatio,
  }) {
    final count = chronologicalValues.length;

    if (count < 2) {
      return ProgressTrend.insufficientData;
    }

    final earlyCount = count >= 10 ? 5 : count ~/ 2;
    final lateCount = count >= 10 ? 5 : count - earlyCount;

    final earlyValues = chronologicalValues.take(earlyCount);
    final lateValues = chronologicalValues.skip(count - lateCount);

    final earlyAverage =
        earlyValues.fold<double>(0, (sum, value) => sum + value) / earlyCount;

    final lateAverage =
        lateValues.fold<double>(0, (sum, value) => sum + value) / lateCount;

    if (earlyAverage <= 0) {
      return ProgressTrend.insufficientData;
    }

    final changeRatio = (lateAverage - earlyAverage) / earlyAverage;

    if (changeRatio > thresholdRatio) {
      return ProgressTrend.increasing;
    }

    if (changeRatio < -thresholdRatio) {
      return ProgressTrend.decreasing;
    }

    return ProgressTrend.stable;
  }
}
