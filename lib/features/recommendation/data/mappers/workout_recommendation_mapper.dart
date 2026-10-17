
import '../../domain/entities/workout_recommendation.dart';

class WorkoutRecommendationMapper {
  static WorkoutRecommendation fromJson(
      Map<String, dynamic> json,
      ) {
    final rawExercises = json['exercises'];

    if (rawExercises is! List) {
      throw const FormatException('Invalid exercises');
    }

    final exercises = rawExercises.map((rawExercise) {
      if (rawExercise is! Map) {
        throw const FormatException('Invalid exercise');
      }

      final exerciseId = rawExercise['exerciseId'];
      final rawSets = rawExercise['sets'];

      if (exerciseId is! String || rawSets is! List) {
        throw const FormatException('Invalid exercise data');
      }

      final sets = rawSets.map((rawSet) {
        if (rawSet is! Map) {
          throw const FormatException('Invalid set');
        }

        final weight = rawSet['suggestedWeight'];
        final reps = rawSet['suggestedReps'];

        if (weight is! num || reps is! int) {
          throw const FormatException('Invalid set data');
        }

        return RecommendedSet(
          suggestedWeight: weight.toDouble(),
          suggestedReps: reps,
        );
      }).toList();

      return RecommendedExercise(
        exerciseId: exerciseId,
        sets: sets,
      );
    }).toList();

    return WorkoutRecommendation(
      exercises: exercises,
    );
  }
}
