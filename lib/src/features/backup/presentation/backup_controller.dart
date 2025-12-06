import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer';
import '../domain/backup_snapshot.dart';
import '../application/backup_service.dart';
import '../data/backup_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../quiz/data/quiz_repository.dart';

part 'backup_controller.g.dart';

@riverpod
class BackupController extends _$BackupController {
  @override
  FutureOr<void> build() {
    // Initial state is void (idle)
  }

  Future<void> createBackup() async {
    log('BackupController: createBackup called');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(backupServiceProvider).createBackup();
    });
  }

  Future<void> restoreBackup({bool merge = true}) async {
    log('BackupController: restoreBackup called with merge=$merge');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(backupServiceProvider).restoreBackup(merge: merge);
      // Refresh quiz data
      ref.invalidate(allQuizResultsProvider);
      ref.invalidate(recentQuizResultsProvider);
      ref.invalidate(activeQuizProgressProvider);
    });
  }

  Future<void> deleteBackup() async {
    log('BackupController: deleteBackup called');
    state = const AsyncLoading();
    final userId = ref.read(authRepositoryProvider).currentUser?.uid ?? '';
    state = await AsyncValue.guard(() async {
      await ref.read(backupRepositoryProvider).deleteBackup(userId);
    });
  }
}

@riverpod
Stream<BackupSnapshot?> backupStream(Ref ref) {
  final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (userId == null) return Stream.value(null);
  return ref.watch(backupRepositoryProvider).watchBackup(userId);
}
