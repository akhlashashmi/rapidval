import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/quiz/presentation/quiz_screen.dart';
import '../../features/quiz/presentation/results_screen.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/category_selection_screen.dart';

import '../../features/history/presentation/history_screen.dart';
import '../../features/quiz/domain/user_answer.dart';
import '../services/local_storage/hive_storage_service.dart';
import '../../features/home/presentation/home_screen.dart';

import '../../features/auth/presentation/verify_email_screen.dart';
import '../../features/quiz/domain/quiz_entity.dart';
import '../../features/dashboard/presentation/create_quiz_screen.dart';
import '../../features/auth/presentation/user_controller.dart';
import '../../features/backup/presentation/backup_screen.dart';
import '../../features/settings/presentation/legal/privacy_policy_screen.dart';
import '../../features/settings/presentation/legal/terms_of_service_screen.dart';

import '../../features/onboarding/presentation/splash_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userProfileAsync = ref.watch(userProfileProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      // 1. Loading State: Stay on /splash until we have definitive state
      if (authState.isLoading ||
          (authState.hasValue &&
              authState.value != null &&
              userProfileAsync.isLoading)) {
        return '/splash';
      }

      final isLoggedIn = authState.value != null;
      final isSplashRoute = state.uri.path == '/splash';
      final isAuthRoute = state.uri.path == '/auth';
      final isOnboardingRoute = state.uri.path == '/onboarding';
      final isVerifyEmailRoute = state.uri.path == '/verify-email';
      final isCategorySelectionRoute = state.uri.path == '/category-selection';

      final onboardingSeen = ref
          .read(localStorageServiceProvider)
          .get('settings', 'onboarding_seen', defaultValue: false);

      if (!onboardingSeen && !isLoggedIn) {
        if (isOnboardingRoute) return null;
        return '/onboarding';
      }

      if (onboardingSeen && isOnboardingRoute) {
        return '/auth';
      }

      if (!isLoggedIn) {
        if (isSplashRoute) return '/auth';
        return (isAuthRoute || isOnboardingRoute) ? null : '/auth';
      }

      if (isLoggedIn) {
        final user = authState.value;
        final isEmailVerified = user?.emailVerified ?? false;

        if (!isEmailVerified) {
          if (isVerifyEmailRoute) return null;
          return '/verify-email';
        }

        // Check profile for category selection
        final userProfile = userProfileAsync.value;

        // Only redirect if we have a profile loaded
        if (userProfile != null) {
          if (!userProfile.hasCompletedOnboarding) {
            if (!isCategorySelectionRoute) {
              return '/category-selection';
            }
            return null;
          }

          // If completed onboarding but trying to access category selection (e.g. back button),
          // we might want to allow it if it's from settings, but here we assume it's the onboarding flow.
          // For now, let's redirect to dashboard if they are done.
          if (isCategorySelectionRoute) {
            return '/dashboard';
          }
        }

        if (isEmailVerified && isVerifyEmailRoute) {
          return '/dashboard';
        }

        if (isAuthRoute || isOnboardingRoute || isSplashRoute) {
          return '/dashboard';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Shell Route for Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/quiz',
        builder: (context, state) {
          String? returnPath;
          bool isReviewMode = false;
          QuizResult? quizResult;

          if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            returnPath = map['returnPath'] as String?;
            isReviewMode = map['isReviewMode'] as bool? ?? false;
            quizResult = map['quizResult'] as QuizResult?;
          }

          return QuizScreen(
            returnPath: returnPath,
            isReviewMode: isReviewMode,
            quizResult: quizResult,
          );
        },
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) {
          QuizResult result;
          String? returnPath;

          final extra = state.extra;
          if (extra is QuizResult) {
            result = extra;
          } else if (extra is Map<String, dynamic>) {
            result = extra['result'] as QuizResult;
            returnPath = extra['returnPath'] as String?;
          } else {
            // Should not happen if strictly typed, but good to fallback or error
            throw Exception('Invalid argument for /results');
          }

          return ResultsScreen(quizResult: result, returnPath: returnPath);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        parentNavigatorKey:
            _rootNavigatorKey, // Ensure settings covers the nav bar
      ),
      GoRoute(
        path: '/create-quiz',
        builder: (context, state) {
          final existingQuiz = state.extra as Quiz?;
          return CreateQuizScreen(existingQuiz: existingQuiz);
        },
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: '/category-selection',
        builder: (context, state) => const CategorySelectionScreen(),
      ),
      GoRoute(
        path: '/manage-topics',
        builder: (context, state) =>
            const CategorySelectionScreen(isSettingsMode: true),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: '/backups',
        builder: (context, state) => const BackupScreen(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: '/terms-of-service',
        builder: (context, state) => const TermsOfServiceScreen(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
    ],
  );
}
