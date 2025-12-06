// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuizController)
const quizControllerProvider = QuizControllerProvider._();

final class QuizControllerProvider
    extends $NotifierProvider<QuizController, QuizState?> {
  const QuizControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizControllerHash();

  @$internal
  @override
  QuizController create() => QuizController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuizState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuizState?>(value),
    );
  }
}

String _$quizControllerHash() => r'997d9ced3b5cae1af82fda554dcfdb67047e4dc9';

abstract class _$QuizController extends $Notifier<QuizState?> {
  QuizState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<QuizState?, QuizState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuizState?, QuizState?>,
              QuizState?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
