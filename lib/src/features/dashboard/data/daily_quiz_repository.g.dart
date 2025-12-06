// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_quiz_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyQuizRepository)
const dailyQuizRepositoryProvider = DailyQuizRepositoryProvider._();

final class DailyQuizRepositoryProvider
    extends
        $FunctionalProvider<
          DailyQuizRepository,
          DailyQuizRepository,
          DailyQuizRepository
        >
    with $Provider<DailyQuizRepository> {
  const DailyQuizRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyQuizRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyQuizRepositoryHash();

  @$internal
  @override
  $ProviderElement<DailyQuizRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyQuizRepository create(Ref ref) {
    return dailyQuizRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyQuizRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyQuizRepository>(value),
    );
  }
}

String _$dailyQuizRepositoryHash() =>
    r'76f1759bb4d1dc98242581e19b7b3de491db7d78';

@ProviderFor(dailyQuiz)
const dailyQuizProvider = DailyQuizProvider._();

final class DailyQuizProvider
    extends $FunctionalProvider<AsyncValue<Quiz?>, Quiz?, FutureOr<Quiz?>>
    with $FutureModifier<Quiz?>, $FutureProvider<Quiz?> {
  const DailyQuizProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyQuizProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyQuizHash();

  @$internal
  @override
  $FutureProviderElement<Quiz?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Quiz?> create(Ref ref) {
    return dailyQuiz(ref);
  }
}

String _$dailyQuizHash() => r'73c5449eb45d1ddb0fd392418aa5e96709cb979f';
