// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_selection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HistorySelection)
const historySelectionProvider = HistorySelectionProvider._();

final class HistorySelectionProvider
    extends $NotifierProvider<HistorySelection, Set<String>> {
  const HistorySelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historySelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historySelectionHash();

  @$internal
  @override
  HistorySelection create() => HistorySelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$historySelectionHash() => r'8ca5db041f6c2b753cd76c84a39f4b31add762eb';

abstract class _$HistorySelection extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
