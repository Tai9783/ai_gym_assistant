import 'workout_exercise.dart';

enum WorkoutSessionStatus {
  inProgress,
  completed,
}

class WorkoutSession {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final WorkoutSessionStatus status;
  final List<WorkoutExercise> exercises;

  const WorkoutSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.status,
    required this.exercises,
  });
}