import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_snapshot.freezed.dart';
part 'backup_snapshot.g.dart';

@freezed
abstract class BackupSnapshot with _$BackupSnapshot {
  const factory BackupSnapshot({
    required String id,
    required String userId,
    required DateTime createdAt,
    required int version,
    required Map<String, List<Map<String, dynamic>>> data,
    required BackupMetadata metadata,
  }) = _BackupSnapshot;

  factory BackupSnapshot.fromJson(Map<String, dynamic> json) =>
      _$BackupSnapshotFromJson(json);
}

@freezed
abstract class BackupMetadata with _$BackupMetadata {
  const factory BackupMetadata({
    required int quizCount,
    required int questionCount,
    required int resultCount,
    required String deviceName,
    required String appVersion,
  }) = _BackupMetadata;

  factory BackupMetadata.fromJson(Map<String, dynamic> json) =>
      _$BackupMetadataFromJson(json);
}
