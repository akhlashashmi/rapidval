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
        isAutoDispose: true,
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

String _$recentQuizResultsHash() => r'a0e7704d9f6f31ca447ee3402caf0b0242c83ed1';

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
        isAutoDispose: true,
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

String _$allQuizResultsHash() => r'66fbe760bc5a138e12c5325551e5bf9fe0e1e999';

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
        isAutoDispose: true,
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
    r'24d35b861b40e9333bee385c4ee851eaf57d5f76';
