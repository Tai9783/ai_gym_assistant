import 'package:ai_gym_assistant/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/utils/app_date_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/recent_exercise_progress.dart';
import '../../domain/entities/long_term_exercise_progress.dart';
import '../bloc/progress_bloc.dart';
import '../bloc/progress_event.dart';
import '../bloc/progress_state.dart';

const _primary = AppColors.primary;
const _background = AppColors.background;
const _borderColor = AppColors.border;
const _textColor = AppColors.text;
const _subTextColor = AppColors.muted;

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProgressBloc>(
      create: (_) => getIt<ProgressBloc>()..add(const ProgressLoadRequested()),
      child: const _ProgressView(),
    );
  }
}

class _ProgressView extends StatefulWidget  {
  const _ProgressView();

  @override
  State<_ProgressView> createState() => _ProgressViewState();

}
class _ProgressViewState extends State<_ProgressView> {
  GoRouter? _router;
  String? _previousPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final router = GoRouter.of(context);

    if (identical(_router, router)) return;

    _router?.routeInformationProvider.removeListener(_onRouteChanged);

    _router = router;
    _previousPath = router.routeInformationProvider.value.uri.path;

    router.routeInformationProvider.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    final path = _router?.routeInformationProvider.value.uri.path;

    final wasOnProgress = _previousPath == '/progress';

    _previousPath = path;

