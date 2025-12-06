import 'package:freezed_annotation/freezed_annotation.dart';
import 'quiz_entity.dart';
import 'user_answer.dart';

part 'quiz_history_item.freezed.dart';

@freezed
abstract class QuizHistoryItem with _$QuizHistoryItem {
  const factory QuizHistoryItem({required Quiz quiz, QuizResult? result}) =
      _QuizHistoryItem;
}
