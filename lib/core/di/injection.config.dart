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
    gh.factory<_i26.RecentProgressAnalyzer>(
      () => _i26.RecentProgressAnalyzer(gh<_i338.SessionTargetClassifier>()),
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
    gh.lazySingleton<_i729.WorkoutRepository>(
      () => _i769.WorkoutRepositoryImpl(gh<_i915.WorkoutLocalDataSource>()),
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
    return this;
  }
}
