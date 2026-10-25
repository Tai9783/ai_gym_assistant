// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:ai_gym_assistant/core/auth/anonymous_auth_service.dart'
    as _i971;
import 'package:ai_gym_assistant/core/auth/firebase_anonymous_auth_service.dart'
    as _i879;
import 'package:ai_gym_assistant/core/database/app_database.dart' as _i117;
import 'package:ai_gym_assistant/core/di/firebase_module.dart' as _i57;
import 'package:ai_gym_assistant/features/exercise_catalog/data/datasources/exercise_local_data_source.dart'
    as _i1019;
import 'package:ai_gym_assistant/features/exercise_catalog/data/repositories/exercise_repository_impl.dart'
    as _i170;
import 'package:ai_gym_assistant/features/exercise_catalog/domain/repositories/exercise_repository.dart'
    as _i491;
import 'package:ai_gym_assistant/features/exercise_catalog/domain/usecases/get_exercises.dart'
    as _i158;
import 'package:ai_gym_assistant/features/exercise_catalog/presentation/bloc/exercise_catalog_bloc.dart'
    as _i534;
import 'package:ai_gym_assistant/features/history/presentation/bloc/history_bloc.dart'
    as _i1018;
import 'package:ai_gym_assistant/features/profile/data/datasources/user_profile_local_data_source.dart'
    as _i976;
import 'package:ai_gym_assistant/features/profile/data/repositories/user_profile_repository_impl.dart'
    as _i267;
import 'package:ai_gym_assistant/features/profile/domain/repositories/user_profile_repository.dart'
    as _i651;
import 'package:ai_gym_assistant/features/profile/domain/usecases/get_user_profile.dart'
    as _i888;
import 'package:ai_gym_assistant/features/profile/domain/usecases/save_user_profile.dart'
    as _i917;
import 'package:ai_gym_assistant/features/profile/presentation/bloc/profile_bloc.dart'
    as _i165;
import 'package:ai_gym_assistant/features/progress/data/datasources/exercise_progress_cache_local_data_source.dart'
    as _i346;
import 'package:ai_gym_assistant/features/progress/data/repositories/progress_cache_synchronizer_impl.dart'
    as _i661;
import 'package:ai_gym_assistant/features/progress/data/services/exercise_progress_cache_initializer.dart'
    as _i219;
import 'package:ai_gym_assistant/features/progress/data/services/exercise_progress_cache_updater.dart'
    as _i498;
import 'package:ai_gym_assistant/features/progress/data/services/long_term_aggregate_state_updater.dart'
    as _i548;
import 'package:ai_gym_assistant/features/progress/data/services/long_term_progress_result_updater.dart'
    as _i214;
import 'package:ai_gym_assistant/features/progress/data/services/recent_progress_cache_updater.dart'
    as _i155;
import 'package:ai_gym_assistant/features/progress/domain/repositories/progress_cache_synchronizer.dart'
    as _i398;
import 'package:ai_gym_assistant/features/progress/domain/services/exercise_session_summarizer.dart'
    as _i147;
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_progress_analyzer.dart'
    as _i516;
import 'package:ai_gym_assistant/features/progress/domain/services/long_term_trend_calculator.dart'
    as _i899;
import 'package:ai_gym_assistant/features/progress/domain/services/recent_progress_analyzer.dart'
    as _i26;
import 'package:ai_gym_assistant/features/progress/domain/services/session_target_classifier.dart'
    as _i338;
import 'package:ai_gym_assistant/features/progress/domain/usecases/get_exercise_progress.dart'
    as _i329;
import 'package:ai_gym_assistant/features/progress/presentation/bloc/progress_bloc.dart'
    as _i264;
import 'package:ai_gym_assistant/features/recommendation/data/datasources/gemini_remote_data_source.dart'
    as _i489;
import 'package:ai_gym_assistant/features/recommendation/data/repositories/recommendation_repository_impl.dart'
    as _i444;
import 'package:ai_gym_assistant/features/recommendation/domain/repositories/recommendation_repository.dart'
    as _i938;
import 'package:ai_gym_assistant/features/recommendation/domain/services/ai_context_builder.dart'
    as _i576;
import 'package:ai_gym_assistant/features/recommendation/domain/services/recommendation_validator.dart'
    as _i288;
import 'package:ai_gym_assistant/features/recommendation/domain/usecases/generate_recommendation.dart'
    as _i573;
import 'package:ai_gym_assistant/features/recommendation/domain/usecases/prepare_ai_context.dart'
    as _i1051;
import 'package:ai_gym_assistant/features/recommendation/presentation/bloc/recommendation_bloc.dart'
    as _i650;
import 'package:ai_gym_assistant/features/workout/data/datasources/workout_local_data_source.dart'
    as _i915;
import 'package:ai_gym_assistant/features/workout/data/repositories/workout_repository_impl.dart'
    as _i769;
