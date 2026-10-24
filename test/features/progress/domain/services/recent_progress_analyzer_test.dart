import 'package:ai_gym_assistant/features/progress/domain/entities/progress_trend.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/session_target_classifier.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/progress/domain/entities/exercise_session_summary.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/recent_progress_analyzer.dart';

void main() {
  late RecentProgressAnalyzer analyzer;

  setUp(() {
    analyzer = RecentProgressAnalyzer(SessionTargetClassifier());
  });

  test('should analyze recent exercise progress correctly', () {
    final summaries = <ExerciseSessionSummary>[
      ExerciseSessionSummary(
        sessionId: 'session_1',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 1),

        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,

        suggestedTotalReps: 24,
        actualTotalReps: 24,

        suggestedVolume: 960,
        actualVolume: 960,

        suggestedMaxWeight: 40,
        actualMaxWeight: 40,

        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),

      ExerciseSessionSummary(
        sessionId: 'session_2',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 3),

        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,

        suggestedTotalReps: 24,
        actualTotalReps: 24,

        suggestedVolume: 960,
        actualVolume: 960,

        suggestedMaxWeight: 40,
        actualMaxWeight: 40,

        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),

      ExerciseSessionSummary(
        sessionId: 'session_3',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 5),

        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,

        suggestedTotalReps: 24,
        actualTotalReps: 24,

        suggestedVolume: 1020,
        actualVolume: 1020,

        suggestedMaxWeight: 42.5,
        actualMaxWeight: 42.5,

        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),

      ExerciseSessionSummary(
        sessionId: 'session_4',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 7),

        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,

        suggestedTotalReps: 24,
        actualTotalReps: 23,

        suggestedVolume: 1020,
        actualVolume: 977.5,

        suggestedMaxWeight: 42.5,
        actualMaxWeight: 42.5,

        targetHitSetCount: 2,
        underTargetSetCount: 1,
        underTargetSetNumbers: const [3],
      ),

      ExerciseSessionSummary(
        sessionId: 'session_5',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 9),

        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,

        suggestedTotalReps: 24,
        actualTotalReps: 22,

        suggestedVolume: 1080,
        actualVolume: 990,

        suggestedMaxWeight: 45,
        actualMaxWeight: 45,

        targetHitSetCount: 2,
        underTargetSetCount: 1,
        underTargetSetNumbers: const [3],
      ),
    ];

    final result = analyzer.analyze(
      exerciseId: 'bench_press',
      summaries: summaries,
    );

    expect(result, isNotNull);

    final progress = result!;

    expect(progress.exerciseId, 'bench_press');

    expect(progress.sessionCount, 5);

    expect(progress.windowStartAt, DateTime(2026, 10, 1));

    expect(progress.windowEndAt, DateTime(2026, 10, 9));
    expect(progress.latestSessionHitTarget, false);

    expect(progress.hitSessionCount, 3);

    expect(progress.missedTargetSessionCount, 2);

    expect(progress.currentMissStreak, 2);
    expect(progress.targetHitSetRate, closeTo(13 / 15, 0.0001));
    expect(progress.underTargetSetFrequency, {3: 2});
    expect(progress.latestSuggestedMaxWeight, 45);

    expect(progress.latestActualMaxWeight, 45);

    expect(progress.latestSuggestedTotalReps, 24);

    expect(progress.latestActualTotalReps, 22);
    expect(progress.weightTrend, ProgressTrend.increasing);

    expect(progress.volumeTrend, ProgressTrend.increasing);
  });
  test('should return null when no summary matches exerciseId', () {
    final summaries = <ExerciseSessionSummary>[
      ExerciseSessionSummary(
        sessionId: 'session_1',
        exerciseId: 'squat',
        performedAt: DateTime(2026, 10, 1),

        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,

        suggestedTotalReps: 24,
        actualTotalReps: 24,

        suggestedVolume: 1200,
        actualVolume: 1200,

        suggestedMaxWeight: 50,
        actualMaxWeight: 50,

        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
    ];

    final result = analyzer.analyze(
      exerciseId: 'bench_press',
      summaries: summaries,
    );

    expect(result, isNull);
  });
  test('should keep only the 5 most recent sessions', () {
    final summaries = <ExerciseSessionSummary>[
      ExerciseSessionSummary(
        sessionId: 'session_1',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 1),
        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,
        suggestedTotalReps: 24,
        actualTotalReps: 24,
        suggestedVolume: 960,
        actualVolume: 960,
        suggestedMaxWeight: 40,
        actualMaxWeight: 40,
        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
      ExerciseSessionSummary(
        sessionId: 'session_2',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 3),
        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,
        suggestedTotalReps: 24,
        actualTotalReps: 24,
        suggestedVolume: 960,
        actualVolume: 960,
        suggestedMaxWeight: 40,
        actualMaxWeight: 40,
        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
      ExerciseSessionSummary(
        sessionId: 'session_3',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 5),
        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,
        suggestedTotalReps: 24,
        actualTotalReps: 24,
        suggestedVolume: 1020,
        actualVolume: 1020,
        suggestedMaxWeight: 42.5,
        actualMaxWeight: 42.5,
        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
      ExerciseSessionSummary(
        sessionId: 'session_4',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 7),
        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,
        suggestedTotalReps: 24,
        actualTotalReps: 24,
        suggestedVolume: 1020,
        actualVolume: 1020,
        suggestedMaxWeight: 42.5,
        actualMaxWeight: 42.5,
        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
      ExerciseSessionSummary(
        sessionId: 'session_5',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 9),
        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,
        suggestedTotalReps: 24,
        actualTotalReps: 24,
        suggestedVolume: 1080,
        actualVolume: 1080,
        suggestedMaxWeight: 45,
        actualMaxWeight: 45,
        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
      ExerciseSessionSummary(
        sessionId: 'session_6',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 11),
        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,
        suggestedTotalReps: 24,
        actualTotalReps: 24,
        suggestedVolume: 1080,
        actualVolume: 1080,
        suggestedMaxWeight: 45,
        actualMaxWeight: 45,
        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
    ];

    final result = analyzer.analyze(
      exerciseId: 'bench_press',
      summaries: summaries,
    );

    expect(result, isNotNull);

    final progress = result!;

    expect(progress.sessionCount, 5);

    expect(progress.windowStartAt, DateTime(2026, 10, 3));

    expect(progress.windowEndAt, DateTime(2026, 10, 11));
  });
  test('should return insufficientData trend when only one session exists', () {
    final summaries = <ExerciseSessionSummary>[
      ExerciseSessionSummary(
        sessionId: 'session_1',
        exerciseId: 'bench_press',
        performedAt: DateTime(2026, 10, 1),

        plannedSetCount: 3,
        completedSetCount: 3,
        skippedSetCount: 0,

        suggestedTotalReps: 24,
        actualTotalReps: 24,

        suggestedVolume: 960,
        actualVolume: 960,

        suggestedMaxWeight: 40,
        actualMaxWeight: 40,

        targetHitSetCount: 3,
        underTargetSetCount: 0,
        underTargetSetNumbers: const [],
      ),
    ];

    final result = analyzer.analyze(
      exerciseId: 'bench_press',
      summaries: summaries,
    );

    expect(result, isNotNull);

    final progress = result!;

    expect(progress.weightTrend, ProgressTrend.insufficientData);

    expect(progress.volumeTrend, ProgressTrend.insufficientData);
  });
}
