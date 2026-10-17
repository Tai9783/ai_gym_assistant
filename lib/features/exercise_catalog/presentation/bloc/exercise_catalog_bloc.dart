import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_exercises.dart';
import 'exercise_catalog_event.dart';
import 'exercise_catalog_state.dart';

@injectable
class ExerciseCatalogBloc
    extends Bloc<ExerciseCatalogEvent, ExerciseCatalogState> {
  final GetExercises getExercises;

  ExerciseCatalogBloc({required this.getExercises})
    : super(const ExerciseCatalogInitial()) {
    on<ExerciseCatalogRequested>(_onExerciseCatalogRequested);
  }

  Future<void> _onExerciseCatalogRequested(
    ExerciseCatalogRequested event,
    Emitter<ExerciseCatalogState> emit,
  ) async {
    try {
      emit(const ExerciseCatalogLoading());

      final exercises = await getExercises();

      emit(ExerciseCatalogLoaded(exercises: exercises));
    } catch (e) {
      emit(ExerciseCatalogFailure(message: e.toString()));
    }
  }
}
