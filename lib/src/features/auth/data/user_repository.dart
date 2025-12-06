import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user_profile.dart';

part 'user_repository.g.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> createUserProfile(UserProfile profile) async {
    debugPrint('UserRepository: Creating profile for ${profile.uid}');
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toJson());
      debugPrint('UserRepository: Profile created');
    } catch (e) {
      debugPrint('UserRepository: Error creating profile: $e');
      rethrow;
    }
  }

  Stream<UserProfile?> watchUserProfile(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            return UserProfile.fromJson(doc.data()!);
          }
          return null;
        })
        .handleError((error) {
          debugPrint('UserRepository: Error watching profile: $error');
          // Return null on error to avoid stream crash/loop
          return null;
        });
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('UserRepository: Error getting profile: $e');
      return null;
    }
  }

  Future<void> updateCategories(String uid, List<String> categories) async {
    debugPrint('UserRepository: Updating categories for $uid');
    try {
      await _firestore.collection('users').doc(uid).update({
        'selectedCategories': categories,
        'hasCompletedOnboarding': true,
      });
      debugPrint('UserRepository: Categories updated');
    } catch (e) {
      debugPrint('UserRepository: Error updating categories: $e');
      rethrow;
    }
  }

  Future<void> updateName(String uid, String name) async {
    debugPrint('UserRepository: Updating name for $uid to $name');
    try {
      await _firestore.collection('users').doc(uid).update({'name': name});
      debugPrint('UserRepository: Name updated');
    } catch (e) {
      debugPrint('UserRepository: Error updating name: $e');
      rethrow;
    }
  }

  Future<void> deleteUserData(String uid) async {
    debugPrint('UserRepository: Deleting user data for $uid');
    try {
      final batch = _firestore.batch();

      // Delete user profile
      final userDoc = _firestore.collection('users').doc(uid);
      batch.delete(userDoc);

      // Delete user backup
      final backupDoc = _firestore.collection('backups').doc(uid);
      batch.delete(backupDoc);

      await batch.commit();
      debugPrint('UserRepository: User data deleted successfully');
    } catch (e) {
      debugPrint('UserRepository: Error deleting user data: $e');
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}
