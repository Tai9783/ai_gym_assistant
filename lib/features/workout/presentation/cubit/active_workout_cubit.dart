import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/workout_session.dart';
import '../../domain/usecases/watch_in_progress_workout_sessions.dart';
import 'active_workout_state.dart';

@injectable
class ActiveWorkoutCubit extends Cubit<ActiveWorkoutState> {
  final WatchInProgressWorkoutSessions _watchInProgressWorkoutSessions;

  StreamSubscription<List<WorkoutSession>>? _subscription;

  ActiveWorkoutCubit(this._watchInProgressWorkoutSessions)
      : super(const ActiveWorkoutInitial());

  void startWatching() {
    if (_subscription != null) return;

    emit(const ActiveWorkoutLoading());

    _subscription = _watchInProgressWorkoutSessions().listen(
          (sessions) {
        if (isClosed) return;

        emit(ActiveWorkoutLoaded(sessions));
      },
      onError: (Object error, StackTrace stackTrace) {
        if (isClosed) return;

        emit(
          const ActiveWorkoutFailure(
            'Không thể theo dõi buổi tập đang dở.',
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}