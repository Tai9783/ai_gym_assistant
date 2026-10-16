
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_gym_assistant/features/progress/domain/entities/exercise_session_summary.dart';
import 'package:ai_gym_assistant/features/progress/domain/entities/recent_exercise_progress.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_progress_analyzer.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_trend_calculator.dart';
import 'package:ai_gym_assistant/features/progress/domain/services/session_target_classifier.dart';

void main() {
  late LongTermProgressAnalyzer analyzer;

  setUp(() {
    analyzer = LongTermProgressAnalyzer(
      SessionTargetClassifier(),
      LongTermTrendCalculator(),
    );
  });

  test(
    'should analyze long-term exercise progress correctly',
        () {
      final summaries = <ExerciseSessionSummary>[
        makeSummary(
          day: 9,
          actualMaxWeight: 50,
          actualVolume: 1200,
          completedSetCount: 2,
          targetHitSetCount: 2,
        ),
        makeSummary(
          day: 1,
          actualMaxWeight: 40,
          actualVolume: 960,
        ),
        makeSummary(
          day: 7,
          actualMaxWeight: 47.5,
          actualVolume: 1140,
          targetHitSetCount: 2,
          underTargetSetCount: 1,
          underTargetSetNumbers: [3],
        ),
        makeSummary(
          day: 3,
          actualMaxWeight: 42.5,
          actualVolume: 1020,
        ),
        makeSummary(
          day: 5,
          actualMaxWeight: 45,
          actualVolume: 1080,
          targetHitSetCount: 0,
          hasTargets: false,
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

      expect(
        progress.firstPerformedAt,
        DateTime(2026, 10, 1),
      );

      expect(
        progress.lastPerformedAt,
        DateTime(2026, 10, 9),
      );

      expect(progress.hitSessionCount, 2);
      expect(progress.missedTargetSessionCount, 2);

      expect(
        progress.targetHitSetRate,
        closeTo(10 / 11, 0.0001),
      );

      expect(progress.bestActualMaxWeight, 50);

      expect(
        progress.weightTrend,
        ProgressTrend.increasing,
      );

      expect(
        progress.volumeTrend,
        ProgressTrend.increasing,
      );
    },
  );

  test(
    'should find best weight in the middle of history',
        () {
      final summaries = List<ExerciseSessionSummary>.generate(
        12,
            (index) {
          final day = index + 1;

          double weight;
          double volume;

          if (day <= 5) {
            weight = 40;
            volume = 960;
          } else if (day == 6) {
            weight = 100;
            volume = 3000;
          } else if (day == 7) {
            weight = 10;
            volume = 100;
          } else {
            weight = 50;
            volume = 960;
          }

          return makeSummary(
            day: day,
            actualMaxWeight: weight,
            actualVolume: volume,
          );
        },
      );

      final result = analyzer.analyze(
        exerciseId: 'bench_press',
        summaries: summaries,
      );

      expect(result, isNotNull);

      final progress = result!;

      expect(progress.sessionCount, 12);


      expect(progress.bestActualMaxWeight, 100);

      expect(
        progress.weightTrend,
        ProgressTrend.increasing,
      );

      expect(
        progress.volumeTrend,
        ProgressTrend.stable,
      );
    },
  );

  test(
    'should return null when summaries are empty',
        () {
      final result = analyzer.analyze(
        exerciseId: 'bench_press',
        summaries: [],
      );

      expect(result, isNull);
    },
  );

  test(
    'should return null when no exercise matches',
        () {
      final summaries = <ExerciseSessionSummary>[
        makeSummary(
          day: 1,
          exerciseId: 'squat',
        ),
      ];

      final result = analyzer.analyze(
        exerciseId: 'bench_press',
        summaries: summaries,
      );

      expect(result, isNull);
    },
  );

  test(
    'should return null hit rate when no sets can be evaluated',
        () {
      final summaries = <ExerciseSessionSummary>[
        makeSummary(
          day: 1,
          completedSetCount: 0,
          skippedSetCount: 3,
          targetHitSetCount: 0,
          actualMaxWeight: null,
          actualVolume: 0,
          hasTargets: false,
        ),
        makeSummary(
          day: 3,
          completedSetCount: 0,
          skippedSetCount: 3,
          targetHitSetCount: 0,
          actualMaxWeight: null,
          actualVolume: 0,
          hasTargets: false,
        ),
      ];

      final result = analyzer.analyze(
        exerciseId: 'bench_press',
        summaries: summaries,
      );

      expect(result, isNotNull);

      final progress = result!;

      expect(progress.sessionCount, 2);
      expect(progress.hitSessionCount, 0);
      expect(progress.missedTargetSessionCount, 0);

      expect(progress.targetHitSetRate, isNull);
      expect(progress.bestActualMaxWeight, isNull);

      expect(
        progress.weightTrend,
        ProgressTrend.insufficientData,
      );

      expect(
        progress.volumeTrend,
        ProgressTrend.insufficientData,
      );
    },
  );

  test(
    'should return insufficientData trends with only one session',
        () {
      final summaries = <ExerciseSessionSummary>[
        makeSummary(
          day: 1,
          actualMaxWeight: 40,
          actualVolume: 960,
        ),
      ];

      final result = analyzer.analyze(
        exerciseId: 'bench_press',
        summaries: summaries,
      );

      expect(result, isNotNull);

      final progress = result!;

      expect(progress.sessionCount, 1);
      expect(progress.hitSessionCount, 1);
      expect(progress.bestActualMaxWeight, 40);

      expect(
        progress.weightTrend,
        ProgressTrend.insufficientData,
      );

      expect(
        progress.volumeTrend,
        ProgressTrend.insufficientData,
      );
    },
  );
}

ExerciseSessionSummary makeSummary({
  required int day,
  String exerciseId = 'bench_press',
  int completedSetCount = 3,
  int skippedSetCount = 0,
  int targetHitSetCount = 3,
  int underTargetSetCount = 0,
  List<int> underTargetSetNumbers = const [],
  double? actualMaxWeight = 40,
  double actualVolume = 960,
  bool hasTargets = true,
}) {
  return ExerciseSessionSummary(
    sessionId: 'session_$day',
    exerciseId: exerciseId,
    performedAt: DateTime(2026, 10, day),

    plannedSetCount: 3,
    completedSetCount: completedSetCount,
    skippedSetCount: skippedSetCount,

    suggestedTotalReps: hasTargets ? 24 : 0,
    actualTotalReps: completedSetCount * 8,

    suggestedVolume: hasTargets ? 960 : 0,
    actualVolume: actualVolume,

    suggestedMaxWeight: hasTargets ? 40 : null,
    actualMaxWeight: actualMaxWeight,

    targetHitSetCount: targetHitSetCount,
    underTargetSetCount: underTargetSetCount,
    underTargetSetNumbers: underTargetSetNumbers,
  );
}