import 'package:ai_gym_assistant/features/workout/domain/repositories/workout_repository.dart'
    as _i729;
import 'package:ai_gym_assistant/features/workout/domain/usecases/finish_workout.dart'
    as _i679;
import 'package:ai_gym_assistant/features/workout/domain/usecases/get_completed_workouts.dart'
    as _i557;
import 'package:ai_gym_assistant/features/workout/domain/usecases/get_in_progress_workout_sessions.dart'
    as _i850;
import 'package:ai_gym_assistant/features/workout/domain/usecases/resume_workout.dart'
    as _i722;
import 'package:ai_gym_assistant/features/workout/domain/usecases/start_workout.dart'
    as _i256;
import 'package:ai_gym_assistant/features/workout/domain/usecases/update_exercise_set.dart'
    as _i811;
import 'package:ai_gym_assistant/features/workout/domain/usecases/watch_in_progress_workout_sessions.dart'
    as _i270;
import 'package:ai_gym_assistant/features/workout/presentation/bloc/workout_bloc.dart'
    as _i572;
import 'package:ai_gym_assistant/features/workout/presentation/cubit/active_workout_cubit.dart'
    as _i500;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i899.LongTermTrendCalculator>(
      () => _i899.LongTermTrendCalculator(),
    );
    gh.factory<_i338.SessionTargetClassifier>(
      () => _i338.SessionTargetClassifier(),
    );
    gh.lazySingleton<_i117.AppDatabase>(() => _i117.AppDatabase());
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i548.LongTermAggregateStateUpdater>(
      () => const _i548.LongTermAggregateStateUpdater(),
    );
    gh.lazySingleton<_i147.ExerciseSessionSummarizer>(
      () => _i147.ExerciseSessionSummarizer(),
    );
    gh.lazySingleton<_i576.AiContextBuilder>(() => _i576.AiContextBuilder());
    gh.lazySingleton<_i288.RecommendationValidator>(
      () => _i288.RecommendationValidator(),
    );
    gh.factory<_i26.RecentProgressAnalyzer>(
      () => _i26.RecentProgressAnalyzer(gh<_i338.SessionTargetClassifier>()),
    );
    gh.lazySingleton<_i976.UserProfileLocalDataSource>(
      () => _i976.UserProfileLocalDataSource(gh<_i117.AppDatabase>()),
    );
    gh.lazySingleton<_i346.ExerciseProgressCacheLocalDataSource>(
      () => _i346.ExerciseProgressCacheLocalDataSource(gh<_i117.AppDatabase>()),
    );
    gh.lazySingleton<_i1019.ExerciseLocalDataSource>(
      () => _i1019.ExerciseLocalDataSource(gh<_i117.AppDatabase>()),
    );
    gh.lazySingleton<_i915.WorkoutLocalDataSource>(
      () => _i915.WorkoutLocalDataSource(gh<_i117.AppDatabase>()),
    );
    gh.factory<_i516.LongTermProgressAnalyzer>(
      () => _i516.LongTermProgressAnalyzer(
        gh<_i338.SessionTargetClassifier>(),
        gh<_i899.LongTermTrendCalculator>(),
      ),
    );
    gh.lazySingleton<_i214.LongTermProgressResultUpdater>(
      () => _i214.LongTermProgressResultUpdater(
        gh<_i338.SessionTargetClassifier>(),
        gh<_i899.LongTermTrendCalculator>(),
      ),
    );
    gh.lazySingleton<_i219.ExerciseProgressCacheInitializer>(
      () => _i219.ExerciseProgressCacheInitializer(
        dataSource: gh<_i346.ExerciseProgressCacheLocalDataSource>(),
        recentAnalyzer: gh<_i26.RecentProgressAnalyzer>(),
        longTermAnalyzer: gh<_i516.LongTermProgressAnalyzer>(),
        stateUpdater: gh<_i548.LongTermAggregateStateUpdater>(),
      ),
    );
    gh.lazySingleton<_i491.ExerciseRepository>(
      () => _i170.ExerciseRepositoryImpl(gh<_i1019.ExerciseLocalDataSource>()),
    );
    gh.lazySingleton<_i971.AnonymousAuthService>(
      () => _i879.FirebaseAnonymousAuthService(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i155.RecentProgressCacheUpdater>(
      () => _i155.RecentProgressCacheUpdater(gh<_i26.RecentProgressAnalyzer>()),
    );
    gh.lazySingleton<_i651.UserProfileRepository>(
      () => _i267.UserProfileRepositoryImpl(
        gh<_i976.UserProfileLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i729.WorkoutRepository>(
      () => _i769.WorkoutRepositoryImpl(gh<_i915.WorkoutLocalDataSource>()),
    );
    gh.lazySingleton<_i489.GeminiRemoteDataSource>(
      () => _i489.GeminiRemoteDataSource(
        gh<_i971.AnonymousAuthService>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i158.GetExercises>(
      () => _i158.GetExercises(gh<_i491.ExerciseRepository>()),
    );
    gh.lazySingleton<_i498.ExerciseProgressCacheUpdater>(
      () => _i498.ExerciseProgressCacheUpdater(
        dataSource: gh<_i346.ExerciseProgressCacheLocalDataSource>(),
        recentUpdater: gh<_i155.RecentProgressCacheUpdater>(),
        stateUpdater: gh<_i548.LongTermAggregateStateUpdater>(),
        resultUpdater: gh<_i214.LongTermProgressResultUpdater>(),
      ),
    );
    gh.lazySingleton<_i557.GetCompletedWorkouts>(
      () => _i557.GetCompletedWorkouts(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i850.GetInProgressWorkoutSessions>(
      () => _i850.GetInProgressWorkoutSessions(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i722.ResumeWorkout>(
      () => _i722.ResumeWorkout(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i256.StartWorkout>(
      () => _i256.StartWorkout(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i811.UpdateExerciseSet>(
      () => _i811.UpdateExerciseSet(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i270.WatchInProgressWorkoutSessions>(
      () => _i270.WatchInProgressWorkoutSessions(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i888.GetUserProfile>(
      () => _i888.GetUserProfile(gh<_i651.UserProfileRepository>()),
    );
    gh.lazySingleton<_i917.SaveUserProfile>(
      () => _i917.SaveUserProfile(gh<_i651.UserProfileRepository>()),
    );
    gh.factory<_i1018.HistoryBloc>(
      () => _i1018.HistoryBloc(
        gh<_i557.GetCompletedWorkouts>(),
        gh<_i158.GetExercises>(),
      ),
    );
    gh.factory<_i500.ActiveWorkoutCubit>(
      () =>
          _i500.ActiveWorkoutCubit(gh<_i270.WatchInProgressWorkoutSessions>()),
    );
    gh.lazySingleton<_i398.ProgressCacheSynchronizer>(
      () => _i661.ProgressCacheSynchronizerImpl(
        gh<_i729.WorkoutRepository>(),
        gh<_i346.ExerciseProgressCacheLocalDataSource>(),
        gh<_i147.ExerciseSessionSummarizer>(),
        gh<_i219.ExerciseProgressCacheInitializer>(),
        gh<_i498.ExerciseProgressCacheUpdater>(),
      ),
    );
    gh.lazySingleton<_i679.FinishWorkout>(
      () => _i679.FinishWorkout(
        gh<_i729.WorkoutRepository>(),
        gh<_i398.ProgressCacheSynchronizer>(),
      ),
    );
    gh.lazySingleton<_i938.RecommendationRepository>(
      () => _i444.RecommendationRepositoryImpl(
        gh<_i489.GeminiRemoteDataSource>(),
        gh<_i288.RecommendationValidator>(),
      ),
    );
    gh.factory<_i534.ExerciseCatalogBloc>(
      () => _i534.ExerciseCatalogBloc(getExercises: gh<_i158.GetExercises>()),
    );
    gh.lazySingleton<_i329.GetExerciseProgress>(
      () => _i329.GetExerciseProgress(gh<_i398.ProgressCacheSynchronizer>()),
    );
    gh.factory<_i572.WorkoutBloc>(
      () => _i572.WorkoutBloc(
        startWorkout: gh<_i256.StartWorkout>(),
        resumeWorkout: gh<_i722.ResumeWorkout>(),
        updateExerciseSet: gh<_i811.UpdateExerciseSet>(),
        finishWorkout: gh<_i679.FinishWorkout>(),
      ),
    );
    gh.factory<_i165.ProfileBloc>(
      () => _i165.ProfileBloc(
        gh<_i888.GetUserProfile>(),
        gh<_i917.SaveUserProfile>(),
      ),
    );
    gh.factory<_i264.ProgressBloc>(
      () => _i264.ProgressBloc(
        gh<_i557.GetCompletedWorkouts>(),
        gh<_i158.GetExercises>(),
        gh<_i329.GetExerciseProgress>(),
      ),
    );
    gh.lazySingleton<_i1051.PrepareAiContext>(
      () => _i1051.PrepareAiContext(
        gh<_i158.GetExercises>(),
        gh<_i329.GetExerciseProgress>(),
        gh<_i576.AiContextBuilder>(),
        gh<_i888.GetUserProfile>(),
      ),
    );
    gh.lazySingleton<_i573.GenerateRecommendation>(
      () => _i573.GenerateRecommendation(
        gh<_i1051.PrepareAiContext>(),
        gh<_i938.RecommendationRepository>(),
      ),
    );
    gh.factory<_i650.RecommendationBloc>(
      () => _i650.RecommendationBloc(gh<_i573.GenerateRecommendation>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i57.FirebaseModule {}
