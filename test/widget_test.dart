import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rapidval/src/app.dart';
import 'package:rapidval/src/core/services/local_storage/hive_storage_service.dart';

// Mock LocalStorageService if needed, or just use overrides
class MockLocalStorageService extends HiveStorageService {
  @override
  Future<void> init() async {}
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWith(
            (ref) => MockLocalStorageService(),
          ),
        ],
        child: const RapidValApp(),
      ),
    );

    // Verify that we start at the Auth screen
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsNothing); // Initially Login mode

    // Tap to switch to Sign Up
    await tester.tap(find.text('Create an account'));
    await tester.pump();

    expect(find.text('Sign Up'), findsOneWidget);
  });
}
