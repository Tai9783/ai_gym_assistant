import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../exercise_catalog/domain/entities/exercise_definition.dart';
import '../../../exercise_catalog/domain/usecases/get_exercises.dart';
import '../../domain/entities/workout_request.dart';
import '../../domain/entities/workout_recommendation.dart';
import '../bloc/recommendation_bloc.dart';
import '../bloc/recommendation_event.dart';
import '../bloc/recommendation_state.dart';
import '../mappers/recommendation_workout_mapper.dart';

class RecommendationPage extends StatefulWidget {
  final WorkoutRequest request;
  final GetExercises getExercises;

  const RecommendationPage({
    super.key,
    required this.request,
    required this.getExercises,
  });

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  static const _primaryColor = Color(0xFF5C63F6);
  static const _backgroundColor = Color(0xFFF8F9FC);
  static const _borderColor = Color(0xFFE8EAF0);

  late final Future<List<ExerciseDefinition>> _catalogFuture;

  @override
  void initState() {
    super.initState();
    _catalogFuture = widget.getExercises();
  }

  void _generateAgain() {
    context.read<RecommendationBloc>().add(
      RecommendationGenerateRequested(widget.request),
    );
  }
  void _startWorkout(WorkoutRecommendation recommendation) {
    final exercises =
    RecommendationWorkoutMapper.toWorkoutExercises(recommendation);

    context.pushReplacement(
      '/workout',
      extra: exercises,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Gợi ý buổi tập',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<RecommendationBloc, RecommendationState>(
        builder: (context, state) {
          if (state is RecommendationLoading ||
              state is RecommendationInitial) {
            return _buildLoading();
          }

          if (state is RecommendationFailure) {
            return _buildFailure(state.message);
          }

          if (state is RecommendationLoaded) {
            return FutureBuilder<List<ExerciseDefinition>>(
              future: _catalogFuture,
              builder: (context, snapshot) {
                final exerciseNames = {
                  for (final exercise
                      in snapshot.data ?? <ExerciseDefinition>[])
                    exercise.id: exercise.name,
                };

                return _buildRecommendation(
                  state.recommendation,
                  exerciseNames,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: _primaryColor),
          SizedBox(height: 20),
          Text(
            'AI đang tạo buổi tập cho bạn...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Đang phân tích mục tiêu và tiến độ tập luyện',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildFailure(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Không thể tạo buổi tập',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _generateAgain,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
              style: FilledButton.styleFrom(backgroundColor: _primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(
    WorkoutRecommendation recommendation,
    Map<String, String> exerciseNames,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Buổi tập dành cho bạn',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF252836),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Được AI đề xuất dựa trên hồ sơ '
                'và tiến độ tập luyện của bạn.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              _buildSummary(recommendation),
              const SizedBox(height: 20),
              const Text(
                'Danh sách bài tập',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < recommendation.exercises.length; i++) ...[
                _buildExerciseCard(
                  recommendation.exercises[i],
                  exerciseNames,
                  i + 1,
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        _buildActions(recommendation),
      ],
    );
  }

  Widget _buildSummary(WorkoutRecommendation recommendation) {
    final totalSets = recommendation.exercises.fold<int>(
      0,
      (sum, exercise) => sum + exercise.sets.length,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: _primaryColor,
            size: 30,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kế hoạch AI đề xuất',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  '${recommendation.exercises.length} bài tập'
                  '  •  $totalSets sets',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    RecommendedExercise exercise,
    Map<String, String> exerciseNames,
    int order,
  ) {
    final exerciseName =
        exerciseNames[exercise.exerciseId] ?? exercise.exerciseId;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFECEBFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$order',
                  style: const TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  exerciseName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          for (var i = 0; i < exercise.sets.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Set ${i + 1}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  Text(
                    '${exercise.sets[i].suggestedWeight} kg',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${exercise.sets[i].suggestedReps} reps',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(WorkoutRecommendation recommendation) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _generateAgain,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Tạo lại'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    foregroundColor: _primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _startWorkout(recommendation),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Bắt đầu tập'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    backgroundColor: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
