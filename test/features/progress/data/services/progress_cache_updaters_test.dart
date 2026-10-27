
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/progress/domain/entities/exercise_session_summary.dart';
import 'package:ai_gym_assistant/features/progress/domain/entities/long_term_exercise_progress.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/recent_progress_analyzer.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_progress_analyzer.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_trend_calculator.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/session_target_classifier.dart';

import 'package:ai_gym_assistant/features/progress/data/mapper/recent_progress_cache_codec.dart';
import 'package:ai_gym_assistant/features/progress/data/mapper/long_term_progress_cache_codec.dart';
import 'package:ai_gym_assistant/features/progress/data/mapper/long_term_state_cache_codec.dart';

import 'package:ai_gym_assistant/features/progress/data/services/recent_progress_cache_updater.dart';
import 'package:ai_gym_assistant/features/progress/data/services/long_term_aggregate_state_updater.dart';
import 'package:ai_gym_assistant/features/progress/data/services/long_term_progress_result_updater.dart';

void main() {
  test('incremental progress matches full-history analyzers', () {
    const exerciseId = 'squat_001';

    final classifier = SessionTargetClassifier();
    final trendCalculator = LongTermTrendCalculator();

    final recentAnalyzer = RecentProgressAnalyzer(classifier,trendCalculator);
    final longTermAnalyzer = LongTermProgressAnalyzer(
      classifier,
      trendCalculator,
    );

    final recentUpdater = RecentProgressCacheUpdater(recentAnalyzer);
    const stateUpdater = LongTermAggregateStateUpdater();
    final resultUpdater = LongTermProgressResultUpdater(
      classifier,
      trendCalculator,
    );

    final history = <ExerciseSessionSummary>[];
    var recentWindow = <ExerciseSessionSummary>[];
    var longTermState = const LongTermAggregateState.empty();
    LongTermExerciseProgress? longTermProgress;

    // Mô phỏng 12 buổi Squat liên tiếp.
    for (var i = 0; i < 12; i++) {
      final completedSets = i == 6 ? 0 : 3;
      final hitSets = completedSets == 0
          ? 0
          : (i % 4 == 0 ? 1 : 3);
      final underSets = completedSets - hitSets;

      final summary = ExerciseSessionSummary(
        sessionId: 'session_$i',
        exerciseId: exerciseId,
        performedAt: DateTime.utc(2026, 10, i + 1),
        plannedSetCount: 3,
        completedSetCount: completedSets,
        skippedSetCount: 3 - completedSets,
        suggestedTotalReps: 30,
        actualTotalReps: completedSets == 0 ? 0 : 27,
        suggestedVolume: 1500.0,
        actualVolume: completedSets == 0 ? 0.0 : 1100.0 + i * 42,
        suggestedMaxWeight: 50.0,
        actualMaxWeight: completedSets == 0 || i == 2
            ? null
            : 40.0 + i * 2.5,
        targetHitSetCount: hitSets,
        underTargetSetCount: underSets,
        underTargetSetNumbers: List.generate(
          underSets,
              (index) => index + 1,
        ),
      );

      history.add(summary);

      // Cách mới: chỉ xử lý Summary vừa thêm.
      final recentResult = recentUpdater.update(
        exerciseId: exerciseId,
        previousWindow: recentWindow,
        newSummary: summary,
      );
      recentWindow = recentResult.window;

      longTermState = stateUpdater.update(
        previous: longTermState,
        newSummary: summary,
      );

      longTermProgress = resultUpdater.update(
        previous: longTermProgress,
        state: longTermState,
        newSummary: summary,
      );

      // Cách cũ: tính lại từ toàn bộ History.
      final expectedRecent = recentAnalyzer.analyze(
        exerciseId: exerciseId,
        summaries: history,
      )!;

      final expectedLongTerm = longTermAnalyzer.analyze(
        exerciseId: exerciseId,
        summaries: history,
      )!;

      // So sánh tất cả các trường được lưu bằng Codec.
      expect(
        RecentProgressCacheCodec.encode(recentResult.progress),
        RecentProgressCacheCodec.encode(expectedRecent),
        reason: 'Recent mismatch after session ${i + 1}',
      );

      expect(
        LongTermProgressCacheCodec.encode(longTermProgress),
        LongTermProgressCacheCodec.encode(expectedLongTerm),
        reason: 'Long-term mismatch after session ${i + 1}',
      );
    }
  });
}
