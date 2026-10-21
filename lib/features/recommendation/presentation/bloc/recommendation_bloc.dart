import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/exceptions/recommendation_rate_limited_exception.dart';
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

    on<RecommendationRestorePreviousRequested>((event, emit) {
      final currentState = state;

      if (currentState is RecommendationFailure) {
        final previous = currentState.previousLoaded;

        if (previous != null) {
          emit(previous);
        }
      }
    });
  }

  Future<void> _onGenerateRequested(
    RecommendationGenerateRequested event,
    Emitter<RecommendationState> emit,
  ) async {

    if (_isGenerating) return;

// Lưu đề xuất thành công gần nhất trước khi Loading.
    final previousLoaded = switch (state) {
      RecommendationLoaded loaded => loaded,
      RecommendationFailure failure => failure.previousLoaded,
      _ => null,
    };

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

      if (error is RecommendationRateLimitedException) {
        final message = switch (error.reason) {
          RecommendationRateLimitReason.dailyLimit =>
          'Bạn đã sử dụng hết 10 lượt đề xuất AI trong ngày.',

          RecommendationRateLimitReason.cooldown =>
          'Bạn vừa gửi một yêu cầu AI. '
              'Vui lòng chờ trước khi tạo đề xuất tiếp theo.',

          RecommendationRateLimitReason.unknown =>
          'Bạn đang bị giới hạn lượt đề xuất AI. '
              'Vui lòng quay lại sau.',
        };

        emit(
          RecommendationFailure(
            message,
            rateLimitReason: error.reason,
            resetAt: error.resetAt,
            retryAfterSeconds: error.retryAfterSeconds,
            previousLoaded: previousLoaded,
          ),
        );
      } else {
        emit(
          RecommendationFailure(
            'Dịch vụ AI đang gặp sự cố. '
                'Vui lòng thử lại sau.',
            previousLoaded: previousLoaded,
          ),
        );
      }
    }
    finally {
      _isGenerating = false;
    }
  }
}
