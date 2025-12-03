import 'package:rapidval/src/features/quiz/domain/user_answer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../quiz/data/quiz_repository.dart';

part 'dashboard_stats_provider.g.dart';

class DashboardStats {
  final int totalQuizzes;
  final int averageScore;
  final int streak;
  final String bestTopic;

  DashboardStats({
    required this.totalQuizzes,
    required this.averageScore,
    required this.streak,
    required this.bestTopic,
  });
}

@riverpod
Future<DashboardStats> dashboardStats(Ref ref) async {
  final results = await ref.watch(allQuizResultsProvider.future);

  if (results.isEmpty) {
    return DashboardStats(
      totalQuizzes: 0,
      averageScore: 0,
      streak: 0,
      bestTopic: 'N/A',
    );
  }

  final totalQuizzes = results.length;
  final averageScore =
      (results.fold(0.0, (sum, r) => sum + r.percentage) / totalQuizzes)
          .round();

  // Calculate Streak
  // Sort by completedAt descending
  final sortedResults = List<QuizResult>.from(results)
    ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

  int streak = 0;

  // Check if the user has done a quiz today or yesterday to keep the streak alive
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  if (sortedResults.isNotEmpty) {
    final lastQuizDate = sortedResults.first.completedAt;
    final lastQuizDay = DateTime(
      lastQuizDate.year,
      lastQuizDate.month,
      lastQuizDate.day,
    );

    // If the last quiz was today or yesterday, the streak is active
    if (today.difference(lastQuizDay).inDays <= 1) {
      streak = 1;
      DateTime currentLastDate = lastQuizDay;

      for (int i = 1; i < sortedResults.length; i++) {
        final currentDate = sortedResults[i].completedAt;
        final currentDay = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );

        if (currentDay.isAtSameMomentAs(currentLastDate)) {
          continue; // Same day, ignore
        } else if (currentLastDate.difference(currentDay).inDays == 1) {
          streak++;
          currentLastDate = currentDay;
        } else {
          break; // Streak broken
        }
      }
    }
  }

  // Best Topic (Topic with highest average score)
  // Group by category
  final Map<String, List<double>> categoryScores = {};
  for (var result in results) {
    categoryScores
        .putIfAbsent(result.quiz.category, () => [])
        .add(result.percentage);
  }

  String bestTopic = 'N/A';
  double maxAvg = -1;

  categoryScores.forEach((category, scores) {
    final avg = scores.reduce((a, b) => a + b) / scores.length;
    if (avg > maxAvg) {
      maxAvg = avg;
      bestTopic = category;
    }
  });

  return DashboardStats(
    totalQuizzes: totalQuizzes,
    averageScore: averageScore,
    streak: streak,
    bestTopic: bestTopic,
  );
}
