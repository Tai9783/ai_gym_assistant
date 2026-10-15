import 'package:go_router/go_router.dart';
import '../../features/exercise_catalog/presentation/pages/select_exercise_page.dart';
import '../pages/home_page.dart';
import '../pages/main_shell_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (
          context,
          state,
          navigationShell,
          ) {
        return MainShellPage(
          navigationShell: navigationShell,
        );
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
                return const ProfilePage();
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
        final initialSelectedExerciseIds =
            state.extra as List<String>? ?? const <String>[];

        return SelectExercisePage(
          initialSelectedExerciseIds: initialSelectedExerciseIds,
        );
      },
    ),
  ],
);