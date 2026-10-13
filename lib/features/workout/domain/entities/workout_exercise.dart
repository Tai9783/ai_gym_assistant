import 'exercise_set.dart';

class WorkoutExercise {
  final String id;
  final String exerciseId;
  final int order;
  final List<ExerciseSet> sets;

  const WorkoutExercise({
    required this.id,
    required this.exerciseId,
    required this.order,
    required this.sets,
  });
}