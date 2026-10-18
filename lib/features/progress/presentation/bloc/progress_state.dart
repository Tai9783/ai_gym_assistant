import '../../domain/entities/long_term_exercise_progress.dart';
import '../../domain/entities/recent_exercise_progress.dart';

sealed class ProgressState {
  const ProgressState();
}

final class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

final class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

final class ProgressEmpty extends ProgressState {
  const ProgressEmpty();
}

final class ProgressLoaded extends ProgressState {
  final List<String> exerciseIds;
  final Map<String, String> exerciseNames;
  final String selectedExerciseId;
  final RecentExerciseProgress? recent;
  final LongTermExerciseProgress? longTerm;

  const ProgressLoaded({
    required this.exerciseIds,
    required this.exerciseNames,
    required this.selectedExerciseId,
    required this.recent,
    required this.longTerm,
  });
}

final class ProgressFailure extends ProgressState {
  final String message;

  const ProgressFailure(this.message);
}
