import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout_exercise.dart';

sealed class WorkoutEvent {
  const WorkoutEvent();
}

final class WorkoutStarted extends WorkoutEvent {
  final List<WorkoutExercise> exercises;

  const WorkoutStarted({required this.exercises});
}

final class ExerciseSetUpdated extends WorkoutEvent {
  final String sessionId;
  final String workoutExerciseId;
  final String setId;
  final double? actualWeight;
  final int? actualReps;
  final ExerciseSetStatus status;
  final String? note;

  const ExerciseSetUpdated({
    required this.sessionId,
    required this.workoutExerciseId,
    required this.setId,
    this.actualWeight,
    this.actualReps,
    required this.status,
    this.note,
  });
}

final class WorkoutFinished extends WorkoutEvent {
  final String sessionId;

  const WorkoutFinished({required this.sessionId});
}
final class WorkoutResumed extends WorkoutEvent {
  final String sessionId;

  const WorkoutResumed({required this.sessionId});
}
