import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';

import '../../../progress/domain/repositories/progress_cache_synchronizer.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

@LazySingleton()
class FinishWorkout {
  final WorkoutRepository repository;
  final ProgressCacheSynchronizer progressCacheSynchronizer;

  FinishWorkout(
      this.repository,
      this.progressCacheSynchronizer,
      );

  Future<WorkoutSession> call({
    required String sessionId,
  }) async {
    final completedSession =
    await repository.completeWorkoutSession(
      sessionId: sessionId,
    );

    //Sau khi History đã lưu thành công,
    // mới tiến hành đồng bộ Progress Cache.
    try {
      await progressCacheSynchronizer.syncAfterWorkout(
        completedSession,
      );
    } catch (error, stackTrace) {
      developer.log(
        'Progress Cache sync failed: $sessionId',
        name: 'ProgressCache',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return completedSession;
  }
}
