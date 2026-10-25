import 'package:injectable/injectable.dart';

import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

@lazySingleton
class GetInProgressWorkoutSessions {
  final WorkoutRepository repository;

  GetInProgressWorkoutSessions(this.repository);

  Future<List<WorkoutSession>> call() async {
    return await repository.getInProgressWorkoutSessions();
  }
}