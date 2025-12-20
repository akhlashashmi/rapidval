// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quizRepository)
const quizRepositoryProvider = QuizRepositoryProvider._();

final class QuizRepositoryProvider
    extends $FunctionalProvider<QuizRepository, QuizRepository, QuizRepository>
    with $Provider<QuizRepository> {
  const QuizRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuizRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuizRepository create(Ref ref) {
    return quizRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuizRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuizRepository>(value),
    );
  }
}

String _$quizRepositoryHash() => r'89c852ab6a72fe2c13df954ae37226ebd9ded997';

@ProviderFor(recentQuizResults)
const recentQuizResultsProvider = RecentQuizResultsProvider._();

final class RecentQuizResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QuizResult>>,
          List<QuizResult>,
          FutureOr<List<QuizResult>>
        >
    with $FutureModifier<List<QuizResult>>, $FutureProvider<List<QuizResult>> {
  const RecentQuizResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentQuizResultsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentQuizResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<QuizResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QuizResult>> create(Ref ref) {
    return recentQuizResults(ref);
  }
}

String _$recentQuizResultsHash() => r'99bcd2a3cf6ee6080ee528e9ff4bb1dfb8bb865f';

@ProviderFor(allQuizResults)
const allQuizResultsProvider = AllQuizResultsProvider._();

final class AllQuizResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QuizResult>>,
          List<QuizResult>,
          FutureOr<List<QuizResult>>
        >
    with $FutureModifier<List<QuizResult>>, $FutureProvider<List<QuizResult>> {
  const AllQuizResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allQuizResultsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allQuizResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<QuizResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QuizResult>> create(Ref ref) {
    return allQuizResults(ref);
  }
}

String _$allQuizResultsHash() => r'cb0dd008df3ca694150e02efc2f79f2b6aba5632';

@ProviderFor(activeQuizProgress)
const activeQuizProgressProvider = ActiveQuizProgressProvider._();

final class ActiveQuizProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<(QuizState, int)?>,
          (QuizState, int)?,
          FutureOr<(QuizState, int)?>
        >
    with
        $FutureModifier<(QuizState, int)?>,
        $FutureProvider<(QuizState, int)?> {
  const ActiveQuizProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeQuizProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeQuizProgressHash();

  @$internal
  @override
  $FutureProviderElement<(QuizState, int)?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<(QuizState, int)?> create(Ref ref) {
    return activeQuizProgress(ref);
  }
}

String _$activeQuizProgressHash() =>
    r'7519edbf3e57bcee61735369c60bfd3f85fc0583';

@ProviderFor(quizHistory)
const quizHistoryProvider = QuizHistoryProvider._();

final class QuizHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QuizHistoryItem>>,
          List<QuizHistoryItem>,
          Stream<List<QuizHistoryItem>>
        >
    with
        $FutureModifier<List<QuizHistoryItem>>,
        $StreamProvider<List<QuizHistoryItem>> {
  const QuizHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<QuizHistoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<QuizHistoryItem>> create(Ref ref) {
    return quizHistory(ref);
  }
}

String _$quizHistoryHash() => r'c12bb3d92c82a9ea1d626f996d33ff5590b2b053';
