import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/progress/domain/entities/exercise_session_summary.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/session_target_classifier.dart';

void main() {
  late SessionTargetClassifier classifier;

  setUp(() {
    classifier = SessionTargetClassifier();
  });

  test('should return hit when all sets meet their targets', () {
    // Arrange
    final summary = ExerciseSessionSummary(
      sessionId: 'session_1',
      exerciseId: 'bench_press',
      performedAt: DateTime(2026, 10, 16),

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
    );

    final result = classifier.classify(summary);

    expect(result, SessionTargetResult.hit);
  });
  test('should return miss when at least one set is under target', () {
    final summary = ExerciseSessionSummary(
      sessionId: 'session_2',
      exerciseId: 'bench_press',
      performedAt: DateTime(2026, 10, 16),

      plannedSetCount: 3,
      completedSetCount: 3,
      skippedSetCount: 0,

      suggestedTotalReps: 24,
      actualTotalReps: 23,

      suggestedVolume: 960,
      actualVolume: 920,

      suggestedMaxWeight: 40,
      actualMaxWeight: 40,

      targetHitSetCount: 2,
      underTargetSetCount: 1,
      underTargetSetNumbers: const [3],
    );

    final result = classifier.classify(summary);

    expect(result, SessionTargetResult.miss);
  });
  test('should return unknown when some completed sets have no target', () {
    final summary = ExerciseSessionSummary(
      sessionId: 'session_3',
      exerciseId: 'bench_press',
      performedAt: DateTime(2026, 10, 16),

      plannedSetCount: 3,
      completedSetCount: 3,
      skippedSetCount: 0,

      suggestedTotalReps: 16,
      actualTotalReps: 24,

      suggestedVolume: 640,
      actualVolume: 960,

      suggestedMaxWeight: 40,
      actualMaxWeight: 40,

      targetHitSetCount: 2,
      underTargetSetCount: 0,
      underTargetSetNumbers: const [],
    );

    final result = classifier.classify(summary);

    expect(result, SessionTargetResult.unknown);
  });
}
