import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_session.dart';

class WorkoutSessionMapper {

  static WorkoutSession toDomain(
      WorkoutSessionRecord record,
      List<WorkoutExercise> exercises,
      ) {
    return WorkoutSession(
      id: record.id,
      startedAt: record.startedAt,
      endedAt: record.endedAt,
      status: WorkoutSessionStatus.values.byName(record.status),
      exercises: exercises,
    );
  }

  static WorkoutSessionsCompanion toCompanion(
      WorkoutSession entity,
      ) {
    return WorkoutSessionsCompanion.insert(
      id: entity.id,
      startedAt: entity.startedAt,
      endedAt: Value(entity.endedAt),
      status: entity.status.name,
    );
  }
}