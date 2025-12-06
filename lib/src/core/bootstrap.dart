import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

  // Set up Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

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
