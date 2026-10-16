import 'package:ai_gym_assistant/features/progress/domain/entities/progress_trend.dart';
import 'package:ai_gym_assistant/features/progress/domain/entities/recent_exercise_progress.dart';

class LongTermExerciseProgress {
  final String exerciseId;

  final int sessionCount;
  final DateTime firstPerformedAt;
  final DateTime lastPerformedAt;

  final int hitSessionCount;
  final int missedTargetSessionCount;
  final double? targetHitSetRate;

  final double? bestActualMaxWeight;

  final ProgressTrend weightTrend;
  final ProgressTrend volumeTrend;

  const LongTermExerciseProgress({
    required this.exerciseId,
    required this.sessionCount,
    required this.firstPerformedAt,
    required this.lastPerformedAt,
    required this.hitSessionCount,
    required this.missedTargetSessionCount,
    required this.targetHitSetRate,
    required this.bestActualMaxWeight,
    required this.weightTrend,
    required this.volumeTrend,
  });
}
