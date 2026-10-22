
import 'dart:convert';

import '../../domain/entities/progress_trend.dart';
import '../../domain/entities/recent_exercise_progress.dart';

class RecentProgressCacheCodec {
  const RecentProgressCacheCodec._();

  static String encode(RecentExerciseProgress progress) {
    return jsonEncode({
      'exerciseId': progress.exerciseId,
      'sessionCount': progress.sessionCount,
      'windowStartAt': progress.windowStartAt.toIso8601String(),
      'windowEndAt': progress.windowEndAt.toIso8601String(),
      'latestSessionHitTarget': progress.latestSessionHitTarget,
      'hitSessionCount': progress.hitSessionCount,
      'missedTargetSessionCount': progress.missedTargetSessionCount,
      'currentMissStreak': progress.currentMissStreak,
      'targetHitSetRate': progress.targetHitSetRate,
      'underTargetSetFrequency': progress.underTargetSetFrequency.map(
            (key, value) => MapEntry(key.toString(), value),
      ),
      'latestSuggestedMaxWeight': progress.latestSuggestedMaxWeight,
      'latestActualMaxWeight': progress.latestActualMaxWeight,
      'latestSuggestedTotalReps': progress.latestSuggestedTotalReps,
      'latestActualTotalReps': progress.latestActualTotalReps,
      'weightTrend': progress.weightTrend.name,
      'volumeTrend': progress.volumeTrend.name,
    });
  }

  static RecentExerciseProgress decode(String jsonString) {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    final frequency =
    (data['underTargetSetFrequency'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
        int.parse(key),
        (value as num).toInt(),
      ),
    );

    return RecentExerciseProgress(
      exerciseId: data['exerciseId'] as String,
      sessionCount: (data['sessionCount'] as num).toInt(),
      windowStartAt: DateTime.parse(data['windowStartAt'] as String),
      windowEndAt: DateTime.parse(data['windowEndAt'] as String),
      latestSessionHitTarget: data['latestSessionHitTarget'] as bool,
      hitSessionCount: (data['hitSessionCount'] as num).toInt(),
      missedTargetSessionCount:
      (data['missedTargetSessionCount'] as num).toInt(),
      currentMissStreak: (data['currentMissStreak'] as num).toInt(),
      targetHitSetRate: (data['targetHitSetRate'] as num).toDouble(),
      underTargetSetFrequency: frequency,
      latestSuggestedMaxWeight:
      (data['latestSuggestedMaxWeight'] as num?)?.toDouble(),
      latestActualMaxWeight:
      (data['latestActualMaxWeight'] as num?)?.toDouble(),
      latestSuggestedTotalReps:
      (data['latestSuggestedTotalReps'] as num).toInt(),
      latestActualTotalReps:
      (data['latestActualTotalReps'] as num).toInt(),
      weightTrend: ProgressTrend.values.byName(
        data['weightTrend'] as String,
      ),
      volumeTrend: ProgressTrend.values.byName(
        data['volumeTrend'] as String,
      ),
    );
  }
}
