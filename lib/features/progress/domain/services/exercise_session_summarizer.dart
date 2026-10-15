import '../../../workout/domain/entities/exercise_set.dart';
import '../../../workout/domain/entities/workout_exercise.dart';
import '../../../workout/domain/entities/workout_session.dart';
import '../entities/exercise_session_summary.dart';

class ExerciseSessionSummarizer {
  ExerciseSessionSummary summarize({
    required WorkoutSession session,
    required WorkoutExercise exercise,
  }) {
    final plannedSetCount = exercise.sets.length;

    final completedSetCount = exercise.sets
        .where((set) => set.status == ExerciseSetStatus.completed)
        .length;

    final skippedSetCount = exercise.sets
        .where((set) => set.status == ExerciseSetStatus.skipped)
        .length;

    final suggestedTotalReps = exercise.sets.fold<int>(
      0, (total, set) => total + (set.suggestedReps ?? 0),
    );

    final actualTotalReps = exercise.sets.fold<int>(
      0, (total, set) => total + (set.actualReps ?? 0));

    final suggestedVolume = exercise.sets.fold<double>(
      0, (total, set) => total + (set.suggestedWeight ?? 0) * (set.suggestedReps ?? 0),
    );

    final actualVolume = exercise.sets.fold<double>(
      0, (total, set) => total + (set.actualWeight ?? 0) * (set.actualReps ?? 0),
    );

    final suggestedMaxWeight = exercise.sets.fold<double?>(
      null,
          (maxWeight, set) {
        final weight = set.suggestedWeight;

        if (weight == null) {
          return maxWeight;
        }

        if (maxWeight == null || weight > maxWeight) {
          return weight;
        }

        return maxWeight;
      },
    );

    final actualMaxWeight = exercise.sets.fold<double?>(
      null,
          (maxWeight, set) {
        final weight = set.actualWeight;

        if (weight == null) {
          return maxWeight;
        }

        if (maxWeight == null || weight > maxWeight) {
          return weight;
        }

        return maxWeight;
      },
    );
    int targetHitSetCount = 0;
    int underTargetSetCount = 0;
    final underTargetSetNumbers = <int>[];

    for (final set in exercise.sets) {
      if (set.status != ExerciseSetStatus.completed ||
          !_hasSuggestedTarget(set)) {
        continue;
      }

      if (_isTargetHit(set)) {
        targetHitSetCount++;
      } else {
        underTargetSetCount++;
        underTargetSetNumbers.add(set.setNumber);
      }
    }

    return ExerciseSessionSummary(
      sessionId: session.id,
      exerciseId: exercise.exerciseId,
      performedAt: session.startedAt,

      plannedSetCount: plannedSetCount,
      completedSetCount: completedSetCount,
      skippedSetCount: skippedSetCount,

      suggestedTotalReps: suggestedTotalReps,
      actualTotalReps: actualTotalReps,

      suggestedVolume: suggestedVolume,
      actualVolume: actualVolume,

      suggestedMaxWeight: suggestedMaxWeight,
      actualMaxWeight: actualMaxWeight,

      targetHitSetCount: targetHitSetCount,
      underTargetSetCount: underTargetSetCount,
      underTargetSetNumbers: underTargetSetNumbers,
    );
  }

  bool _hasSuggestedTarget(ExerciseSet set) {
    return set.suggestedWeight != null ||
        set.suggestedReps != null;
  }

  // - Only completed sets are evaluated.
  // - Skipped/pending sets are not considered hit or under target.
  // - If suggested weight exists, actual weight must be >= suggested weight.
  // - If suggested reps exists, actual reps must be >= suggested reps.
  // - All existing targets must be reached for the set to be considered HIT.
  // - If at least one existing target is not reached, the set is UNDER target.
  // Target 40kg x 8, Actual 40kg x 8     -> HIT
  // Target 40kg x 8, Actual 42.5kg x 8   -> HIT
  // Target 40kg x 8, Actual 40kg x 7     -> UNDER
  // Target 40kg x 8, Actual 35kg x 10    -> UNDER
  // Target null x 12, Actual null x 12   -> HIT
  bool _isTargetHit(ExerciseSet set) {
    final suggestedWeight = set.suggestedWeight;
    final suggestedReps = set.suggestedReps;

    final actualWeight = set.actualWeight;
    final actualReps = set.actualReps;

    final weightHit = suggestedWeight == null ||
        (actualWeight != null &&
            actualWeight >= suggestedWeight);

    final repsHit = suggestedReps == null ||
        (actualReps != null &&
            actualReps >= suggestedReps);

    return weightHit && repsHit;
  }
}