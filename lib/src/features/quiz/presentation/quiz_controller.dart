import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/quiz_entity.dart';
import '../domain/user_answer.dart';
import 'quiz_state.dart';
import '../data/quiz_repository.dart';
import '../../dashboard/data/daily_quiz_repository.dart';

import '../../auth/data/auth_repository.dart';

part 'quiz_controller.g.dart';

@Riverpod(keepAlive: true)
class QuizController extends _$QuizController {
  Timer? _timer;
  int _timePerQuestion = 15;

  /// Expose the time per question for UI purposes
  int get timePerQuestion => _timePerQuestion;

  @override
  QuizState? build() {
    ref.onDispose(() {
      _timer?.cancel();
      final currentState = state;
      if (currentState != null && !currentState.isCompleted) {
        ref
            .read(quizRepositoryProvider)
            .saveQuizProgress(currentState, _timePerQuestion);
        ref.invalidate(activeQuizProgressProvider);
      }
    });
    return null;
  }

  Future<void> reportQuestion({
    required String questionId,
    required String questionText,
    required List<String> options,
    required String reportReason,
    String? quizId,
    String? quizTitle,
    String? additionalComments,
  }) async {
    final userId =
        ref.read(authRepositoryProvider).currentUser?.uid ?? 'anonymous';
    final finalQuizId = quizId ?? state?.quiz.id ?? 'unknown';
    final finalQuizTitle = quizTitle ?? state?.quiz.title ?? 'Unknown Quiz';

    await ref
        .read(quizRepositoryProvider)
        .reportQuestion(
          quizId: finalQuizId,
          quizTitle: finalQuizTitle,
          questionId: questionId,
          questionText: questionText,
          options: options,
          reportReason: reportReason,
          userId: userId,
          additionalComments: additionalComments,
        );
  }

  Future<void> resumeQuiz() async {
    final progress = await ref.read(quizRepositoryProvider).getQuizProgress();
    if (progress != null) {
      final (savedState, timePerQuestion) = progress;
      _timePerQuestion = timePerQuestion;
      state = savedState;
      _startTimer();
    }
  }

  void pauseQuiz() {
    _timer?.cancel();
    final currentState = state;
    if (currentState != null && !currentState.isCompleted) {
      ref
          .read(quizRepositoryProvider)
          .saveQuizProgress(currentState, _timePerQuestion);
      ref.invalidate(activeQuizProgressProvider);
    }
  }

  void startQuiz(Quiz quiz, int timePerQuestion) {
    _timePerQuestion = timePerQuestion;
    state = QuizState(
      quiz: quiz,
      timeLeft: timePerQuestion,
      startedAt: DateTime.now(),
    );
    _startTimer();
    ref.read(quizRepositoryProvider).saveQuizProgress(state!, _timePerQuestion);
    ref.invalidate(activeQuizProgressProvider);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == null || state!.isCompleted) {
        timer.cancel();
        return;
      }

      if (state!.timeLeft > 0) {
        state = state!.copyWith(timeLeft: state!.timeLeft - 1);
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    nextQuestion();
  }

  void answerQuestion(int optionIndex) {
    if (state == null || state!.isCompleted) return;

    final currentIdx = state!.currentQuestionIndex;
    final question = state!.quiz.questions[currentIdx];

    // Get existing answer selection
    final existingAnswer = getAnswerForQuestion(currentIdx);
    List<int> currentSelected = [];

    if (existingAnswer != null) {
      if (existingAnswer.selectedIndices.isNotEmpty) {
        currentSelected = List.from(existingAnswer.selectedIndices);
      } else if (existingAnswer.selectedOptionIndex != -1) {
        currentSelected = [existingAnswer.selectedOptionIndex];
      }
    }

    List<int> newSelected = [];

    if (question.type == QuizQuestionType.multiple) {
      // Toggle logic
      newSelected = List.from(currentSelected);
      if (newSelected.contains(optionIndex)) {
        newSelected.remove(optionIndex);
      } else {
        newSelected.add(optionIndex);
      }
    } else {
      // Single choice logic (Replace)
      newSelected = [optionIndex];
    }

    // Create new UserAnswer object
    final newAnswer = UserAnswer(
      questionIndex: currentIdx,
      selectedOptionIndex: newSelected.isNotEmpty ? newSelected.first : -1,
      selectedIndices: newSelected,
      answeredAt: DateTime.now(),
    );

    // Remove any existing answer for this question and add the new one
    final updatedAnswers =
        state!.userAnswers
            .where((answer) => answer.questionIndex != currentIdx)
            .toList()
          ..add(newAnswer);

    state = state!.copyWith(userAnswers: updatedAnswers);
    ref.read(quizRepositoryProvider).saveQuizProgress(state!, _timePerQuestion);
  }

