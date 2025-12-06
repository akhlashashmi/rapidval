import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rapidval/firebase_options.dart';
import 'package:rapidval/src/core/services/local_storage/hive_storage_service.dart';
import 'package:rapidval/src/features/dashboard/presentation/dashboard_stats_provider.dart';
import 'package:rapidval/src/features/quiz/data/quiz_repository.dart';

Future<ProviderContainer> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load Environment Variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();

  // Initialize Local Storage (Hive)
  await container.read(localStorageServiceProvider).init();

  // Warm up critical providers
  // We use .future to wait for the async data to be loaded
  await Future.wait([
    container.read(dashboardStatsProvider.future),
    container.read(recentQuizResultsProvider.future),
    container.read(activeQuizProgressProvider.future),
  ]);

  return container;
}
