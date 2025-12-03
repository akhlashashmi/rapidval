import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/user_repository.dart';
import '../domain/user_profile.dart';
import '../data/auth_repository.dart';

part 'user_controller.g.dart';

@riverpod
Stream<UserProfile?> userProfile(Ref ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUserProfile(user.uid);
}
