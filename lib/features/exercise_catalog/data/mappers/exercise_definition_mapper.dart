import '../../../../core/database/app_database.dart';
import '../../domain/entities/exercise_definition.dart';

class ExerciseDefinitionMapper {
  static ExerciseDefinition toDomain(ExerciseDefinitionRecord record) {
    return ExerciseDefinition(
      id: record.id,
      name: record.name,
      muscleGroup: MuscleGroup.values.byName(record.muscleGroup),
    );
  }

  static ExerciseDefinitionsCompanion toCompanion(ExerciseDefinition entity) {
    return ExerciseDefinitionsCompanion.insert(
      id: entity.id,
      name: entity.name,
      muscleGroup: entity.muscleGroup.name,
    );
  }
}
