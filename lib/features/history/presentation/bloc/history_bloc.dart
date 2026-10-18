import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../exercise_catalog/domain/usecases/get_exercises.dart';
import '../../../workout/domain/usecases/get_completed_workouts.dart';
import 'history_event.dart';
import 'history_state.dart';

@injectable
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetCompletedWorkouts _getCompletedWorkouts;
  final GetExercises _getExercises;

  bool _isLoading = false;

  HistoryBloc(this._getCompletedWorkouts, this._getExercises)
    : super(const HistoryInitial()) {
    on<HistoryLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    HistoryLoadRequested event,
    Emitter<HistoryState> emit,
  ) async {
    if (_isLoading) return;

    _isLoading = true;
    emit(const HistoryLoading());

    try {
      final sessions = await _getCompletedWorkouts();

      if (emit.isDone) return;

      if (sessions.isEmpty) {
        emit(const HistoryEmpty());
        return;
      }

      // Load catalog names for display.
      var exerciseNames = <String, String>{};

      try {
        final exercises = await _getExercises();

        exerciseNames = {
          for (final exercise in exercises) exercise.id: exercise.name,
        };
      } catch (error) {
        if (kDebugMode) {
          debugPrint('Could not load exercise names: $error');
        }
      }

      if (emit.isDone) return;

      emit(HistoryLoaded(sessions: sessions, exerciseNames: exerciseNames));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('History loading failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      if (emit.isDone) return;

      emit(const HistoryFailure('Không thể tải lịch sử tập luyện'));
    } finally {
      _isLoading = false;
    }
  }
}
