import 'package:injectable/injectable.dart';

import '../../../exercise_catalog/domain/entities/exercise_definition.dart';
import '../../../exercise_catalog/domain/usecases/get_exercises.dart';
import '../../../profile/domain/usecases/get_user_profile.dart';
import '../../../progress/domain/usecases/get_exercise_progress.dart';
import '../entities/ai_context.dart';
import '../entities/workout_request.dart';
import '../services/ai_context_builder.dart';

@lazySingleton
class PrepareAiContext {
  final GetExercises _getExercises;
  final GetExerciseProgress _getExerciseProgress;
  final AiContextBuilder _builder;
  final GetUserProfile _getUserProfile;

  PrepareAiContext(
    this._getExercises,
    this._getExerciseProgress,
    this._builder,
    this._getUserProfile,
  );

  Future<AiContext> call({required WorkoutRequest request}) async {
    // Read the list of exercises from the Catalog.
    final catalogExercises = await _getExercises();

    final exercises = <ExerciseDefinition>[];

    //Identify the exercises that are permitted to be proposed.
    if (request.exerciseIds.isNotEmpty) {
      final exerciseById = {
        for (final exercise in catalogExercises) exercise.id: exercise,
      };

      for (final id in request.exerciseIds.toSet()) {
        final exercise = exerciseById[id];

        if (exercise == null) {
          throw StateError('Exercise not found: $id');
        }
        //TH1: The user selects a specific exercise.
        exercises.add(exercise);
      }
    } else {
      // TH2: The list has been filtered based on focus.
      exercises.addAll(
        catalogExercises.where(
          (exercise) =>
              request.focus.name == 'fullBody' ||
              exercise.muscleGroup.name == request.focus.name,
        ),
      );
    }

    if (exercises.isEmpty) {
      throw StateError('No exercises available');
    }

    // Get Recent + LongTerm for each exercise.
    final progressByExerciseId = <String, ExerciseProgressResult>{};

    for (final exercise in exercises) {
      final progress = await _getExerciseProgress(exerciseId: exercise.id);

      progressByExerciseId[exercise.id] = progress;
    }
    final profile = await _getUserProfile();

    return _builder.build(
      request: request,
      profile: profile,
      exercises: exercises,
      progressByExerciseId: progressByExerciseId,
    );
  }
}
