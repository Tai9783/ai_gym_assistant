import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/finish_workout.dart';
import '../../domain/usecases/resume_workout.dart';
import '../../domain/usecases/start_workout.dart';
import '../../domain/usecases/update_exercise_set.dart';
import 'workout_event.dart';
import 'workout_state.dart';

@injectable
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final StartWorkout startWorkout;
  final UpdateExerciseSet updateExerciseSet;
  final FinishWorkout finishWorkout;
  final ResumeWorkout resumeWorkout;

  WorkoutBloc({
    required this.startWorkout,
    required this.resumeWorkout,
    required this.updateExerciseSet,
    required this.finishWorkout,
  }) : super(const WorkoutInitial()) {
    on<WorkoutStarted>(_onWorkoutStarted);
    on<WorkoutResumed>(_onWorkoutResumed);
    on<ExerciseSetUpdated>(_onExerciseSetUpdated);
    on<WorkoutFinished>(_onWorkoutFinished);
  }

  Future<void> _onWorkoutStarted(
    WorkoutStarted event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());

      final session = await startWorkout(exercises: event.exercises);

      emit(WorkoutInProgress(session: session));
    } catch (e) {
      emit(WorkoutFailure(message: e.toString()));
    }
  }
  Future<void> _onWorkoutResumed(
      WorkoutResumed event,
      Emitter<WorkoutState> emit,
      ) async {
    emit(const WorkoutLoading());

    try {
      final session = await resumeWorkout(event.sessionId);

      emit(WorkoutInProgress(session: session));
    } catch (e) {
      emit(WorkoutFailure(message: e.toString()));
    }
  }


  Future<void> _onExerciseSetUpdated(
    ExerciseSetUpdated event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final session = await updateExerciseSet(
        sessionId: event.sessionId,
        workoutExerciseId: event.workoutExerciseId,
        setId: event.setId,
        actualWeight: event.actualWeight,
        actualReps: event.actualReps,
        status: event.status,
        note: event.note,
      );

      emit(WorkoutInProgress(session: session));
    } catch (e) {
      emit(WorkoutFailure(message: e.toString()));
    }
  }

  Future<void> _onWorkoutFinished(
    WorkoutFinished event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      emit(const WorkoutLoading());

      final session = await finishWorkout(sessionId: event.sessionId);

      emit(WorkoutCompleted(session: session));
    } catch (e) {
      emit(WorkoutFailure(message: e.toString()));
    }
  }
}
