import 'dart:developer' as developer;

import 'package:ai_gym_assistant/app/theme/app_theme.dart';
import 'package:ai_gym_assistant/app/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'features/progress/domain/repositories/progress_cache_synchronizer.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();

  try {
    await getIt<ProgressCacheSynchronizer>()
        .recoverPendingProgressUpdates();
  } catch (error, stackTrace) {
    developer.log(
      'Pending Progress Cache recovery failed',
      name: 'ProgressCache',
      error: error,
      stackTrace: stackTrace,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.light,
    );
  }
}