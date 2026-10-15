import 'package:injectable/injectable.dart';

import '../entities/exercise_definition.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class GetExercises {
  final ExerciseRepository repository;

  GetExercises(this.repository);

  Future<List<ExerciseDefinition>> call() {
    return repository.getAllExercises();
  }
}