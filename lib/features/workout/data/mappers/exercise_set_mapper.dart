import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/exercise_set.dart';

class ExerciseSetMapper {
  // Database -> Domain
  static ExerciseSet toDomain(ExerciseSetRecord record) {
    return ExerciseSet(
      id: record.id,
      setNumber: record.setNumber,
      suggestedWeight: record.suggestedWeight,
      suggestedReps: record.suggestedReps,
      actualWeight: record.actualWeight,
      actualReps: record.actualReps,
      status: ExerciseSetStatus.values.byName(record.status),
      note: record.note,
    );
  }

  // Domain -> Database
  static ExerciseSetsCompanion toCompanion(
      ExerciseSet entity, {
        required String workoutExerciseId,
      }) {
    return ExerciseSetsCompanion.insert(
      id: entity.id,
      workoutExerciseId: workoutExerciseId,
      setNumber: entity.setNumber,
      suggestedWeight: Value(entity.suggestedWeight),
      suggestedReps: Value(entity.suggestedReps),
      actualWeight: Value(entity.actualWeight),
      actualReps: Value(entity.actualReps),
      status: entity.status.name,
      note: Value(entity.note),
    );
  }
}