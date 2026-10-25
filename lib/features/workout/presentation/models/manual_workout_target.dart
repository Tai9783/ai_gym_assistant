class ManualSetTarget {
  final double weight;
  final int reps;

  const ManualSetTarget({required this.weight, required this.reps});
}

class ManualExerciseTarget {
  final String exerciseId;
  final List<ManualSetTarget> sets;

  const ManualExerciseTarget({required this.exerciseId, required this.sets});
}
