
import 'package:injectable/injectable.dart';

import '../../../workout/domain/entities/workout_session.dart';
import '../../../workout/domain/repositories/workout_repository.dart';

import '../../domain/entities/exercise_session_summary.dart';
import '../../domain/entities/long_term_exercise_progress.dart';
import '../../domain/entities/recent_exercise_progress.dart';
import '../../domain/repositories/progress_cache_synchronizer.dart';
import '../../domain/services/exercise_session_summarizer.dart';

import '../constants/progress_cache_version.dart';
import '../datasources/exercise_progress_cache_local_data_source.dart';
import '../mapper/long_term_progress_cache_codec.dart';
import '../mapper/long_term_state_cache_codec.dart';
import '../mapper/recent_progress_cache_codec.dart';
import '../mapper/recent_window_cache_codec.dart';
import '../services/exercise_progress_cache_initializer.dart';
import '../services/exercise_progress_cache_updater.dart';

@LazySingleton(as: ProgressCacheSynchronizer)
class ProgressCacheSynchronizerImpl
    implements ProgressCacheSynchronizer {
  final WorkoutRepository _workoutRepository;
  final ExerciseProgressCacheLocalDataSource _cacheDataSource;
  final ExerciseSessionSummarizer _summarizer;
  final ExerciseProgressCacheInitializer _initializer;
  final ExerciseProgressCacheUpdater _updater;

  ProgressCacheSynchronizerImpl(
      this._workoutRepository,
      this._cacheDataSource,
      this._summarizer,
      this._initializer,
      this._updater,
      );

  @override
  Future<void> syncAfterWorkout(
      WorkoutSession completedSession,
      ) async {
    if (completedSession.status != WorkoutSessionStatus.completed) {
      throw StateError('Workout is not completed');
    }

    await _cacheDataSource.runInTransaction(() async {
      // Workout không còn Pending thì không xử lý lại.
      final isPending = await _cacheDataSource
          .hasPendingProgressUpdate(completedSession.id);

      if (!isPending) return;

      final exerciseIds = completedSession.exercises
          .map((exercise) => exercise.exerciseId)
          .toSet();

      for (final exerciseId in exerciseIds) {
        await _syncExercise(
          exerciseId: exerciseId,
          completedSession: completedSession,
        );
      }
      await _cacheDataSource.deletePendingProgressUpdate(
        completedSession.id,
      );
    });
  }
  @override
  Future<void> recoverPendingProgressUpdates() async {
    final pendingIds =
    await _cacheDataSource.getPendingWorkoutIds();

    if (pendingIds.isEmpty) return;

    for (final workoutId in pendingIds) {
      final session =
      await _workoutRepository.getWorkoutSessionById(workoutId);

      if (session == null ||
          session.status != WorkoutSessionStatus.completed) {
        throw StateError('Invalid pending workout: $workoutId');
      }

      await syncAfterWorkout(session);
    }
  }
  Future<void> _syncExercise({
    required String exerciseId,
    required WorkoutSession completedSession,
  }) async {

    final cache = await _cacheDataSource.getByExerciseId(exerciseId);


    LongTermExerciseProgress? cachedLongTerm;

    // Kiểm tra dữ liệu Cache hiện tại có đọc được không.
    if (cache != null &&
        !cache.needsRebuild &&
        cache.calculationVersion == ProgressCacheVersion.current &&
        cache.recentProgressJson != null &&
        cache.longTermProgressJson != null) {
      try {
        cachedLongTerm = LongTermProgressCacheCodec.decode(
          cache.longTermProgressJson!,
        );

        RecentProgressCacheCodec.decode(cache.recentProgressJson!);
        RecentWindowCacheCodec.decode(cache.recentWindowJson);
        LongTermStateCacheCodec.decode(cache.longTermStateJson);

        if (cachedLongTerm.exerciseId != exerciseId) {
          cachedLongTerm = null;
        }
      } catch (_) {
        // JSON lỗi thì rebuild.
        cachedLongTerm = null;
      }
    }

    if (cachedLongTerm != null &&
        cache!.lastProcessedSessionId == completedSession.id) {
      return;
    }

    // Chỉ incremental khi Cache hợp lệ
    // và buổi tập mới có thời gian sau Cache hiện tại.
    if (cachedLongTerm != null) {
      final exercise = completedSession.exercises.singleWhere(
            (exercise) => exercise.exerciseId == exerciseId,
      );

      final newSummary = _summarizer.summarize(
        session: completedSession,
        exercise: exercise,
      );

      if (newSummary.performedAt.isAfter(
        cachedLongTerm.lastPerformedAt,
      )) {
        await _updater.update(newSummary: newSummary);
        return;
      }
    }

    // Không đủ điều kiện incremental:
    // khởi tạo lại từ History.
    final rebuilt = await _rebuildExercise(exerciseId);

    if (!rebuilt) {
      throw StateError(
        'Completed exercise not found in History: $exerciseId',
      );
    }
  }

  Future<bool> _rebuildExercise(
      String exerciseId,
      ) async {
    final sessions = await _workoutRepository
        .getCompletedWorkoutSessionsByExerciseId(exerciseId);

    final summaries = <ExerciseSessionSummary>[];

    for (final session in sessions) {
      for (final exercise in session.exercises) {
        if (exercise.exerciseId == exerciseId) {
          summaries.add(
            _summarizer.summarize(
              session: session,
              exercise: exercise,
            ),
          );
        }
      }
    }

    if (summaries.isEmpty) {
      return false;
    }
    await _initializer.initialize(
      exerciseId: exerciseId,
      historySummaries: summaries,
    );
    return true;
  }

  @override
  Future<({
  RecentExerciseProgress? recent,
  LongTermExerciseProgress? longTerm,
  List<ExerciseSessionSummary> recentWindow,
  })> readValidProgress(String exerciseId) {
    return _cacheDataSource.runInTransaction(() async {
      //Đọc Cache hiện có.
      final cache = await _cacheDataSource.getByExerciseId(exerciseId);

      if (cache != null &&
          !cache.needsRebuild &&
          cache.calculationVersion == ProgressCacheVersion.current &&
          cache.recentProgressJson != null &&
          cache.longTermProgressJson != null) {
        try {
          final recent = RecentProgressCacheCodec.decode(
            cache.recentProgressJson!,
          );
          final recentWindow = RecentWindowCacheCodec.decode(
            cache.recentWindowJson,
          );

          final longTerm = LongTermProgressCacheCodec.decode(
            cache.longTermProgressJson!,
          );

          if (recent.exerciseId == exerciseId &&
              longTerm.exerciseId == exerciseId &&
            recentWindow.length == recent.sessionCount &&
            recentWindow.every(
            (summary) => summary.exerciseId == exerciseId,
        )) {
            return (recent: recent, longTerm: longTerm, recentWindow: recentWindow);
          }
        } catch (_) {
        }
      }

      //Cache thiếu, lỗi hoặc chưa đồng bộ.
      final rebuiltSuccessfully = await _rebuildExercise(exerciseId);

      if (!rebuiltSuccessfully) {
        return (
        recent: null,
        longTerm: null,
        recentWindow: <ExerciseSessionSummary>[],
        );
      }

      //Đọc lại Cache vừa rebuild.
      final rebuilt = await _cacheDataSource.getByExerciseId(exerciseId);

      if (rebuilt == null ||
          rebuilt.recentProgressJson == null ||
          rebuilt.longTermProgressJson == null) {
        throw StateError('Progress cache rebuild failed');
      }

      final recent = RecentProgressCacheCodec.decode(
        rebuilt.recentProgressJson!,
      );
      final recentWindow = RecentWindowCacheCodec.decode(
        rebuilt.recentWindowJson,
      );

      final longTerm = LongTermProgressCacheCodec.decode(
        rebuilt.longTermProgressJson!,
      );

      if (recent.exerciseId != exerciseId ||
          longTerm.exerciseId != exerciseId ||
          recentWindow.length != recent.sessionCount ||
          recentWindow.any(
                (summary) => summary.exerciseId != exerciseId,
          )
      ) {
        throw StateError('Progress cache is out of sync');
      }

      return (recent: recent, longTerm: longTerm,recentWindow:recentWindow);
    });
  }

}
