import 'package:uuid/uuid.dart';

import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout_exercise.dart';
import '../models/manual_workout_target.dart';

class ManualWorkoutMapper {
  static List<WorkoutExercise> toWorkoutExercises(
      List<ManualExerciseTarget> targets,
      ) {
    const uuid = Uuid();

    final workoutExercises = <WorkoutExercise>[];

    for (var i = 0; i < targets.length; i++) {
      final target = targets[i];

      final workoutSets = <ExerciseSet>[];

      for (var j = 0; j < target.sets.length; j++) {
        final targetSet = target.sets[j];

        workoutSets.add(
          ExerciseSet(
            id: uuid.v4(),
            setNumber: j + 1,
            suggestedWeight: targetSet.weight,
            suggestedReps: targetSet.reps,
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
          exerciseId: target.exerciseId,
          order: i + 1,
          sets: workoutSets,
        ),
      );
    }

    return workoutExercises;
  }
}