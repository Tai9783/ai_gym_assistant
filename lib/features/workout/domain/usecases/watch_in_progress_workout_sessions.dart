import 'package:injectable/injectable.dart';

import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

@lazySingleton
class WatchInProgressWorkoutSessions {
  final WorkoutRepository repository;

  WatchInProgressWorkoutSessions(this.repository);

  Stream<List<WorkoutSession>> call() {
    return repository.watchInProgressWorkoutSessions();
  }
}