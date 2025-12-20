import 'dart:developer';
import 'package:intl/intl.dart';
import '../../../core/services/local_storage/hive_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/cerebras_service.dart';
import '../../../core/services/local_storage/local_storage_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../quiz/data/quiz_repository.dart';
import '../../quiz/domain/quiz_entity.dart';

part 'daily_quiz_repository.g.dart';

class DailyQuizRepository {
  final CerebrasService _cerebrasService;
  final QuizRepository _quizRepository;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final LocalStorageService _hiveService;

  DailyQuizRepository(
    this._cerebrasService,
    this._quizRepository,
    this._userRepository,
    this._authRepository,
    this._hiveService,
  );

  // Static variable to persist across provider rebuilds
  static DateTime? _nextAllowedRequestTime;
  static bool _isGenerating = false;

  Future<Quiz?> getDailyQuiz() async {
    // If generation is already in progress, wait for it or return null (debounce)
    // For this use case, if one is generating, others should probably wait or just return null and wait for stream update
    // But since this is a Future, let's just return null if busy to avoid duplicate API calls.
    // The UI will likely retry or loading state persists.
    if (_isGenerating) {
      log(
        'DailyQuizRepository: Generation already in progress. Skipping duplicate request.',
      );
      return null;
    }

    try {
      final user = _authRepository.currentUser;
      if (user == null) {
        log('DailyQuizRepository: No user logged in.');
        return null;
      }
      final userId = user.uid;

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      log(
        'DailyQuizRepository: Checking for daily quiz. Today: $today, User: $userId',
      );

      final storedDate = _hiveService.get('daily_quiz', 'date_$userId');
      final storedQuizId = _hiveService.get('daily_quiz', 'quiz_id_$userId');

      log(
        'DailyQuizRepository: Stored date: $storedDate, Stored ID: $storedQuizId',
      );

      if (storedDate == today && storedQuizId != null) {
        log('DailyQuizRepository: Found stored daily quiz ID: $storedQuizId');

        // Check if completed
        final isCompleted = await _quizRepository.isQuizCompleted(storedQuizId);
        if (isCompleted) {
          log('DailyQuizRepository: Daily quiz already completed. Hiding.');
          return null;
        }

        final quiz = await _quizRepository.getQuizById(storedQuizId);
        if (quiz != null) {
          log('DailyQuizRepository: Retrieved stored quiz successfully.');
          return quiz;
        } else {
          log(
            'DailyQuizRepository: Stored quiz not found in DB. Generating new one.',
          );
        }
      }

      _isGenerating = true;
      try {
        return await _generateNewDailyQuiz(today);
      } finally {
        _isGenerating = false;
      }
    } catch (e, stack) {
      _isGenerating = false;
      log(
        'DailyQuizRepository: Error in getDailyQuiz',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<void> refreshDailyQuiz() async {
    final user = _authRepository.currentUser;
    if (user == null) return;

    log('DailyQuizRepository: Refreshing daily quiz for user ${user.uid}...');
    await _hiveService.delete('daily_quiz', 'date_${user.uid}');
    await _hiveService.delete('daily_quiz', 'quiz_id_${user.uid}');
  }

  Future<Quiz?> _generateNewDailyQuiz(String today) async {
    log('DailyQuizRepository: Generating new daily quiz...');
    try {
      final user = _authRepository.currentUser;
      if (user == null) {
        log('DailyQuizRepository: No user logged in.');
        return null;
      }

      // Circuit Breaker: Check if we are in a cooldown period
      if (_nextAllowedRequestTime != null &&
          DateTime.now().isBefore(_nextAllowedRequestTime!)) {
        log(
          'DailyQuizRepository: API rate limited. Skipping request until $_nextAllowedRequestTime',
        );
        return null;
      }

      List<String> selectedTopics = [];

      // 1. Get User Preferences
      List<String> preferenceTopics = [];
      try {
        final profile = await _userRepository.getUserProfile(user.uid);
        if (profile != null) {
          preferenceTopics = profile.selectedCategories
              .map((c) => c.replaceAll('_', ' '))
              .toList();
          log('DailyQuizRepository: Preference topics: $preferenceTopics');
        }
      } catch (e) {
        log('DailyQuizRepository: Error fetching user profile', error: e);
      }

      // 2. Get Recent History Topics
      List<String> historyTopics = [];
      try {
        final recentResults = await _quizRepository.getRecentResults(limit: 10);
        if (recentResults.isNotEmpty) {
          historyTopics = recentResults.map((r) => r.quiz.topic).toList();
          log('DailyQuizRepository: History topics: $historyTopics');
        }
      } catch (e) {
        log('DailyQuizRepository: Error fetching recent results', error: e);
      }

      // 3. Intelligent Selection Logic
      if (preferenceTopics.isNotEmpty && historyTopics.isNotEmpty) {
        // Find intersection: topics in history that are also in preferences
        final intersection = historyTopics
            .where((t) => preferenceTopics.contains(t))
            .toList();

        if (intersection.isNotEmpty) {
          // Find the most frequent topic in the intersection
          final frequencyMap = <String, int>{};
          for (var t in intersection) {
            frequencyMap[t] = (frequencyMap[t] ?? 0) + 1;
          }

          // Sort by frequency descending
          final sortedTopics = frequencyMap.keys.toList()
            ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));

          selectedTopics = [sortedTopics.first];
          log(
            'DailyQuizRepository: Selected most frequent topic from intersection: $selectedTopics',
          );
        } else {
          // No intersection, pick random from preferences (higher priority)
          preferenceTopics.shuffle();
          selectedTopics = [preferenceTopics.first];
          log(
            'DailyQuizRepository: No intersection. Selected random preference: $selectedTopics',
          );
        }
      } else if (preferenceTopics.isNotEmpty) {
        preferenceTopics.shuffle();
        selectedTopics = [preferenceTopics.first];
        log(
          'DailyQuizRepository: Only preferences available. Selected random: $selectedTopics',
        );
      } else if (historyTopics.isNotEmpty) {
        // Find most frequent in history
        final frequencyMap = <String, int>{};
        for (var t in historyTopics) {
          frequencyMap[t] = (frequencyMap[t] ?? 0) + 1;
        }
        final sortedTopics = frequencyMap.keys.toList()
          ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));
        selectedTopics = [sortedTopics.first];
        log(
          'DailyQuizRepository: Only history available. Selected most frequent: $selectedTopics',
        );
      }

      // 4. Fallback
      if (selectedTopics.isEmpty) {
        selectedTopics = [
          'General Knowledge',
          'Science',
          'History',
          'Technology',
        ];
        log('DailyQuizRepository: Using fallback topics');
      }

      final quiz = await _cerebrasService.generateDailyQuiz(selectedTopics);
      log('DailyQuizRepository: Quiz generated successfully: ${quiz.id}');

      // Save to DB
      await _quizRepository.saveQuizToDb(quiz);
      log('DailyQuizRepository: Quiz saved to DB');

      // Update Hive
      await _hiveService.put('daily_quiz', 'date_${user.uid}', today);
      await _hiveService.put('daily_quiz', 'quiz_id_${user.uid}', quiz.id);
      log('DailyQuizRepository: Hive updated');

      return quiz;
    } catch (e, stack) {
      log(
        'DailyQuizRepository: Error generating daily quiz. Activating circuit breaker.',
        error: e,
        stackTrace: stack,
      );
      // Set cooldown to 5 minutes to prevent loop
      _nextAllowedRequestTime = DateTime.now().add(const Duration(minutes: 5));
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
DailyQuizRepository dailyQuizRepository(Ref ref) {
  return DailyQuizRepository(
    ref.watch(cerebrasServiceProvider),
    ref.watch(quizRepositoryProvider),
    ref.watch(userRepositoryProvider),
    ref.watch(authRepositoryProvider),
    ref.watch(localStorageServiceProvider),
  );
}

@riverpod
Future<Quiz?> dailyQuiz(Ref ref) {
  return ref.watch(dailyQuizRepositoryProvider).getDailyQuiz();
}
