import 'package:ai_gym_assistant/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../workout/domain/entities/exercise_set.dart';
import '../../../workout/domain/entities/workout_session.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

const _primary = AppColors.primary;
const _background = AppColors.background;
const _borderColor = AppColors.border;

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryBloc>(
      create: (_) => getIt<HistoryBloc>()..add(const HistoryLoadRequested()),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Lịch sử tập luyện',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              context.read<HistoryBloc>().add(const HistoryLoadRequested());
            },
            tooltip: 'Tải lại lịch sử',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryInitial || state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }

          if (state is HistoryEmpty) {
            return const _HistoryEmptyView();
          }

          if (state is HistoryFailure) {
            return _HistoryFailureView(message: state.message);
          }

          if (state is HistoryLoaded) {
            return _HistoryList(
              sessions: state.sessions,
              exerciseNames: state.exerciseNames,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HistoryEmptyView extends StatelessWidget {
  const _HistoryEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, color: Colors.black38, size: 64),
            SizedBox(height: 16),
            Text(
              'Chưa có lịch sử tập luyện',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Sau khi hoàn thành một buổi tập, '
              'kết quả của bạn sẽ xuất hiện ở đây.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryFailureView extends StatelessWidget {
  final String message;

  const _HistoryFailureView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<HistoryBloc>().add(const HistoryLoadRequested());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
              style: FilledButton.styleFrom(backgroundColor: _primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<WorkoutSession> sessions;
  final Map<String, String> exerciseNames;

  const _HistoryList({required this.sessions, required this.exerciseNames});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Các buổi tập đã hoàn thành',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  '${sessions.length} buổi tập được lưu',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          );
        }

        final session = sessions[index - 1];

        return _HistorySessionCard(
          key: ValueKey(session.id),
          session: session,
          exerciseNames: exerciseNames,
        );
      },
    );
  }
}

class _HistorySessionCard extends StatelessWidget {
  final WorkoutSession session;
  final Map<String, String> exerciseNames;

  const _HistorySessionCard({
    super.key,
    required this.session,
    required this.exerciseNames,
  });

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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _borderColor),
      ),
      child: ExpansionTile(
        key: PageStorageKey<String>('history-${session.id}'),
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8F6EC),
          child: Icon(Icons.check_rounded, color: Color(0xFF218B50)),
        ),
        title: Text(
          _formatDate(session.startedAt),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${session.exercises.length} bài tập'
            ' • $completedSets/$totalSets sets',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Session completion progress.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiến độ buổi tập',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: _primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.track,
              color: _primary,
            ),
          ),
          const SizedBox(height: 20),

          // All exercises in this session.
          for (var i = 0; i < session.exercises.length; i++) ...[
            _HistoryExerciseDetails(
              exerciseNumber: i + 1,
              exerciseId: session.exercises[i].exerciseId,
              exerciseName:
                  exerciseNames[session.exercises[i].exerciseId] ??
                  session.exercises[i].exerciseId,
              sets: session.exercises[i].sets,
            ),
            if (i < session.exercises.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _HistoryExerciseDetails extends StatelessWidget {
  final int exerciseNumber;
  final String exerciseId;
  final String exerciseName;
  final List<ExerciseSet> sets;

  const _HistoryExerciseDetails({
    required this.exerciseNumber,
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
  });

  @override
  Widget build(BuildContext context) {
    final completedSets = sets
        .where((set) => set.status == ExerciseSetStatus.completed)
        .length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.fitness_center_rounded,
                size: 18,
                color: _primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$exerciseNumber. $exerciseName',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '$completedSets/${sets.length} sets hoàn thành',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 14),

          // Set result table header.
          const Row(
            children: [
              SizedBox(
                width: 42,
                child: Text(
                  'Set',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Mục tiêu',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Thực tế',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),

          for (final set in sets) _HistorySetRow(set: set),
        ],
      ),
    );
  }
}

class _HistorySetRow extends StatelessWidget {
  final ExerciseSet set;

  const _HistorySetRow({required this.set});

  @override
  Widget build(BuildContext context) {
    final isCompleted = set.status == ExerciseSetStatus.completed;

    final hasActual =
        isCompleted && set.actualWeight != null && set.actualReps != null;

    final suggested =
        '${_formatWeight(set.suggestedWeight)} kg'
        ' × ${set.suggestedReps ?? '-'}';

    final actual = hasActual
        ? '${_formatWeight(set.actualWeight)} kg'
              ' × ${set.actualReps}'
        : 'Chưa ghi nhận';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 42,
            child: Text(
              '${set.setNumber}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(suggested, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: Text(
              actual,
              style: TextStyle(
                fontSize: 12,
                fontWeight: hasActual ? FontWeight.w600 : FontWeight.normal,
                color: hasActual ? const Color(0xFF218B50) : Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final local = date.toLocal();

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  return '${twoDigits(local.day)}/'
      '${twoDigits(local.month)}/'
      '${local.year} • '
      '${twoDigits(local.hour)}:'
      '${twoDigits(local.minute)}';
}

String _formatWeight(double? weight) {
  if (weight == null) return '-';

  if (weight == weight.truncateToDouble()) {
    return weight.toStringAsFixed(0);
  }

  return weight.toString();
}
