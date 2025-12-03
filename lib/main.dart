import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapidval/firebase_options.dart';
import 'src/app.dart';
import 'src/core/services/local_storage/hive_storage_service.dart';

// import 'firebase_options.dart'; // Uncomment after running flutterfire configure
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (commented out until configured)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Local Storage (Hive)
  final container = ProviderContainer();
  await container.read(localStorageServiceProvider).init();

  runApp(ProviderScope(child: const RapidValApp()));
}
