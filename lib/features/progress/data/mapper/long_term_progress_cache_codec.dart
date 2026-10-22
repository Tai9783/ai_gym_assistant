
import 'dart:convert';

import '../../domain/entities/long_term_exercise_progress.dart';
import '../../domain/entities/progress_trend.dart';

class LongTermProgressCacheCodec {
  const LongTermProgressCacheCodec._();

  // Chuyển LongTermExerciseProgress thành JSON String.
  static String encode(LongTermExerciseProgress progress) {
    return jsonEncode({
      'exerciseId': progress.exerciseId,
      'sessionCount': progress.sessionCount,
      'firstPerformedAt': progress.firstPerformedAt.toIso8601String(),
      'lastPerformedAt': progress.lastPerformedAt.toIso8601String(),
      'hitSessionCount': progress.hitSessionCount,
      'missedTargetSessionCount': progress.missedTargetSessionCount,
      'targetHitSetRate': progress.targetHitSetRate,
      'bestActualMaxWeight': progress.bestActualMaxWeight,
      'weightTrend': progress.weightTrend.name,
      'volumeTrend': progress.volumeTrend.name,
    });
  }

  // Khôi phục Domain Entity từ JSON String trong SQLite.
  static LongTermExerciseProgress decode(String jsonString) {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    return LongTermExerciseProgress(
      exerciseId: data['exerciseId'] as String,
      sessionCount: (data['sessionCount'] as num).toInt(),
      firstPerformedAt: DateTime.parse(
        data['firstPerformedAt'] as String,
      ),
      lastPerformedAt: DateTime.parse(
        data['lastPerformedAt'] as String,
      ),
      hitSessionCount: (data['hitSessionCount'] as num).toInt(),
      missedTargetSessionCount:
      (data['missedTargetSessionCount'] as num).toInt(),
      targetHitSetRate:
      (data['targetHitSetRate'] as num?)?.toDouble(),
      bestActualMaxWeight:
      (data['bestActualMaxWeight'] as num?)?.toDouble(),
      weightTrend: ProgressTrend.values.byName(
        data['weightTrend'] as String,
      ),
      volumeTrend: ProgressTrend.values.byName(
        data['volumeTrend'] as String,
      ),
    );
  }
}
