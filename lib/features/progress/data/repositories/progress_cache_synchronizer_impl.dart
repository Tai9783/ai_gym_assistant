
import 'package:injectable/injectable.dart';

import '../../../workout/domain/entities/workout_session.dart';
import '../../../workout/domain/repositories/workout_repository.dart';

import '../../domain/entities/exercise_session_summary.dart';
import '../../domain/entities/long_term_exercise_progress.dart';
import '../../domain/entities/recent_exercise_progress.dart';
import '../../domain/repositories/progress_cache_synchronizer.dart';
import '../../domain/services/exercise_session_summarizer.dart';

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
      final exerciseIds = completedSession.exercises
          .map((exercise) => exercise.exerciseId)
          .toSet();

      for (final exerciseId in exerciseIds) {
        await _syncExercise(
          exerciseId: exerciseId,
          completedSession: completedSession,
        );
      }
    });
  }

  Future<void> _syncExercise({
    required String exerciseId,
    required WorkoutSession completedSession,
  }) async {
    final historyCount = await _workoutRepository
        .countCompletedWorkoutExercises(exerciseId);

    final cache = await _cacheDataSource.getByExerciseId(exerciseId);

    if (historyCount == 0) {
      throw StateError('Completed exercise not found in History');
    }

    LongTermExerciseProgress? cachedLongTerm;

    // Kiểm tra dữ liệu Cache hiện tại có đọc được không.
    if (cache != null &&
        !cache.needsRebuild &&
        cache.calculationVersion == 1 &&
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

    // Cache hợp lệ và đã đủ số lần tập.
    if (cachedLongTerm != null &&
        cachedLongTerm.sessionCount == historyCount) {
      return;
    }

    final matchingExercises = completedSession.exercises
        .where((exercise) => exercise.exerciseId == exerciseId)
        .toList();

    // Chỉ incremental khi chắc chắn chỉ thêm
    // một lần tập mới sau dữ liệu Cache hiện tại.
    if (cachedLongTerm != null &&
        cachedLongTerm.sessionCount + 1 == historyCount &&
        matchingExercises.length == 1 &&
        cache!.lastProcessedSessionId != completedSession.id) {
      final newSummary = _summarizer.summarize(
        session: completedSession,
        exercise: matchingExercises.single,
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
    await _rebuildExercise(exerciseId, historyCount);
  }

  Future<void> _rebuildExercise(
      String exerciseId,
      int expectedCount,
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

    if (summaries.length != expectedCount) {
      throw StateError('History count changed during cache rebuild');
    }

    await _initializer.initialize(
      exerciseId: exerciseId,
      historySummaries: summaries,
    );
  }

  @override
  Future<({
  RecentExerciseProgress? recent,
  LongTermExerciseProgress? longTerm,
  })> readValidProgress(String exerciseId) {
    return _cacheDataSource.runInTransaction(() async {
      //Đếm số lần tập thật trong History.
      final historyCount = await _workoutRepository
          .countCompletedWorkoutExercises(exerciseId);

      // Bài tập chưa có History thì không có Progress.
      if (historyCount == 0) {
        return (recent: null, longTerm: null);
      }

      //Đọc Cache hiện có.
      final cache = await _cacheDataSource.getByExerciseId(exerciseId);

      if (cache != null &&
          !cache.needsRebuild &&
          cache.calculationVersion == 1 &&
          cache.recentProgressJson != null &&
          cache.longTermProgressJson != null) {
        try {
          final recent = RecentProgressCacheCodec.decode(
            cache.recentProgressJson!,
          );

          final longTerm = LongTermProgressCacheCodec.decode(
            cache.longTermProgressJson!,
          );

          // Kiểm tra cả dữ liệu phục vụ incremental.
          RecentWindowCacheCodec.decode(cache.recentWindowJson);
          LongTermStateCacheCodec.decode(cache.longTermStateJson);

          if (recent.exerciseId == exerciseId &&
              longTerm.exerciseId == exerciseId &&
              longTerm.sessionCount == historyCount) {
            return (recent: recent, longTerm: longTerm);
          }
        } catch (_) {
          //Cache lỗi hoặc JSON hỏng: rebuild bên dưới.
        }
      }

      //Cache thiếu, lỗi hoặc chưa đồng bộ.
      await _rebuildExercise(exerciseId, historyCount);

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

      final longTerm = LongTermProgressCacheCodec.decode(
        rebuilt.longTermProgressJson!,
      );

      if (recent.exerciseId != exerciseId ||
          longTerm.exerciseId != exerciseId ||
          longTerm.sessionCount != historyCount) {
        throw StateError('Progress cache is out of sync');
      }

      return (recent: recent, longTerm: longTerm);
    });
  }

}
