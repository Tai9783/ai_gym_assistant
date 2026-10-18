import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import '../widgets/workout_set_card.dart';

const _primary = Color(0xFF5B6CFF);
const _background = Color(0xFFF7F8FA);

class WorkoutPage extends StatelessWidget {
  final List<WorkoutExercise>? initialExercises;

  const WorkoutPage({super.key, this.initialExercises});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<WorkoutBloc>();

        if (initialExercises != null && initialExercises!.isNotEmpty) {
          bloc.add(WorkoutStarted(exercises: initialExercises!));
        }

        return bloc;
      },
      child: const _WorkoutView(),
    );
  }
}

class _WorkoutView extends StatelessWidget {
  const _WorkoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Buổi tập của bạn'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutInitial) {
            return const Center(
              child: Text(
                'Chưa có buổi tập.\n'
                'Hãy tạo đề xuất AI từ trang Home.',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is WorkoutLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }

          if (state is WorkoutInProgress) {
            return _WorkoutContent(session: state.session);
          }

          if (state is WorkoutCompleted) {
            return _WorkoutCompletedView(session: state.session);
          }

          if (state is WorkoutFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Có lỗi xảy ra:\n${state.message}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _WorkoutContent extends StatelessWidget {
  final WorkoutSession session;

  const _WorkoutContent({required this.session});

  Future<void> _finishWorkout(BuildContext context) async {
    final remainingSets = session.exercises
        .expand((exercise) => exercise.sets)
        .where((set) => set.status != ExerciseSetStatus.completed)
        .length;

    if (remainingSets > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Kết thúc buổi tập?'),
          content: Text(
            'Bạn vẫn còn $remainingSets set chưa hoàn thành. '
            'Bạn có chắc muốn kết thúc không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Tiếp tục tập'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Kết thúc'),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;
    }

    if (!context.mounted) return;

    context.read<WorkoutBloc>().add(WorkoutFinished(sessionId: session.id));
  }

  @override
  Widget build(BuildContext context) {
    final totalSets = session.exercises.fold<int>(
      0,
      (sum, exercise) => sum + exercise.sets.length,
    );

    final completedSets = session.exercises
        .expand((exercise) => exercise.sets)
        .where((set) => set.status == ExerciseSetStatus.completed)
        .length;

    final progress = totalSets == 0 ? 0.0 : completedSets / totalSets;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Buổi tập đang diễn ra',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '${session.exercises.length} bài tập '
                '• $totalSets sets',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 18),

              // Workout progress summary.
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tiến độ buổi tập',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '$completedSets / $totalSets sets',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        backgroundColor: const Color(0xFFE8EAF4),
                        color: _primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).round()}% hoàn thành',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Danh sách bài tập',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // Collapsible exercise sections.
              for (var i = 0; i < session.exercises.length; i++)
                _WorkoutExerciseSection(
                  // Keep a stable identity for each exercise.
                  key: ValueKey<String>(session.exercises[i].id),
                  sessionId: session.id,
                  exercise: session.exercises[i],
                  order: i + 1,
                  initiallyExpanded: i == 0,
                ),
            ],
          ),
        ),

        // Persistent finish button.
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _finishWorkout(context),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Kết thúc buổi tập'),
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkoutExerciseSection extends StatelessWidget {
  final String sessionId;
  final WorkoutExercise exercise;
  final int order;
  final bool initiallyExpanded;

  const _WorkoutExerciseSection({
    super.key,
    required this.sessionId,
    required this.exercise,
    required this.order,
    required this.initiallyExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final completed = exercise.sets
        .where((set) => set.status == ExerciseSetStatus.completed)
        .length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        // Store expansion state separately for each session/exercise.
        key: PageStorageKey<String>('workout-$sessionId-${exercise.id}'),

        // Preserve TextField state when collapsing an exercise.
        maintainState: true,
        initiallyExpanded: initiallyExpanded,

        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEEF0FF),
          child: Text(
            '$order',
            style: const TextStyle(
              color: _primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          exercise.exerciseId,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        subtitle: Text(
          '$completed / ${exercise.sets.length} sets hoàn thành',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        children: [
          for (final set in exercise.sets)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: WorkoutSetCard(
                key: ValueKey<String>(set.id),
                set: set,
                onComplete:
                    ({required double actualWeight, required int actualReps}) {
                      context.read<WorkoutBloc>().add(
                        ExerciseSetUpdated(
                          sessionId: sessionId,
                          workoutExerciseId: exercise.id,
                          setId: set.id,
                          actualWeight: actualWeight,
                          actualReps: actualReps,
                          status: ExerciseSetStatus.completed,
                        ),
                      );
                    },
              ),
            ),
        ],
      ),
    );
  }
}

class _WorkoutCompletedView extends StatelessWidget {
  final WorkoutSession session;

  const _WorkoutCompletedView({required this.session});

  @override
  Widget build(BuildContext context) {
    final totalSets = session.exercises.fold<int>(
      0,
      (sum, exercise) => sum + exercise.sets.length,
    );

    final completedSets = session.exercises
        .expand((exercise) => exercise.sets)
        .where((set) => set.status == ExerciseSetStatus.completed)
        .length;

    final progress = totalSets == 0 ? 0.0 : completedSets / totalSets;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xFFE5F6EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 60,
                color: Color(0xFF218B50),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Hoàn thành buổi tập!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Kết quả tập luyện của bạn đã được lưu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '${session.exercises.length}',
                    'Bài tập',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('$totalSets', 'Tổng sets')),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('$completedSets', 'Đã tập')),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tiến độ hoàn thành',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$completedSets / $totalSets sets',
                        style: const TextStyle(
                          color: Color(0xFF5B6CFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: const Color(0xFFE8EAF4),
                      color: const Color(0xFF5B6CFF),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${(progress * 100).round()}% số set đã hoàn thành',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.go('/history');
                },
                icon: const Icon(Icons.history_rounded),
                label: const Text('Xem lịch sử tập luyện'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF5B6CFF),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(Icons.home_outlined),
                label: const Text('Về trang chủ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF5B6CFF),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B6CFF),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
