
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/exercise_session_summary.dart';

import '../datasources/exercise_progress_cache_local_data_source.dart';
import '../mapper/recent_window_cache_codec.dart';
import '../mapper/recent_progress_cache_codec.dart';
import '../mapper/long_term_state_cache_codec.dart';
import '../mapper/long_term_progress_cache_codec.dart';

import 'recent_progress_cache_updater.dart';
import 'long_term_aggregate_state_updater.dart';
import 'long_term_progress_result_updater.dart';

@lazySingleton
class ExerciseProgressCacheUpdater {
  final ExerciseProgressCacheLocalDataSource _dataSource;
  final RecentProgressCacheUpdater _recentUpdater;
  final LongTermAggregateStateUpdater _stateUpdater;
  final LongTermProgressResultUpdater _resultUpdater;

  const ExerciseProgressCacheUpdater({
    required ExerciseProgressCacheLocalDataSource dataSource,
    required RecentProgressCacheUpdater recentUpdater,
    required LongTermAggregateStateUpdater stateUpdater,
    required LongTermProgressResultUpdater resultUpdater,
  }) : _dataSource = dataSource,
        _recentUpdater = recentUpdater,
        _stateUpdater = stateUpdater,
        _resultUpdater = resultUpdater;

  Future<void> update({
    required ExerciseSessionSummary newSummary,
  }) async {
    final exerciseId = newSummary.exerciseId;

    //Đọc cache hiện tại của bài tập.
    final cache = await _dataSource.getByExerciseId(exerciseId);

    if (cache == null) {
      throw StateError('Progress cache not initialized');
    }

    //Chỉ cập nhật cache có phiên bản hợp lệ.
    if (cache.needsRebuild || cache.calculationVersion != 1) {
      throw StateError('Progress cache requires rebuild');
    }

    if (cache.recentProgressJson == null ||
        cache.longTermProgressJson == null) {
      throw StateError('Progress cache is incomplete');
    }

    //Lấy dữ liệu cũ từ JSON.
    final oldWindow = RecentWindowCacheCodec.decode(
      cache.recentWindowJson,
    );

    final oldState = LongTermStateCacheCodec.decode(
      cache.longTermStateJson,
    );

    final oldLongTerm = LongTermProgressCacheCodec.decode(
      cache.longTermProgressJson!,
    );

    //Không cộng lại buổi cũ hoặc buổi sai thứ tự.
    if (!newSummary.performedAt.isAfter(oldLongTerm.lastPerformedAt)) {
      throw StateError('Out-of-order or duplicate session');
    }

    //Cập nhật Recent Progress.
    final recentResult = _recentUpdater.update(
      exerciseId: exerciseId,
      previousWindow: oldWindow,
      newSummary: newSummary,
    );

    //Cập nhật Long-term State.
    final newState = _stateUpdater.update(
      previous: oldState,
      newSummary: newSummary,
    );

    //Tính Long-term Progress từ State mới.
    final newLongTerm = _resultUpdater.update(
      previous: oldLongTerm,
      state: newState,
      newSummary: newSummary,
    );

    await _dataSource.upsert(
      ExerciseProgressCachesCompanion.insert(
        exerciseId: exerciseId,
        recentProgressJson: Value(
          RecentProgressCacheCodec.encode(recentResult.progress),
        ),
        longTermProgressJson: Value(
          LongTermProgressCacheCodec.encode(newLongTerm),
        ),
        recentWindowJson:
        RecentWindowCacheCodec.encode(recentResult.window),
        longTermStateJson:
        LongTermStateCacheCodec.encode(newState),
        lastProcessedSessionId: Value(newSummary.sessionId),
        calculationVersion: const Value(1),
        needsRebuild: const Value(false),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
