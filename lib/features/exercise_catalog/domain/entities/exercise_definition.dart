enum MuscleGroup { chest, back, legs, shoulders, arms, fullBody }

class ExerciseDefinition {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;

  const ExerciseDefinition({
    required this.id,
    required this.name,
    required this.muscleGroup,
  });
}
