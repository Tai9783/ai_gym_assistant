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

      // Check if the exercise exists in the allowed catalog.
      if (!allowedIds.contains(exerciseId)) {
        throw FormatException('Exercise is not allowed: $exerciseId');
      }

      // Check duplicate exercises.
      if (!returnedIds.add(exerciseId)) {
        throw FormatException('Duplicate exercise: $exerciseId');
      }

      // Each exercise must have at least one set.
      if (exercise.sets.isEmpty) {
        throw FormatException('Exercise has no sets: $exerciseId');
      }

      for (final set in exercise.sets) {
        // Weight must be a valid non-negative number.
        if (!set.suggestedWeight.isFinite || set.suggestedWeight < 0) {
          throw FormatException('Invalid weight for $exerciseId');
        }

        // Reps must be greater than zero.
        if (set.suggestedReps <= 0) {
          throw FormatException('Invalid reps for $exerciseId');
        }
      }
    }

    // If the user selected exercises,
    // Gemini must return exactly those exercises.
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
