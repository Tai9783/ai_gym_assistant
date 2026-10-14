// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:ai_gym_assistant/core/database/app_database.dart' as _i117;
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
    gh.lazySingleton<_i117.AppDatabase>(() => _i117.AppDatabase());
    gh.lazySingleton<_i915.WorkoutLocalDataSource>(
      () => _i915.WorkoutLocalDataSource(gh<_i117.AppDatabase>()),
    );
    gh.lazySingleton<_i729.WorkoutRepository>(
      () => _i769.WorkoutRepositoryImpl(gh<_i915.WorkoutLocalDataSource>()),
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
    return this;
  }
}
