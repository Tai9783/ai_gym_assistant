import 'package:injectable/injectable.dart';

import '../../domain/entities/exercise_definition.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_local_data_source.dart';
import '../mappers/exercise_definition_mapper.dart';

@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseLocalDataSource localDataSource;

  ExerciseRepositoryImpl(this.localDataSource);

  @override
  Future<List<ExerciseDefinition>> getAllExercises() async {
    await localDataSource.seedDefaultExercisesIfEmpty();

    final records = await localDataSource.getAllExercises();

    return records.map(ExerciseDefinitionMapper.toDomain).toList();
  }
}
