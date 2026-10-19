import 'package:injectable/injectable.dart';

import '../entities/ai_context.dart';
import '../entities/workout_recommendation.dart';

@lazySingleton
class RecommendationValidator {
  void validate({
    required AiContext context,
    required WorkoutRecommendation recommendation,
  }) {
    // Get allowed exercise IDs from AI Context.
    final allowedIds = context.exercises
        .map((item) => item.exercise.id)
        .toSet();

    if (recommendation.exercises.isEmpty) {
      throw const FormatException('Recommendation has no exercises');
    }

    final returnedIds = <String>{};

    for (final exercise in recommendation.exercises) {
      final exerciseId = exercise.exerciseId;

      if (!allowedIds.contains(exerciseId)) {
        throw FormatException('Exercise is not allowed: $exerciseId');
      }

      if (!returnedIds.add(exerciseId)) {
        throw FormatException('Duplicate exercise: $exerciseId');
      }

      if (exercise.sets.isEmpty) {
        throw FormatException('Exercise has no sets: $exerciseId');
      }

      for (final set in exercise.sets) {
        if (!set.suggestedWeight.isFinite || set.suggestedWeight < 0) {
          throw FormatException('Invalid weight for $exerciseId');
        }

        if (set.suggestedReps <= 0) {
          throw FormatException('Invalid reps for $exerciseId');
        }
      }
    }


    if (context.request.exerciseIds.isNotEmpty) {
      final selectedIds = context.request.exerciseIds.toSet();

      if (returnedIds.length != selectedIds.length ||
          !returnedIds.containsAll(selectedIds)) {
        throw const FormatException(
          'Recommendation does not match selected exercises',
        );
      }
    }
  }
}
