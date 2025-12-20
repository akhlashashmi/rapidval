// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HistoryController)
const historyControllerProvider = HistoryControllerProvider._();

final class HistoryControllerProvider
    extends $AsyncNotifierProvider<HistoryController, List<QuizHistoryItem>> {
  const HistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyControllerHash();

  @$internal
  @override
  HistoryController create() => HistoryController();
}

String _$historyControllerHash() => r'06615bcb2428429b0d1dfa51c33c2784b1fdd5e8';

abstract class _$HistoryController
    extends $AsyncNotifier<List<QuizHistoryItem>> {
  FutureOr<List<QuizHistoryItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<QuizHistoryItem>>, List<QuizHistoryItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<QuizHistoryItem>>,
                List<QuizHistoryItem>
              >,
              AsyncValue<List<QuizHistoryItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
