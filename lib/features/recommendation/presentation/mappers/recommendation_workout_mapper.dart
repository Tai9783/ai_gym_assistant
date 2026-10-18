
import 'package:uuid/uuid.dart';

import '../../../workout/domain/entities/exercise_set.dart';
import '../../../workout/domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_recommendation.dart';

class RecommendationWorkoutMapper {
  static List<WorkoutExercise> toWorkoutExercises(
      WorkoutRecommendation recommendation,
      ) {
    const uuid = Uuid();

    final workoutExercises = <WorkoutExercise>[];

    for (var i = 0; i < recommendation.exercises.length; i++) {
      final recommendedExercise = recommendation.exercises[i];

      final workoutSets = <ExerciseSet>[];

      for (var j = 0; j < recommendedExercise.sets.length; j++) {
        final recommendedSet = recommendedExercise.sets[j];

        workoutSets.add(
          ExerciseSet(
            id: uuid.v4(),
            setNumber: j + 1,
            suggestedWeight: recommendedSet.suggestedWeight,
            suggestedReps: recommendedSet.suggestedReps,
            actualWeight: null,
            actualReps: null,
            status: ExerciseSetStatus.pending,
            note: null,
          ),
        );
      }

      workoutExercises.add(
        WorkoutExercise(
          id: uuid.v4(),
          exerciseId: recommendedExercise.exerciseId,
          order: i + 1,
          sets: workoutSets,
        ),
      );
    }

    return workoutExercises;
  }
}
