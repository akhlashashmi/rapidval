import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/backup_snapshot.dart';

class BackupRepository {
  final FirebaseFirestore _firestore;

  BackupRepository(this._firestore);

  /// Saves a backup snapshot to `backups/{userId}`.
  /// Overwrites any existing backup.
  Future<void> saveBackup(BackupSnapshot backup) async {
    try {
      log('BackupRepository: Saving backup for user ${backup.userId}');
      await _firestore.collection('backups').doc(backup.userId).set({
        ...backup.toJson(),
        'metadata': backup.metadata.toJson(),
      });
      log('BackupRepository: Backup saved successfully');
    } catch (e, s) {
      log('BackupRepository: Error saving backup', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Fetches the backup snapshot from `backups/{userId}`.
  Future<BackupSnapshot?> getBackup(String userId) async {
    try {
      log('BackupRepository: Fetching backup for user $userId');
      final doc = await _firestore.collection('backups').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return BackupSnapshot.fromJson(doc.data()!);
      }
      return null;
    } catch (e, s) {
      log('BackupRepository: Error fetching backup', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Watches the backup snapshot from `backups/{userId}`.
  Stream<BackupSnapshot?> watchBackup(String userId) {
    return _firestore.collection('backups').doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return BackupSnapshot.fromJson(doc.data()!);
      }
      return null;
    });
  }

  /// Deletes the backup snapshot at `backups/{userId}`.
  Future<void> deleteBackup(String userId) async {
    try {
      log('BackupRepository: Deleting backup for user $userId');
      await _firestore.collection('backups').doc(userId).delete();
      log('BackupRepository: Backup deleted successfully');
    } catch (e, s) {
      log('BackupRepository: Error deleting backup', error: e, stackTrace: s);
      rethrow;
    }
  }
}

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(FirebaseFirestore.instance);
});
