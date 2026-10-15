import '../../domain/entities/exercise_definition.dart';

sealed class ExerciseCatalogState {
  const ExerciseCatalogState();
}

final class ExerciseCatalogInitial extends ExerciseCatalogState {
  const ExerciseCatalogInitial();
}

final class ExerciseCatalogLoading extends ExerciseCatalogState {
  const ExerciseCatalogLoading();
}

final class ExerciseCatalogLoaded extends ExerciseCatalogState {
  final List<ExerciseDefinition> exercises;

  const ExerciseCatalogLoaded({
    required this.exercises,
  });
}

final class ExerciseCatalogFailure extends ExerciseCatalogState {
  final String message;

  const ExerciseCatalogFailure({
    required this.message,
  });
}