
import 'package:injectable/injectable.dart';

import '../../../profile/domain/entities/user_profile.dart';
import '../../../exercise_catalog/domain/entities/exercise_definition.dart';
import '../../../progress/domain/usecases/get_exercise_progress.dart';
import '../entities/ai_context.dart';
import '../entities/workout_request.dart';

@lazySingleton
class AiContextBuilder {
  AiContext build({
    required WorkoutRequest request,
    required List<ExerciseDefinition> exercises,
    required Map<String, ExerciseProgressResult> progressByExerciseId,
    UserProfile? profile,
  }) {
    final exerciseContexts = <AiExerciseContext>[];

    for (final exercise in exercises) {
      final progress = progressByExerciseId[exercise.id];

      if (progress == null) {
        throw StateError(
          'Missing progress result for ${exercise.id}',
        );
      }

      exerciseContexts.add(
        AiExerciseContext(
          exercise: exercise,
          recent: progress.recent,
          longTerm: progress.longTerm,
        ),
      );
    }

    return AiContext(
      request: request,
      profile: profile,
      exercises: exerciseContexts,
    );
  }
}