    if (mounted && path == '/progress' && !wasOnProgress) {
      context.read<ProgressBloc>().add(
        const ProgressLoadRequested(),
      );
    }
  }

  @override
  void dispose() {
    _router?.routeInformationProvider.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Tiến độ tập luyện',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Tải lại tiến độ',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<ProgressBloc>().add(const ProgressLoadRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state is ProgressInitial || state is ProgressLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }

          if (state is ProgressEmpty) {
            return const _ProgressEmptyView();
          }

          if (state is ProgressFailure) {
            return _ProgressFailureView(message: state.message);
          }

          if (state is ProgressLoaded) {
            return _ProgressContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProgressEmptyView extends StatelessWidget {
  const _ProgressEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insights_outlined, color: Colors.black38, size: 64),
            SizedBox(height: 16),
            Text(
              'Chưa có dữ liệu tiến độ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy hoàn thành một buổi tập để bắt đầu '
              'theo dõi tiến độ của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _subTextColor, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressFailureView extends StatelessWidget {
  final String message;

  const _ProgressFailureView({required this.message});

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
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                context.read<ProgressBloc>().add(const ProgressLoadRequested());
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

class _ProgressContent extends StatelessWidget {
  final ProgressLoaded state;

  const _ProgressContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Theo dõi sự tiến bộ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Xem hiệu suất tập luyện theo từng bài tập '
          'đã hoàn thành.',
          style: TextStyle(fontSize: 14, height: 1.5, color: _subTextColor),
        ),
        const SizedBox(height: 22),

        // Exercise selector.
        _buildExerciseSelector(context),

        const SizedBox(height: 20),

        // Recent progress.
        if (state.recent != null)
          _RecentProgressSection(progress: state.recent!)
        else
          const _NoProgressSection(title: 'Tiến độ gần đây'),

        const SizedBox(height: 16),

        // Long-term progress.
        if (state.longTerm != null)
          _LongTermProgressSection(progress: state.longTerm!)
        else
          const _NoProgressSection(title: 'Tiến độ dài hạn'),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildExerciseSelector(BuildContext context) {
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
          const Text(
            'Chọn bài tập',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey(state.selectedExerciseId),
            initialValue: state.selectedExerciseId,
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.fitness_center_rounded,
                color: _primary,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            items: state.exerciseIds.map((id) {
              final name = state.exerciseNames[id] ?? id;

              return DropdownMenuItem<String>(
                value: id,
                child: Text(name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (exerciseId) {
              if (exerciseId == null) return;

              context.read<ProgressBloc>().add(
                ProgressExerciseSelected(exerciseId),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Chỉ hiển thị những bài tập đã có trong lịch sử.',
            style: TextStyle(fontSize: 12, color: _subTextColor),
          ),
        ],
      ),
    );
  }
}

class _RecentProgressSection extends StatelessWidget {
  final RecentExerciseProgress progress;

  const _RecentProgressSection({required this.progress});

  @override
  Widget build(BuildContext context) {
    // Avoid showing a misleading 0% when no sessions
    // could be classified as hitting or missing targets.
    final hasTargetData =
        progress.hitSessionCount + progress.missedTargetSessionCount > 0;

    return _ProgressSection(
      title: 'Tiến độ gần đây',
      subtitle: 'Tối đa 5 lần tập gần nhất',
      icon: Icons.trending_up_rounded,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Số buổi gần đây',
                value: '${progress.sessionCount}',
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                label: 'Tạ thực tế gần nhất',
                value: _formatWeight(progress.latestActualMaxWeight),
                icon: Icons.fitness_center_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _TargetRateView(
          title: 'Tỷ lệ set đạt mục tiêu',
          rate: hasTargetData ? progress.targetHitSetRate : null,
        ),

        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 14),

        _InfoRow(
          label: 'Tạ AI đề xuất gần nhất',
          value: _formatWeight(progress.latestSuggestedMaxWeight),
        ),
        const SizedBox(height: 12),

        _InfoRow(
          label: 'Số buổi đạt mục tiêu',
          value: '${progress.hitSessionCount}',
        ),
        const SizedBox(height: 12),

        _InfoRow(
          label: 'Số buổi hụt mục tiêu',
          value: '${progress.missedTargetSessionCount}',
        ),
        const SizedBox(height: 12),

        _InfoRow(
          label: 'Chuỗi buổi hụt liên tiếp',
          value: '${progress.currentMissStreak}',
        ),

        const SizedBox(height: 18),
        const Divider(height: 1),
        const SizedBox(height: 14),

        _TrendRow(
          label: 'Xu hướng mức tạ',
          trendName: progress.weightTrend.name,
        ),
        const SizedBox(height: 14),

        _TrendRow(
          label: 'Xu hướng khối lượng tập',
          trendName: progress.volumeTrend.name,
        ),
      ],
    );
  }
}

class _LongTermProgressSection extends StatelessWidget {
  final LongTermExerciseProgress progress;

  const _LongTermProgressSection({required this.progress});

  @override
  Widget build(BuildContext context) {
    return _ProgressSection(
      title: 'Tiến độ dài hạn',
      subtitle: 'Tổng hợp toàn bộ lịch sử bài tập',
      icon: Icons.emoji_events_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Tổng buổi tập',
                value: '${progress.sessionCount}',
                icon: Icons.event_available_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                label: 'Tạ cao nhất đã đạt',
                value: _formatWeight(progress.bestActualMaxWeight),
                icon: Icons.workspace_premium_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _TargetRateView(
          title: 'Tỷ lệ set đạt mục tiêu',
          rate: progress.targetHitSetRate,
        ),

        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 14),

        _InfoRow(
          label: 'Lần tập đầu tiên',
          value: AppDateFormatter.date(progress.firstPerformedAt),
        ),
        const SizedBox(height: 12),

        _InfoRow(
          label: 'Lần tập gần nhất',
          value: AppDateFormatter.date(progress.firstPerformedAt),
        ),
        const SizedBox(height: 12),

        _InfoRow(
          label: 'Số buổi đạt mục tiêu',
          value: '${progress.hitSessionCount}',
        ),
        const SizedBox(height: 12),

        _InfoRow(
          label: 'Số buổi hụt mục tiêu',
          value: '${progress.missedTargetSessionCount}',
        ),

        const SizedBox(height: 18),
        const Divider(height: 1),
        const SizedBox(height: 14),

        _TrendRow(
          label: 'Xu hướng mức tạ',
          trendName: progress.weightTrend.name,
        ),
        const SizedBox(height: 14),

        _TrendRow(
          label: 'Xu hướng khối lượng tập',
          trendName: progress.volumeTrend.name,
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  const _ProgressSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.selected,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _subTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ...children,
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tile,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: _primary),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 2,
            style: const TextStyle(color: _subTextColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TargetRateView extends StatelessWidget {
  final String title;
  final double? rate;

  const _TargetRateView({required this.title, required this.rate});

  @override
  Widget build(BuildContext context) {
    final validRate = rate?.clamp(0.0, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              validRate == null
                  ? 'Chưa đủ dữ liệu'
                  : '${(validRate * 100).round()}%',
              style: const TextStyle(
                color: _primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: validRate ?? 0,
            minHeight: 9,
            backgroundColor: AppColors.track,
            color: _primary,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: _subTextColor),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _textColor,
          ),
        ),
      ],
    );
  }
}

class _TrendRow extends StatelessWidget {
  final String label;
  final String trendName;

  const _TrendRow({required this.label, required this.trendName});

  @override
  Widget build(BuildContext context) {
    final String displayText;
    final IconData icon;
    final Color color;

    switch (trendName) {
      case 'increasing':
        displayText = 'Đang tăng';
        icon = Icons.trending_up_rounded;
        color = const Color(0xFF218B50);

      case 'decreasing':
        displayText = 'Đang giảm';
        icon = Icons.trending_down_rounded;
        color = const Color(0xFFE05B50);

      case 'stable':
        displayText = 'Ổn định';
        icon = Icons.trending_flat_rounded;
        color = _primary;

      default:
        displayText = 'Chưa đủ dữ liệu';
        icon = Icons.remove_circle_outline_rounded;
        color = _subTextColor;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: _subTextColor),
          ),
        ),
        Icon(icon, color: color, size: 19),
        const SizedBox(width: 5),
        Text(
          displayText,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NoProgressSection extends StatelessWidget {
  final String title;

  const _NoProgressSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return _ProgressSection(
      title: title,
      subtitle: 'Chưa có kết quả phân tích',
      icon: Icons.info_outline_rounded,
      children: const [
        Text(
          'Chưa đủ dữ liệu để hiển thị tiến độ '
          'cho bài tập này.',
          style: TextStyle(fontSize: 13, color: _subTextColor),
        ),
      ],
    );
  }
}

String _formatWeight(double? weight) {
  if (weight == null) return 'Chưa có';

  final value = weight == weight.truncateToDouble()
      ? weight.toStringAsFixed(0)
      : weight.toString();

  return '$value kg';
}
