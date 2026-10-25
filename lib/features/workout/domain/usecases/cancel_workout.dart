import 'package:injectable/injectable.dart';

import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

@LazySingleton()
class CancelWorkout {
  final WorkoutRepository repository;

  CancelWorkout(this.repository);

  Future<WorkoutSession> call({
    required String sessionId,
  }) {
    return repository.cancelWorkoutSession(
      sessionId: sessionId,
    );
  }
}