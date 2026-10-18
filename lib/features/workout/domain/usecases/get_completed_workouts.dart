import 'package:injectable/injectable.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

@lazySingleton
class GetCompletedWorkouts {
  final WorkoutRepository repository;

  GetCompletedWorkouts(this.repository);

  Future<List<WorkoutSession>> call() {
    return repository.getCompletedWorkoutSessions();
  }
}
