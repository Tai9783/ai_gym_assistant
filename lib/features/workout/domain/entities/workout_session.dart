import 'workout_exercise.dart';

enum WorkoutSessionStatus { inProgress, completed }

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

  WorkoutSession copyWith({
    String? id,
    DateTime? startedAt,
    DateTime? endedAt,
    WorkoutSessionStatus? status,
    List<WorkoutExercise>? exercises,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
    );
  }
}
