import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user_profile.dart';
import 'user_repository.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserRepository _userRepository;

  AuthRepository(this._auth, this._userRepository);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    debugPrint('AuthRepository: signInWithEmailAndPassword called for $email');
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      debugPrint('AuthRepository: signInWithEmailAndPassword success');
    } catch (e) {
      debugPrint('AuthRepository: signInWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    debugPrint(
      'AuthRepository: createUserWithEmailAndPassword called for $email, name: $name',
    );
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('AuthRepository: User created: ${userCredential.user?.uid}');

      await userCredential.user?.updateDisplayName(name);
      debugPrint('AuthRepository: Display name updated');

      // Create User Profile
      if (userCredential.user != null) {
        final profile = UserProfile(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
        );
        await _userRepository.createUserProfile(profile);
        debugPrint('AuthRepository: User profile created in Firestore');
      }

      // IMPORTANT: Add a small delay to ensure Firebase has fully processed the user
      await Future.delayed(const Duration(milliseconds: 800));

      // Send verification email
      await sendEmailVerification();
      debugPrint('AuthRepository: Verification email sent');
    } catch (e) {
      debugPrint('AuthRepository: createUserWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    debugPrint('AuthRepository: signInWithGoogle called');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('AuthRepository: Google Sign In aborted by user');
        return null;
      }
      debugPrint('AuthRepository: Google User obtained: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint(
        'AuthRepository: Google Sign In success: ${userCredential.user?.uid}',
      );

      // Create profile if it doesn't exist (for Google Sign In)
      if (userCredential.user != null) {
        final existingProfile = await _userRepository.getUserProfile(
          userCredential.user!.uid,
        );
        if (existingProfile == null) {
          final profile = UserProfile(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            name: userCredential.user!.displayName ?? 'User',
          );
          await _userRepository.createUserProfile(profile);
          debugPrint('AuthRepository: User profile created for Google user');
        }
      }

      return userCredential.user;
    } catch (e) {
      debugPrint('AuthRepository: signInWithGoogle error: $e');
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    debugPrint('AuthRepository: sendEmailVerification called');
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('AuthRepository: No user logged in');
        throw Exception('No user logged in');
      }

      if (user.emailVerified) {
        debugPrint('AuthRepository: Email already verified');
        return;
      }

      // For mobile-only apps, use simple ActionCodeSettings
      // This tells Firebase to send emails even without a custom domain
      final actionCodeSettings = ActionCodeSettings(
        // Use your Firebase hosting URL - this is automatically whitelisted
        url: 'https://rapidval.firebaseapp.com',
        // Set to false for mobile apps (you're not handling the link in-app)
        handleCodeInApp: false,
        // Add your Android package name from AndroidManifest.xml
        androidPackageName: 'dev.akhlasahmed.rapidval',
        // If you want the app to open after verification
        androidInstallApp: false,
      );

      await user.sendEmailVerification(actionCodeSettings);

      debugPrint('✅ AuthRepository: Verification email sent to ${user.email}');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ AuthRepository: FirebaseAuthException: ${e.code}');
      debugPrint('❌ Message: ${e.message}');

      switch (e.code) {
        case 'too-many-requests':
          throw Exception('Too many requests. Please try again in an hour.');
        case 'user-not-found':
          throw Exception('User not found. Please sign in again.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'network-request-failed':
          throw Exception('Network error. Check your internet connection.');
        default:
          throw Exception('Failed to send email: ${e.message}');
      }
    } catch (e) {
      debugPrint('❌ AuthRepository: sendEmailVerification error: $e');
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    debugPrint('AuthRepository: reloadUser called');
    try {
      await _auth.currentUser?.reload();
      debugPrint('AuthRepository: reloadUser success');
    } catch (e) {
      debugPrint('AuthRepository: reloadUser error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    debugPrint('AuthRepository: signOut called');
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      debugPrint('AuthRepository: signOut success');
    } catch (e) {
      debugPrint('AuthRepository: signOut error: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    debugPrint('AuthRepository: deleteAccount called');
    try {
      await _auth.currentUser?.delete();
      debugPrint('AuthRepository: deleteAccount success');
    } catch (e) {
      debugPrint('AuthRepository: deleteAccount error: $e');
      rethrow;
    }
  }

  Future<void> updateDisplayName(String name) async {
    debugPrint('AuthRepository: updateDisplayName called with $name');
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await user.updateDisplayName(name);
      await _userRepository.updateName(user.uid, name);

      debugPrint('AuthRepository: updateDisplayName success');
    } catch (e) {
      debugPrint('AuthRepository: updateDisplayName error: $e');
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    ref.watch(userRepositoryProvider),
  );
}

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}
