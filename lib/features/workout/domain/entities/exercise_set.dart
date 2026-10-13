enum ExerciseSetStatus {
  pending,
  completed,
  skipped,
}
class ExerciseSet {
  final String id;
  final int setNumber;

  final double? suggestedWeight;
  final int? suggestedReps;

  final double? actualWeight;
  final int? actualReps;

  final ExerciseSetStatus status;
  final String? note;

  const ExerciseSet({
    required this.id,
    required this.setNumber,
    this.suggestedWeight,
    this.suggestedReps,
    this.actualWeight,
    this.actualReps,
    required this.status,
    this.note,
  });
}