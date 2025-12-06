// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupSnapshot _$BackupSnapshotFromJson(Map<String, dynamic> json) =>
    _BackupSnapshot(
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      version: (json['version'] as num).toInt(),
      data: (json['data'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
        ),
      ),
      metadata: BackupMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BackupSnapshotToJson(_BackupSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'version': instance.version,
      'data': instance.data,
      'metadata': instance.metadata,
    };

_BackupMetadata _$BackupMetadataFromJson(Map<String, dynamic> json) =>
    _BackupMetadata(
      quizCount: (json['quizCount'] as num).toInt(),
      questionCount: (json['questionCount'] as num).toInt(),
      resultCount: (json['resultCount'] as num).toInt(),
      deviceName: json['deviceName'] as String,
      appVersion: json['appVersion'] as String,
    );

Map<String, dynamic> _$BackupMetadataToJson(_BackupMetadata instance) =>
    <String, dynamic>{
      'quizCount': instance.quizCount,
      'questionCount': instance.questionCount,
      'resultCount': instance.resultCount,
      'deviceName': instance.deviceName,
      'appVersion': instance.appVersion,
    };
