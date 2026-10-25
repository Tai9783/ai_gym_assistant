import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../features/workout/presentation/cubit/active_workout_cubit.dart';
import '../../features/workout/presentation/cubit/active_workout_state.dart';
import '../theme/app_colors.dart';

class MainShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellPage({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
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
                          padding: const EdgeInsets.all(16),
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
              child: navigationShell,
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
