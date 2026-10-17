import '../../../progress/domain/entities/recent_exercise_progress.dart';
import '../../../progress/domain/entities/long_term_exercise_progress.dart';
import '../../domain/entities/ai_context.dart';

class AiContextSerializer {
  static Map<String, dynamic> toJson(AiContext context) {
    final profile = context.profile;

    return {
      'request': {
        'focus': context.request.focus.name,
        'exerciseIds': context.request.exerciseIds,
        'note': context.request.note,
      },
      'profile': profile == null
          ? null
          : {
              'goal': profile.goal,
              'weightKg': profile.weightKg,
              'heightCm': profile.heightCm,
              'age': profile.age,
            },
      'exercises': context.exercises.map((item) {
        return {
          'exercise': {
            'id': item.exercise.id,
            'name': item.exercise.name,
            'muscleGroup': item.exercise.muscleGroup.name,
          },
          'recent': item.recent == null ? null : _recentToJson(item.recent!),
          'longTerm': item.longTerm == null
              ? null
              : _longTermToJson(item.longTerm!),
        };
      }).toList(),
    };
  }

  static Map<String, dynamic> _recentToJson(RecentExerciseProgress progress) {
    return {
      'exerciseId': progress.exerciseId,
      'sessionCount': progress.sessionCount,
      'windowStartAt': progress.windowStartAt.toUtc().toIso8601String(),
      'windowEndAt': progress.windowEndAt.toUtc().toIso8601String(),
      'latestSessionHitTarget': progress.latestSessionHitTarget,
      'hitSessionCount': progress.hitSessionCount,
      'missedTargetSessionCount': progress.missedTargetSessionCount,
      'currentMissStreak': progress.currentMissStreak,
      'targetHitSetRate': progress.targetHitSetRate,
      'underTargetSetFrequency': progress.underTargetSetFrequency.map(
        (setNumber, count) => MapEntry(setNumber.toString(), count),
      ),
      'latestSuggestedMaxWeight': progress.latestSuggestedMaxWeight,
      'latestActualMaxWeight': progress.latestActualMaxWeight,
      'latestSuggestedTotalReps': progress.latestSuggestedTotalReps,
      'latestActualTotalReps': progress.latestActualTotalReps,
      'weightTrend': progress.weightTrend.name,
      'volumeTrend': progress.volumeTrend.name,
    };
  }

  static Map<String, dynamic> _longTermToJson(
    LongTermExerciseProgress progress,
  ) {
    return {
      'exerciseId': progress.exerciseId,
      'sessionCount': progress.sessionCount,
      'firstPerformedAt': progress.firstPerformedAt.toUtc().toIso8601String(),
      'lastPerformedAt': progress.lastPerformedAt.toUtc().toIso8601String(),
      'hitSessionCount': progress.hitSessionCount,
      'missedTargetSessionCount': progress.missedTargetSessionCount,
      'targetHitSetRate': progress.targetHitSetRate,
      'bestActualMaxWeight': progress.bestActualMaxWeight,
      'weightTrend': progress.weightTrend.name,
      'volumeTrend': progress.volumeTrend.name,
    };
  }
}
