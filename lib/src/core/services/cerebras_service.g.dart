// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cerebras_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cerebrasService)
const cerebrasServiceProvider = CerebrasServiceProvider._();

final class CerebrasServiceProvider
    extends
        $FunctionalProvider<CerebrasService, CerebrasService, CerebrasService>
    with $Provider<CerebrasService> {
  const CerebrasServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cerebrasServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cerebrasServiceHash();

  @$internal
  @override
  $ProviderElement<CerebrasService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CerebrasService create(Ref ref) {
    return cerebrasService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CerebrasService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CerebrasService>(value),
    );
  }
}

String _$cerebrasServiceHash() => r'e1e84a8bc8a75568c860c80cbc02becb3832a080';
