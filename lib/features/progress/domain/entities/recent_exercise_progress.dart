import 'package:ai_gym_assistant/features/progress/domain/entities/progress_trend.dart';

class RecentExerciseProgress {
  final String exerciseId;

  final int sessionCount;
  final DateTime windowStartAt;
  final DateTime windowEndAt;

  final bool latestSessionHitTarget;
  // Number of recent sessions that fully reached the suggested target.
  final int hitSessionCount;

  // Number of recent sessions that did not fully reach the target.
  final int missedTargetSessionCount;

  // Number of consecutive missed sessions counting backward
  // from the most recent session.
  // HIT, HIT, MISS, MISS
  // => currentMissStreak = 2
  //
  // HIT, MISS, HIT
  // => currentMissStreak = 0
  final int currentMissStreak;

  // 5 sessions x 3 sets = 15 sets
  // 12 sets reached target
  // => targetHitSetRate = 12 / 15 = 0.8
  final double targetHitSetRate;

  final Map<int, int> underTargetSetFrequency;

  final double? latestSuggestedMaxWeight;
  final double? latestActualMaxWeight;

  final int latestSuggestedTotalReps;
  final int latestActualTotalReps;

  final ProgressTrend weightTrend;
  final ProgressTrend volumeTrend;

  const RecentExerciseProgress({
    required this.exerciseId,
    required this.sessionCount,
    required this.windowStartAt,
    required this.windowEndAt,
    required this.latestSessionHitTarget,
    required this.hitSessionCount,
    required this.missedTargetSessionCount,
    required this.currentMissStreak,
    required this.targetHitSetRate,
    required this.underTargetSetFrequency,
    required this.latestSuggestedMaxWeight,
    required this.latestActualMaxWeight,
    required this.latestSuggestedTotalReps,
    required this.latestActualTotalReps,
    required this.weightTrend,
    required this.volumeTrend,
  });
}
