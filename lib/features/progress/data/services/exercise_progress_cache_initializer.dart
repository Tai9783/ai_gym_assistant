
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/exercise_session_summary.dart';
import '../../domain/services/recent_progress_analyzer.dart';
import '../../domain/services/long_term_progress_analyzer.dart';

import '../constants/progress_cache_version.dart';
import '../datasources/exercise_progress_cache_local_data_source.dart';
import '../mapper/recent_progress_cache_codec.dart';
import '../mapper/long_term_progress_cache_codec.dart';
import '../mapper/recent_window_cache_codec.dart';
import '../mapper/long_term_state_cache_codec.dart';

import 'long_term_aggregate_state_updater.dart';
@lazySingleton
class ExerciseProgressCacheInitializer {
  final ExerciseProgressCacheLocalDataSource _dataSource;
  final RecentProgressAnalyzer _recentAnalyzer;
  final LongTermProgressAnalyzer _longTermAnalyzer;
  final LongTermAggregateStateUpdater _stateUpdater;

  const ExerciseProgressCacheInitializer({
    required ExerciseProgressCacheLocalDataSource dataSource,
    required RecentProgressAnalyzer recentAnalyzer,
    required LongTermProgressAnalyzer longTermAnalyzer,
    required LongTermAggregateStateUpdater stateUpdater,
  })  : _dataSource = dataSource,
        _recentAnalyzer = recentAnalyzer,
        _longTermAnalyzer = longTermAnalyzer,
        _stateUpdater = stateUpdater;

  Future<void> initialize({
    required String exerciseId,
    required List<ExerciseSessionSummary> historySummaries,
  }) async {
    //Không tạo cache nếu bài tập chưa có History.
    if (historySummaries.isEmpty) return;

    if (historySummaries.any(
          (summary) => summary.exerciseId != exerciseId,
    )) {
      throw ArgumentError('Exercise ID mismatch');
    }

    final ordered = [...historySummaries]
      ..sort(
            (a, b) => a.performedAt.compareTo(b.performedAt),
      );

    //Tính Recent và Long-term bằng Analyzer cũ.
    final recent = _recentAnalyzer.analyze(
      exerciseId: exerciseId,
      summaries: ordered,
    );

    final longTerm = _longTermAnalyzer.analyze(
      exerciseId: exerciseId,
      summaries: ordered,
    );

    if (recent == null || longTerm == null) {
      throw StateError('Cannot initialize progress cache');
    }

    //Tạo Long-term State từ các Summary cũ.
    var state = const LongTermAggregateState.empty();

    for (final summary in ordered) {
      state = _stateUpdater.update(
        previous: state,
        newSummary: summary,
      );
    }

    final limit = RecentProgressAnalyzer.recentSessionLimit;

    final recentWindow = ordered.length <= limit
        ? ordered
        : ordered.sublist(ordered.length - limit);

    await _dataSource.upsert(
      ExerciseProgressCachesCompanion.insert(
        exerciseId: exerciseId,
        recentProgressJson: Value(
          RecentProgressCacheCodec.encode(recent),
        ),
        longTermProgressJson: Value(
          LongTermProgressCacheCodec.encode(longTerm),
        ),
        recentWindowJson:
        RecentWindowCacheCodec.encode(recentWindow),
        longTermStateJson:
        LongTermStateCacheCodec.encode(state),
        lastProcessedSessionId: Value(
          ordered.last.sessionId,
        ),
        calculationVersion: const Value(ProgressCacheVersion.current),
        needsRebuild: const Value(false),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
