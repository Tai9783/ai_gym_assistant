import 'package:ai_gym_assistant/features/exercise_catalog/domain/entities/exercise_definition.dart';
import 'package:ai_gym_assistant/features/progress/domain/entities/recent_exercise_progress.dart';
import 'package:ai_gym_assistant/features/progress/domain/entities/long_term_exercise_progress.dart';

import '../../../profile/domain/entities/user_profile.dart';
import 'workout_request.dart';

class AiContext {
  final WorkoutRequest request;
  final UserProfile? profile;
  final List<AiExerciseContext> exercises;

  const AiContext({
    required this.request,
    this.profile,
    required this.exercises,
  });
}

class AiExerciseContext {
  final ExerciseDefinition exercise;
  final RecentExerciseProgress? recent;
  final LongTermExerciseProgress? longTerm;

  const AiExerciseContext({
    required this.exercise,
    required this.recent,
    required this.longTerm,
  });
}
