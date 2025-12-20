import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../quiz/domain/quiz_history_item.dart';
import '../../quiz/data/quiz_repository.dart';
import '../../auth/data/auth_repository.dart';

part 'history_controller.g.dart';

@Riverpod(keepAlive: true)
class HistoryController extends _$HistoryController {
  // Real-time recent items (HEAD)
  List<QuizHistoryItem> _head = [];
  // Paged older items (TAIL)
  List<QuizHistoryItem> _tail = [];

  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  @override
  Future<List<QuizHistoryItem>> build() async {
    // Force rebuild when user changes
    ref.watch(authStateChangesProvider);

    final repo = ref.watch(quizRepositoryProvider);

    // Subscribe to head changes for real-time updates
    final subscription = repo.watchQuizHistory(limit: 20).listen((items) {
      _head = items;
      // Update state without triggering a full rebuild/loading state
      state = AsyncValue.data(_merge(_head, _tail));
    });

    ref.onDispose(subscription.cancel);

    // Return initial state
    _head = await repo.watchQuizHistory(limit: 20).first;
    return _merge(_head, _tail);
  }

  List<QuizHistoryItem> _merge(
    List<QuizHistoryItem> head,
    List<QuizHistoryItem> tail,
  ) {
    final headIds = head.map((e) => e.quiz.id).toSet();
    // Deduplicate: If an item is in HEAD, don't show it in TAIL.
    final filteredTail = tail
        .where((e) => !headIds.contains(e.quiz.id))
        .toList();
    return [...head, ...filteredTail];
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    // Use current state to find the cursor
    final currentList = state.asData?.value;
    if (currentList == null || currentList.isEmpty) return;

    _isLoadingMore = true;

    // Notify UI of loading state change (optional, if UI watches notifier)
    // Since we can't easily notify strictly for property change,

    try {
      final lastItem = currentList.last;
      final cursorDate =
          lastItem.result?.completedAt ?? lastItem.quiz.createdAt;

      final repo = ref.read(quizRepositoryProvider);
      final newPage = await repo.getQuizHistoryPage(
        beforeDate: cursorDate,
        limit: 20,
      );

      if (newPage.isEmpty) {
        _hasMore = false;
      } else {
        _tail = [..._tail, ...newPage];
        state = AsyncValue.data(_merge(_head, _tail));
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoadingMore = false;
      // If we failed or finished, we might want to trigger update to hide spinner?
      // Re-emitting state does that.
      if (state.hasValue) {
        state = AsyncValue.data(_merge(_head, _tail));
      }
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    final repo = ref.read(quizRepositoryProvider);
    await repo.deleteQuizzes([quizId]);

    // Remove from local tail immediately
    _tail.removeWhere((item) => item.quiz.id == quizId);

    // Update state immediately (Head will update via stream shortly, but local update feels faster)
    // Actually, waiting for stream is safer for Head consistency, but we can do optimistic update.
    // Since Head comes from stream, we shouldn't manually mutate _head unless we know it won't conflict.
    // But we CAN mutate the result of _merge.

    // Best practice: Let stream handle Head. We handle Tail.
    // Force a re-merge to reflect Tail change.
    state = AsyncValue.data(_merge(_head, _tail));
  }
}
