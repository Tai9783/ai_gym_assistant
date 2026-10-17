import '../../../../core/database/app_database.dart';
import '../../domain/entities/workout_exercise.dart';
import 'exercise_set_mapper.dart';

class WorkoutExerciseMapper {
  static WorkoutExercise toDomain(
    WorkoutExerciseRecord record,
    List<ExerciseSetRecord> setRecords,
  ) {
    return WorkoutExercise(
      id: record.id,
      exerciseId: record.exerciseId,
      order: record.order,
      sets: setRecords.map(ExerciseSetMapper.toDomain).toList(),
    );
  }

  static WorkoutExercisesCompanion toCompanion(
    WorkoutExercise entity, {
    required String sessionId,
  }) {
    return WorkoutExercisesCompanion.insert(
      id: entity.id,
      sessionId: sessionId,
      exerciseId: entity.exerciseId,
      order: entity.order,
    );
  }
}
