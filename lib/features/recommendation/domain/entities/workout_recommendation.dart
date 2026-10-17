class WorkoutRecommendation {
  final List<RecommendedExercise> exercises;

  const WorkoutRecommendation({required this.exercises});
}

class RecommendedExercise {
  final String exerciseId;
  final List<RecommendedSet> sets;

  const RecommendedExercise({required this.exerciseId, required this.sets});
}

class RecommendedSet {
  final double suggestedWeight;
  final int suggestedReps;

  const RecommendedSet({
    required this.suggestedWeight,
    required this.suggestedReps,
  });
}
