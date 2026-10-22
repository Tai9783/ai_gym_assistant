
import 'dart:convert';

import '../../domain/entities/exercise_session_summary.dart';

class RecentWindowCacheCodec {
  const RecentWindowCacheCodec._();

  static String encode(List<ExerciseSessionSummary> summaries) {
    return jsonEncode(
      summaries.map((summary) {
        return {
          'sessionId': summary.sessionId,
          'exerciseId': summary.exerciseId,
          'performedAt': summary.performedAt.toIso8601String(),

          'plannedSetCount': summary.plannedSetCount,
          'completedSetCount': summary.completedSetCount,
          'skippedSetCount': summary.skippedSetCount,

          'suggestedTotalReps': summary.suggestedTotalReps,
          'actualTotalReps': summary.actualTotalReps,

          'suggestedVolume': summary.suggestedVolume,
          'actualVolume': summary.actualVolume,

          'suggestedMaxWeight': summary.suggestedMaxWeight,
          'actualMaxWeight': summary.actualMaxWeight,

          'targetHitSetCount': summary.targetHitSetCount,
          'underTargetSetCount': summary.underTargetSetCount,
          'underTargetSetNumbers': summary.underTargetSetNumbers,
        };
      }).toList(),
    );
  }

  static List<ExerciseSessionSummary> decode(String jsonString) {
    final data = jsonDecode(jsonString) as List<dynamic>;

    return data.map((item) {
      final map = item as Map<String, dynamic>;

      return ExerciseSessionSummary(
        sessionId: map['sessionId'] as String,
        exerciseId: map['exerciseId'] as String,
        performedAt: DateTime.parse(
          map['performedAt'] as String,
        ),

        plannedSetCount: (map['plannedSetCount'] as num).toInt(),
        completedSetCount: (map['completedSetCount'] as num).toInt(),
        skippedSetCount: (map['skippedSetCount'] as num).toInt(),

        suggestedTotalReps: (map['suggestedTotalReps'] as num).toInt(),
        actualTotalReps: (map['actualTotalReps'] as num).toInt(),

        suggestedVolume: (map['suggestedVolume'] as num).toDouble(),
        actualVolume: (map['actualVolume'] as num).toDouble(),

        suggestedMaxWeight:
        (map['suggestedMaxWeight'] as num?)?.toDouble(),
        actualMaxWeight:
        (map['actualMaxWeight'] as num?)?.toDouble(),

        targetHitSetCount: (map['targetHitSetCount'] as num).toInt(),
        underTargetSetCount: (map['underTargetSetCount'] as num).toInt(),
        underTargetSetNumbers:
        (map['underTargetSetNumbers'] as List<dynamic>)
            .map((value) => (value as num).toInt())
            .toList(),
      );
    }).toList();
  }
}
