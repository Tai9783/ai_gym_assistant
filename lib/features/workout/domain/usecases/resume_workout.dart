import 'package:injectable/injectable.dart';

import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

@lazySingleton
class ResumeWorkout {
  final WorkoutRepository repository;

  ResumeWorkout(this.repository);

  Future<WorkoutSession> call(String sessionId) async {
    final session = await repository.getWorkoutSessionById(sessionId);

    if (session == null) {
      throw StateError('Không tìm thấy buổi tập.');
    }

    if (session.status != WorkoutSessionStatus.inProgress) {
      throw StateError('Buổi tập này đã kết thúc.');
    }

    return session;
  }
}