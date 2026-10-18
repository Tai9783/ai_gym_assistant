import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection.dart';
import '../../features/exercise_catalog/domain/usecases/get_exercises.dart';
import '../../features/exercise_catalog/presentation/pages/select_exercise_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/recommendation/domain/entities/workout_request.dart';
import '../../features/recommendation/presentation/bloc/recommendation_bloc.dart';
import '../../features/recommendation/presentation/bloc/recommendation_event.dart';
import '../../features/recommendation/presentation/pages/recommendation_page.dart';
import '../../features/workout/domain/entities/workout_exercise.dart';
import '../../features/workout/presentation/pages/workout_page.dart';
import '../pages/home_page.dart';
import '../pages/main_shell_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellPage(navigationShell: navigationShell);
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              name: 'history',
              builder: (context, state) {
                return const HistoryPage();
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              name: 'progress',
              builder: (context, state) {
                return const ProgressPage();
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) {
                return BlocProvider<ProfileBloc>(
                  create: (_) => getIt<ProfileBloc>(),
                  child: const ProfilePage(),
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/select-exercises',
      name: 'selectExercises',
      builder: (context, state) {
        return SelectExercisePage(
          initialSelectedExerciseIds:
          (state.extra as List<String>?) ?? const [],
          muscleGroup: state.uri.queryParameters['group'],
        );
      },
    ),

    GoRoute(
      path: '/recommendation',
      builder: (context, state) {
        final extra = state.extra;

        if (extra is! WorkoutRequest) {
          return const Scaffold(
            body: Center(child: Text('Thiếu yêu cầu tập luyện')),
          );
        }

        return BlocProvider<RecommendationBloc>(
          create: (_) =>
              GetIt.I<RecommendationBloc>()
                ..add(RecommendationGenerateRequested(extra)),
          child: RecommendationPage(
            request: extra,
            getExercises: GetIt.I<GetExercises>(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/workout',
      builder: (context, state) {
        final extra = state.extra;

        return WorkoutPage(
          initialExercises:
          extra is List<WorkoutExercise> ? extra : null,
        );
      },
    ),
  ],
);