  void nextQuestion() {
    if (state == null) return;

    final nextIndex = state!.currentQuestionIndex + 1;
    if (nextIndex < state!.quiz.questions.length) {
      state = state!.copyWith(
        currentQuestionIndex: nextIndex,
        timeLeft: _timePerQuestion,
      );
      ref
          .read(quizRepositoryProvider)
          .saveQuizProgress(state!, _timePerQuestion);
    } else {
      finishQuiz();
    }
  }

  /// Navigate to the previous question
  /// Returns true if navigation was successful, false if already at first question
  bool previousQuestion() {
    if (state == null) return false;

    final prevIndex = state!.currentQuestionIndex - 1;
    if (prevIndex >= 0) {
      state = state!.copyWith(
        currentQuestionIndex: prevIndex,
        timeLeft: _timePerQuestion, // Reset timer for previous question
      );
      ref
          .read(quizRepositoryProvider)
          .saveQuizProgress(state!, _timePerQuestion);
      return true;
    }
    return false; // Already at first question
  }

  /// Check if we can go to the previous question
  bool get canGoPrevious => state != null && state!.currentQuestionIndex > 0;

  Future<void> finishQuiz() async {
    _timer?.cancel();
    state = state!.copyWith(isCompleted: true);

    final result = getQuizResult();
    if (result != null) {
      await ref.read(quizRepositoryProvider).saveQuizResult(result);
      await ref.read(quizRepositoryProvider).clearQuizProgress(state!.quiz.id);

      ref.invalidate(recentQuizResultsProvider);
      ref.invalidate(allQuizResultsProvider);
      ref.invalidate(activeQuizProgressProvider);
      ref.invalidate(dailyQuizProvider);
    }
  }

  // Helper method to get answer for a specific question
  UserAnswer? getAnswerForQuestion(int questionIndex) {
    if (state == null) return null;
    try {
      return state!.userAnswers.firstWhere(
        (answer) => answer.questionIndex == questionIndex,
      );
    } catch (e) {
      return null;
    }
  }

  // Helper method to check if question is answered
  bool isQuestionAnswered(int questionIndex) {
    return getAnswerForQuestion(questionIndex) != null;
  }

  // Create QuizResult object when quiz is completed
  QuizResult? getQuizResult() {
    if (state == null || !state!.isCompleted) return null;

    int correctAnswers = 0;
    for (final answer in state!.userAnswers) {
      final question = state!.quiz.questions[answer.questionIndex];

      if (question.type == QuizQuestionType.multiple) {
        // Multiple choice scoring
        final selectedSet = answer.selectedIndices.toSet();
        final correctSet = question.correctIndices.toSet();

        // Fallback if correctIndices empty (legacy)
        if (correctSet.isEmpty) {
          correctSet.add(question.correctOptionIndex);
        }

        // Strict equality
        if (selectedSet.length == correctSet.length &&
            selectedSet.containsAll(correctSet)) {
          correctAnswers++;
        }
      } else {
        // Single choice scoring
        final selected = answer.selectedIndices.isNotEmpty
            ? answer.selectedIndices.first
            : answer.selectedOptionIndex;

        if (selected == question.correctOptionIndex) {
          correctAnswers++;
        }
      }
    }

    final totalQuestions = state!.quiz.questions.length;
    final percentage = totalQuestions > 0
        ? (correctAnswers / totalQuestions) * 100
        : 0.0;

    return QuizResult(
      quizId: state!.quiz.id,
      quiz: state!.quiz,
      answers: state!.userAnswers,
      startedAt: state!.startedAt,
      completedAt: DateTime.now(),
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      percentage: percentage,
    );
  }
}
