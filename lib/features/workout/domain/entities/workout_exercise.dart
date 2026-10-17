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

  WorkoutExercise copyWith({
    String? id,
    String? exerciseId,
    int? order,
    List<ExerciseSet>? sets,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      order: order ?? this.order,
      sets: sets ?? this.sets,
    );
  }
}
