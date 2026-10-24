import 'package:ai_gym_assistant/app/theme/app_colors.dart';
import 'package:ai_gym_assistant/app/utils/app_date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../workout/domain/entities/exercise_set.dart';
import '../../../workout/domain/entities/workout_session.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Lịch sử tập luyện',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () =>
                context.read<HistoryBloc>().add(const HistoryLoadRequested()),
            tooltip: 'Tải lại lịch sử',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryInitial || state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
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
            Icon(Icons.history_rounded, color: AppColors.muted, size: 64),
            SizedBox(height: 16),
            Text(
              'Chưa có lịch sử tập luyện',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sau khi hoàn thành một buổi tập, '
              'kết quả của bạn sẽ xuất hiện ở đây.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.5),
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
              color: AppColors.error,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () =>
                  context.read<HistoryBloc>().add(const HistoryLoadRequested()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
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
    final ordered = [...sessions]
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    final byDay = <DateTime, List<WorkoutSession>>{};
    for (final session in ordered) {
      final local = session.startedAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      byDay.putIfAbsent(day, () => []).add(session);
    }
    final dayGroups = byDay.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      itemCount: dayGroups.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _HistoryOverview(
            dayCount: dayGroups.length,
            sessionCount: ordered.length,
          );
        }

        final group = dayGroups[index - 1];
        return _HistoryDayGroup(
          key: ValueKey(group.key),
          day: group.key,
          sessions: group.value,
          exerciseNames: exerciseNames,
        );
      },
    );
  }
}

class _HistoryOverview extends StatelessWidget {
  final int dayCount;
  final int sessionCount;

  const _HistoryOverview({required this.dayCount, required this.sessionCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Các buổi tập đã hoàn thành',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Xem lại quá trình tập luyện của bạn',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.selected,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$dayCount ngày tập luyện',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$sessionCount lượt tập đã ghi nhận',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryDayGroup extends StatelessWidget {
  final DateTime day;
  final List<WorkoutSession> sessions;
  final Map<String, String> exerciseNames;

  const _HistoryDayGroup({
    super.key,
    required this.day,
    required this.sessions,
    required this.exerciseNames,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppDateFormatter.historyDayHeading(day),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Text(
                  '${sessions.length} lượt tập',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < sessions.length; i++) ...[
                  _HistorySessionRow(
                    key: PageStorageKey<String>('history-${sessions[i].id}'),
                    session: sessions[i],
                    exerciseNames: exerciseNames,
                  ),
                  if (i != sessions.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border,
                      indent: 14,
                      endIndent: 14,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySessionRow extends StatelessWidget {
  final WorkoutSession session;
  final Map<String, String> exerciseNames;

  const _HistorySessionRow({
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

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
      iconColor: AppColors.primary,
      collapsedIconColor: AppColors.muted,
      shape: const Border(),
      collapsedShape: const Border(),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.selected,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.fitness_center_rounded,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        AppDateFormatter.time(session.startedAt),
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          '${session.exercises.length} bài tập · $completedSets/$totalSets sets',
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ),
      children: [
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tiến độ buổi tập',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
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
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 18),
        for (var i = 0; i < session.exercises.length; i++) ...[
          _HistoryExerciseDetails(
            exerciseNumber: i + 1,
            exerciseName:
                exerciseNames[session.exercises[i].exerciseId] ??
                session.exercises[i].exerciseId,
            sets: session.exercises[i].sets,
          ),
          if (i < session.exercises.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _HistoryExerciseDetails extends StatelessWidget {
  final int exerciseNumber;
  final String exerciseName;
  final List<ExerciseSet> sets;

  const _HistoryExerciseDetails({
    required this.exerciseNumber,
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
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$exerciseNumber. $exerciseName',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '$completedSets/${sets.length} sets hoàn thành',
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  'Set',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Mục tiêu',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Thực tế',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.border),
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
        ? '${_formatWeight(set.actualWeight)} kg × ${set.actualReps}'
        : 'Chưa ghi nhận';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '${set.setNumber}',
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              suggested,
              style: const TextStyle(fontSize: 12, color: AppColors.text),
            ),
          ),
          Expanded(
            child: Text(
              actual,
              style: TextStyle(
                fontSize: 12,
                fontWeight: hasActual ? FontWeight.w600 : FontWeight.normal,
                color: hasActual ? AppColors.success : AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatWeight(double? weight) {
  if (weight == null) return '-';
  if (weight == weight.truncateToDouble()) {
    return weight.toStringAsFixed(0);
  }
  return weight.toString();
}
