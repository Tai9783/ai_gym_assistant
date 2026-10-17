import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/generate_recommendation.dart';
import 'recommendation_event.dart';
import 'recommendation_state.dart';

@injectable
class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final GenerateRecommendation _generateRecommendation;

  bool _isGenerating = false;

  RecommendationBloc(this._generateRecommendation)
    : super(const RecommendationInitial()) {
    on<RecommendationGenerateRequested>(_onGenerateRequested);
  }

  Future<void> _onGenerateRequested(
    RecommendationGenerateRequested event,
    Emitter<RecommendationState> emit,
  ) async {
    // Ignore duplicate requests while generating.
    if (_isGenerating) return;

    _isGenerating = true;

    emit(const RecommendationLoading());

    try {
      final recommendation = await _generateRecommendation(
        request: event.request,
      );

      if (emit.isDone) return;

      emit(
        RecommendationLoaded(
          request: event.request,
          recommendation: recommendation,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Recommendation failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (emit.isDone) return;

      emit(
        const RecommendationFailure(
          'Could not generate recommendation',
        ),
      );
    } finally {
      _isGenerating = false;
    }
  }
}
