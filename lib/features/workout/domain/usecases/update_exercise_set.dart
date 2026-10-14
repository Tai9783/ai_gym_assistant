import 'package:injectable/injectable.dart';

import '../entities/exercise_set.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';
@LazySingleton()
class UpdateExerciseSet {
  final WorkoutRepository repository;

  UpdateExerciseSet(this.repository);

  Future<WorkoutSession> call({
    required String sessionId,
    required String workoutExerciseId,
    required String setId,
    double? actualWeight,
    int? actualReps,
    required ExerciseSetStatus status,
    String? note,
  }) async {
    final session = await repository.getWorkoutSessionById(sessionId);

    if (session == null) {
      throw StateError('Workout session not found');
    }

    final updatedExercises = session.exercises.map((exercise) {
      if (exercise.id != workoutExerciseId) {
        return exercise;
      }

      final updatedSets = exercise.sets.map((set) {
        if (set.id != setId) {
          return set;
        }

        return set.copyWith(
          actualWeight: actualWeight,
          actualReps: actualReps,
          status: status,
          note: note,
        );
      }).toList();

      return exercise.copyWith(
        sets: updatedSets,
      );
    }).toList();

    final updatedSession = session.copyWith(
      exercises: updatedExercises,
    );

    await repository.saveWorkoutSession(updatedSession);

    return updatedSession;
  }
}