import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_data_source.dart';
import '../mappers/exercise_set_mapper.dart';
import '../mappers/workout_exercise_mapper.dart';
import '../mappers/workout_session_mapper.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource localDataSource;

  WorkoutRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    final sessionCompanion =
    WorkoutSessionMapper.toCompanion(session);

    final exerciseCompanions = session.exercises
        .map(
          (exercise) => WorkoutExerciseMapper.toCompanion(
        exercise,
        sessionId: session.id,
      ),
    ).toList();

    final setCompanions = session.exercises
        .expand(
          (exercise) => exercise.sets.map(
            (set) => ExerciseSetMapper.toCompanion(
          set,
          workoutExerciseId: exercise.id,
        ),
      ),
    ).toList();

    await localDataSource.upsertWorkoutSession(
      session: sessionCompanion,
      exercises: exerciseCompanions,
      sets: setCompanions,
    );
  }

  @override
  Future<WorkoutSession?> getWorkoutSessionById(String id) async {
    final sessionRecord =
    await localDataSource.getWorkoutSessionById(id);

    if (sessionRecord == null) {
      return null;
    }

    final exerciseRecords =
    await localDataSource.getWorkoutExercisesBySessionId(id);

    final exercises = <WorkoutExercise>[];

    for (final exerciseRecord in exerciseRecords) {
      final setRecords =
      await localDataSource.getExerciseSetsByWorkoutExerciseId(
        exerciseRecord.id,
      );

      final exercise = WorkoutExerciseMapper.toDomain(
        exerciseRecord,
        setRecords,
      );

      exercises.add(exercise);
    }

    return WorkoutSessionMapper.toDomain(
      sessionRecord,
      exercises,
    );
  }
}