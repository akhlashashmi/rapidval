// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackupController)
const backupControllerProvider = BackupControllerProvider._();

final class BackupControllerProvider
    extends $AsyncNotifierProvider<BackupController, void> {
  const BackupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupControllerHash();

  @$internal
  @override
  BackupController create() => BackupController();
}

String _$backupControllerHash() => r'd8758d52111e3193cb26d14da558fac81203cc46';

abstract class _$BackupController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(backupStream)
const backupStreamProvider = BackupStreamProvider._();

final class BackupStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<BackupSnapshot?>,
          BackupSnapshot?,
          Stream<BackupSnapshot?>
        >
    with $FutureModifier<BackupSnapshot?>, $StreamProvider<BackupSnapshot?> {
  const BackupStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupStreamHash();

  @$internal
  @override
  $StreamProviderElement<BackupSnapshot?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BackupSnapshot?> create(Ref ref) {
    return backupStream(ref);
  }
}

String _$backupStreamHash() => r'780d00f2df7f800cce41b6d05c452f252ab0715a';
