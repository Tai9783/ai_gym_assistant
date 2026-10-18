
import '../../domain/entities/exercise_definition.dart';
import '../../../recommendation/domain/entities/workout_request.dart';

bool isExerciseAllowedForFocus(
    ExerciseDefinition exercise,
    WorkoutFocus focus,
    ) {
  if (focus == WorkoutFocus.fullBody) {
    return true;
  }

  return switch (focus) {
    WorkoutFocus.chest =>
    exercise.muscleGroup == MuscleGroup.chest,

    WorkoutFocus.back =>
    exercise.muscleGroup == MuscleGroup.back,

    WorkoutFocus.legs =>
    exercise.muscleGroup == MuscleGroup.legs,

    WorkoutFocus.shoulders =>
    exercise.muscleGroup == MuscleGroup.shoulders,

    WorkoutFocus.arms =>
    exercise.muscleGroup == MuscleGroup.arms,

    WorkoutFocus.fullBody => true,
  };
}

List<ExerciseDefinition> filterExercisesByFocus(
    List<ExerciseDefinition> exercises,
    WorkoutFocus focus,
    ) {
  return exercises
      .where(
        (exercise) =>
        isExerciseAllowedForFocus(exercise, focus),
  )
      .toList();
}
