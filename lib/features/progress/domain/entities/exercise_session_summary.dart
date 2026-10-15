class ExerciseSessionSummary {
  final String sessionId;
  final String exerciseId;
  final DateTime performedAt;

  final int plannedSetCount;
  final int completedSetCount;
  final int skippedSetCount;

  final int suggestedTotalReps;
  final int actualTotalReps;

  final double suggestedVolume;
  final double actualVolume;

  final double? suggestedMaxWeight;
  final double? actualMaxWeight;

  final int targetHitSetCount;
  final int underTargetSetCount;
  final List<int> underTargetSetNumbers;

  const ExerciseSessionSummary({
    required this.sessionId,
    required this.exerciseId,
    required this.performedAt,
    required this.plannedSetCount,
    required this.completedSetCount,
    required this.skippedSetCount,
    required this.suggestedTotalReps,
    required this.actualTotalReps,
    required this.suggestedVolume,
    required this.actualVolume,
    required this.suggestedMaxWeight,
    required this.actualMaxWeight,
    required this.targetHitSetCount,
    required this.underTargetSetCount,
    required this.underTargetSetNumbers,
  });
}