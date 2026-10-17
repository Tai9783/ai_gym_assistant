// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:ai_gym_assistant/core/database/app_database.dart' as _i117;
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
import 'package:ai_gym_assistant/features/recommendation/domain/services/ai_context_builder.dart'
    as _i576;
import 'package:ai_gym_assistant/features/recommendation/domain/usecases/prepare_ai_context.dart'
    as _i1051;
import 'package:ai_gym_assistant/features/workout/data/datasources/workout_local_data_source.dart'
    as _i915;
import 'package:ai_gym_assistant/features/workout/data/repositories/workout_repository_impl.dart'
    as _i769;
import 'package:ai_gym_assistant/features/workout/domain/repositories/workout_repository.dart'
    as _i729;
import 'package:ai_gym_assistant/features/workout/domain/usecases/finish_workout.dart'
    as _i679;
import 'package:ai_gym_assistant/features/workout/domain/usecases/start_workout.dart'
    as _i256;
import 'package:ai_gym_assistant/features/workout/domain/usecases/update_exercise_set.dart'
    as _i811;
import 'package:ai_gym_assistant/features/workout/presentation/bloc/workout_bloc.dart'
    as _i572;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i899.LongTermTrendCalculator>(
      () => _i899.LongTermTrendCalculator(),
    );
    gh.factory<_i338.SessionTargetClassifier>(
      () => _i338.SessionTargetClassifier(),
    );
    gh.lazySingleton<_i117.AppDatabase>(() => _i117.AppDatabase());
    gh.lazySingleton<_i147.ExerciseSessionSummarizer>(
      () => _i147.ExerciseSessionSummarizer(),
    );
    gh.lazySingleton<_i576.AiContextBuilder>(() => _i576.AiContextBuilder());
    gh.factory<_i26.RecentProgressAnalyzer>(
      () => _i26.RecentProgressAnalyzer(gh<_i338.SessionTargetClassifier>()),
    );
    gh.lazySingleton<_i976.UserProfileLocalDataSource>(
      () => _i976.UserProfileLocalDataSource(gh<_i117.AppDatabase>()),
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
    gh.lazySingleton<_i491.ExerciseRepository>(
      () => _i170.ExerciseRepositoryImpl(gh<_i1019.ExerciseLocalDataSource>()),
    );
    gh.lazySingleton<_i651.UserProfileRepository>(
      () => _i267.UserProfileRepositoryImpl(
        gh<_i976.UserProfileLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i729.WorkoutRepository>(
      () => _i769.WorkoutRepositoryImpl(gh<_i915.WorkoutLocalDataSource>()),
    );
    gh.lazySingleton<_i329.GetExerciseProgress>(
      () => _i329.GetExerciseProgress(
        gh<_i729.WorkoutRepository>(),
        gh<_i147.ExerciseSessionSummarizer>(),
        gh<_i26.RecentProgressAnalyzer>(),
        gh<_i516.LongTermProgressAnalyzer>(),
      ),
    );
    gh.lazySingleton<_i158.GetExercises>(
      () => _i158.GetExercises(gh<_i491.ExerciseRepository>()),
    );
    gh.lazySingleton<_i679.FinishWorkout>(
      () => _i679.FinishWorkout(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i256.StartWorkout>(
      () => _i256.StartWorkout(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i811.UpdateExerciseSet>(
      () => _i811.UpdateExerciseSet(gh<_i729.WorkoutRepository>()),
    );
    gh.lazySingleton<_i888.GetUserProfile>(
      () => _i888.GetUserProfile(gh<_i651.UserProfileRepository>()),
    );
    gh.lazySingleton<_i917.SaveUserProfile>(
      () => _i917.SaveUserProfile(gh<_i651.UserProfileRepository>()),
    );
    gh.lazySingleton<_i1051.PrepareAiContext>(
      () => _i1051.PrepareAiContext(
        gh<_i158.GetExercises>(),
        gh<_i329.GetExerciseProgress>(),
        gh<_i576.AiContextBuilder>(),
        gh<_i888.GetUserProfile>(),
      ),
    );
    gh.factory<_i572.WorkoutBloc>(
      () => _i572.WorkoutBloc(
        startWorkout: gh<_i256.StartWorkout>(),
        updateExerciseSet: gh<_i811.UpdateExerciseSet>(),
        finishWorkout: gh<_i679.FinishWorkout>(),
      ),
    );
    gh.factory<_i534.ExerciseCatalogBloc>(
      () => _i534.ExerciseCatalogBloc(getExercises: gh<_i158.GetExercises>()),
    );
    gh.factory<_i165.ProfileBloc>(
      () => _i165.ProfileBloc(
        gh<_i888.GetUserProfile>(),
        gh<_i917.SaveUserProfile>(),
      ),
    );
    return this;
  }
}
