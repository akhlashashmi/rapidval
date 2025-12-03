import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'core/theme/theme_controller.dart';

class RapidValApp extends ConsumerWidget {
  const RapidValApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final appThemes = ref.watch(appThemesProvider);

    return MaterialApp.router(
      title: 'RapidVal AI Quiz',
      theme: appThemes.materialLightTheme,
      darkTheme: appThemes.materialDarkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
