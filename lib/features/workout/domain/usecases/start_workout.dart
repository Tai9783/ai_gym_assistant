import 'package:uuid/uuid.dart';

import '../entities/workout_exercise.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

class StartWorkout {
  final WorkoutRepository repository;

  StartWorkout(this.repository);

  Future<WorkoutSession> call({
    required List<WorkoutExercise> exercises,
  }) async {
    final session = WorkoutSession(
      id: const Uuid().v4(),
      startedAt: DateTime.now(),
      endedAt: null,
      status: WorkoutSessionStatus.inProgress,
      exercises: exercises,
    );

    await repository.saveWorkoutSession(session);

    return session;
  }
}