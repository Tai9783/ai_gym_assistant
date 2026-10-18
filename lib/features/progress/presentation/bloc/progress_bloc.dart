import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../exercise_catalog/domain/usecases/get_exercises.dart';
import '../../../workout/domain/usecases/get_completed_workouts.dart';
import '../../domain/usecases/get_exercise_progress.dart';
import 'progress_event.dart';
import 'progress_state.dart';

@injectable
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetCompletedWorkouts _getCompletedWorkouts;
  final GetExercises _getExercises;
  final GetExerciseProgress _getExerciseProgress;

  List<String> _exerciseIds = [];
  Map<String, String> _exerciseNames = {};
  String? _selectedExerciseId;

  // Ignore results from outdated requests.
  int _requestVersion = 0;

  ProgressBloc(
    this._getCompletedWorkouts,
    this._getExercises,
    this._getExerciseProgress,
  ) : super(const ProgressInitial()) {
    on<ProgressLoadRequested>(_onLoadRequested);
    on<ProgressExerciseSelected>(_onExerciseSelected);
  }

  Future<void> _onLoadRequested(
    ProgressLoadRequested event,
    Emitter<ProgressState> emit,
  ) async {
    final version = ++_requestVersion;
    emit(const ProgressLoading());

    try {
      // Load completed sessions from SQLite.
      final sessions = await _getCompletedWorkouts();

      if (emit.isDone || version != _requestVersion) return;

      // Collect exercise IDs in history order.
      final ids = <String>[];
      final seenIds = <String>{};

      for (final session in sessions) {
        for (final exercise in session.exercises) {
          if (seenIds.add(exercise.exerciseId)) {
            ids.add(exercise.exerciseId);
          }
        }
      }

      if (ids.isEmpty) {
        _exerciseIds = [];
        _exerciseNames = {};
        _selectedExerciseId = null;

        emit(const ProgressEmpty());
        return;
      }

      // Load exercise names from the catalog.
      // Fall back to IDs if the catalog is unavailable.
      final names = <String, String>{};

      try {
        final catalog = await _getExercises();

        for (final exercise in catalog) {
          names[exercise.id] = exercise.name;
        }
      } catch (error) {
        if (kDebugMode) {
          debugPrint('Could not load exercise names: $error');
        }
      }

      if (emit.isDone || version != _requestVersion) return;

      _exerciseIds = ids;
      _exerciseNames = names;

      // Keep the previous selection when possible.
      final previousId = _selectedExerciseId;

      final selectedId = previousId != null && ids.contains(previousId)
          ? previousId
          : ids.first;

      _selectedExerciseId = selectedId;

      await _loadProgress(exerciseId: selectedId, version: version, emit: emit);
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace, version, emit);
    }
  }

  Future<void> _onExerciseSelected(
    ProgressExerciseSelected event,
    Emitter<ProgressState> emit,
  ) async {
    if (!_exerciseIds.contains(event.exerciseId)) {
      return;
    }

    if (_selectedExerciseId == event.exerciseId && state is ProgressLoaded) {
      return;
    }

    final version = ++_requestVersion;
    _selectedExerciseId = event.exerciseId;

    emit(const ProgressLoading());

    try {
      await _loadProgress(
        exerciseId: event.exerciseId,
        version: version,
        emit: emit,
      );
    } catch (error, stackTrace) {
      _emitFailure(error, stackTrace, version, emit);
    }
  }

  Future<void> _loadProgress({
    required String exerciseId,
    required int version,
    required Emitter<ProgressState> emit,
  }) async {
    // Use the existing domain analysis.
    final result = await _getExerciseProgress(exerciseId: exerciseId);

    if (emit.isDone || version != _requestVersion) return;

    emit(
      ProgressLoaded(
        exerciseIds: List.unmodifiable(_exerciseIds),
        exerciseNames: Map.unmodifiable(_exerciseNames),
        selectedExerciseId: exerciseId,
        recent: result.recent,
        longTerm: result.longTerm,
      ),
    );
  }

  void _emitFailure(
    Object error,
    StackTrace stackTrace,
    int version,
    Emitter<ProgressState> emit,
  ) {
    if (kDebugMode) {
      debugPrint('Progress loading failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    if (emit.isDone || version != _requestVersion) return;

    emit(const ProgressFailure('Không thể tải tiến độ tập luyện'));
  }
}
