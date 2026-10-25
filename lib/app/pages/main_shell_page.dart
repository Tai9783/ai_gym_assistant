import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../features/workout/presentation/cubit/active_workout_cubit.dart';
import '../../features/workout/presentation/cubit/active_workout_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_notice.dart';

class MainShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellPage({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
  Future<void> _confirmCancelWorkout(
      BuildContext context,
      String sessionId,
      ) async {
    final activeWorkoutCubit = context.read<ActiveWorkoutCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hủy buổi tập đang dở?'),
          content: const Text(
            'Nếu hủy, toàn bộ kết quả của buổi tập này '
                'sẽ không được tính vào lịch sử và tiến độ tập luyện.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Giữ lại'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Hủy buổi tập'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await activeWorkoutCubit.cancelWorkout(sessionId);
    } catch (error) {
      if (!context.mounted) return;

      AppNotice.error(
        context,
        'Không thể hủy buổi tập. Vui lòng thử lại.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActiveWorkoutCubit>(
      create: (_) => getIt<ActiveWorkoutCubit>()
        ..startWatching(),
      child: Scaffold(
        body: Column(
          children: [
            BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
              builder: (context, state) {
                if (state is! ActiveWorkoutLoaded ||
                    state.sessions.isEmpty) {
                  return const SizedBox.shrink();
                }

                final count = state.sessions.length;
                final session = state.sessions.first;

                return SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Material(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),

                        onTap: () {
                          context.push(
                            '/workout?sessionId=${Uri.encodeQueryComponent(session.id)}',
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fitness_center,
                                color: Colors.white,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  count == 1
                                      ? 'Bạn có một buổi tập đang dở'
                                      : 'Bạn có $count buổi tập đang dở',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),

                              IconButton(
                                tooltip: 'Hủy buổi tập',
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _confirmCancelWorkout(
                                    context,
                                    session.id,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                );
              },
            ),

            Expanded(
              child: BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
                builder: (context, state) {
                  final hasActiveWorkout =
                      state is ActiveWorkoutLoaded && state.sessions.isNotEmpty;

                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: hasActiveWorkout,
                    child: navigationShell,
                  );
                },
              ),
            ),
          ],
        ),

        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'Lịch sử',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_up_outlined),
              selectedIcon: Icon(Icons.trending_up),
              label: 'Tiến độ',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }
}
