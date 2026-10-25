import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../entities/workout_exercise.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

@LazySingleton()
class StartWorkout {
  final WorkoutRepository repository;

  StartWorkout(this.repository);

  Future<WorkoutSession> call({
    required List<WorkoutExercise> exercises,
  }) async {
    final inProgressSessions =
    await repository.getInProgressWorkoutSessions();

    if (inProgressSessions.isNotEmpty) {
      throw StateError(
        'Bạn đang có buổi tập chưa kết thúc. '
            'Vui lòng tiếp tục hoặc xử lý buổi tập hiện tại.',
      );
    }
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
