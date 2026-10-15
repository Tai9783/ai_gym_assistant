import '../entities/exercise_definition.dart';

abstract class ExerciseRepository {
  Future<List<ExerciseDefinition>> getAllExercises();
}