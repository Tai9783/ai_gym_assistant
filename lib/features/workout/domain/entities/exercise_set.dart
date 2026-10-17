enum ExerciseSetStatus { pending, completed, skipped }

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

  ExerciseSet copyWith({
    double? actualWeight,
    int? actualReps,
    ExerciseSetStatus? status,
    String? note,
  }) {
    return ExerciseSet(
      id: id,
      setNumber: setNumber,
      suggestedWeight: suggestedWeight,
      suggestedReps: suggestedReps,
      actualWeight: actualWeight ?? this.actualWeight,
      actualReps: actualReps ?? this.actualReps,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}
