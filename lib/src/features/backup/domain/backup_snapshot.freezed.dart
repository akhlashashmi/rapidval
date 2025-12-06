// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupSnapshot {

 String get id; String get userId; DateTime get createdAt; int get version; Map<String, List<Map<String, dynamic>>> get data; BackupMetadata get metadata;
/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupSnapshotCopyWith<BackupSnapshot> get copyWith => _$BackupSnapshotCopyWithImpl<BackupSnapshot>(this as BackupSnapshot, _$identity);

  /// Serializes this BackupSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,version,const DeepCollectionEquality().hash(data),metadata);

@override
String toString() {
  return 'BackupSnapshot(id: $id, userId: $userId, createdAt: $createdAt, version: $version, data: $data, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $BackupSnapshotCopyWith<$Res>  {
  factory $BackupSnapshotCopyWith(BackupSnapshot value, $Res Function(BackupSnapshot) _then) = _$BackupSnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime createdAt, int version, Map<String, List<Map<String, dynamic>>> data, BackupMetadata metadata
});


$BackupMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$BackupSnapshotCopyWithImpl<$Res>
    implements $BackupSnapshotCopyWith<$Res> {
  _$BackupSnapshotCopyWithImpl(this._self, this._then);

  final BackupSnapshot _self;
  final $Res Function(BackupSnapshot) _then;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? version = null,Object? data = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, List<Map<String, dynamic>>>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as BackupMetadata,
  ));
}
/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupMetadataCopyWith<$Res> get metadata {
  
  return $BackupMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupSnapshot].
extension BackupSnapshotPatterns on BackupSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _BackupSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime createdAt,  int version,  Map<String, List<Map<String, dynamic>>> data,  BackupMetadata metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.version,_that.data,_that.metadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime createdAt,  int version,  Map<String, List<Map<String, dynamic>>> data,  BackupMetadata metadata)  $default,) {final _that = this;
switch (_that) {
case _BackupSnapshot():
return $default(_that.id,_that.userId,_that.createdAt,_that.version,_that.data,_that.metadata);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime createdAt,  int version,  Map<String, List<Map<String, dynamic>>> data,  BackupMetadata metadata)?  $default,) {final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.version,_that.data,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupSnapshot implements BackupSnapshot {
  const _BackupSnapshot({required this.id, required this.userId, required this.createdAt, required this.version, required final  Map<String, List<Map<String, dynamic>>> data, required this.metadata}): _data = data;
  factory _BackupSnapshot.fromJson(Map<String, dynamic> json) => _$BackupSnapshotFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime createdAt;
@override final  int version;
 final  Map<String, List<Map<String, dynamic>>> _data;
@override Map<String, List<Map<String, dynamic>>> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override final  BackupMetadata metadata;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupSnapshotCopyWith<_BackupSnapshot> get copyWith => __$BackupSnapshotCopyWithImpl<_BackupSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,version,const DeepCollectionEquality().hash(_data),metadata);

@override
String toString() {
  return 'BackupSnapshot(id: $id, userId: $userId, createdAt: $createdAt, version: $version, data: $data, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$BackupSnapshotCopyWith<$Res> implements $BackupSnapshotCopyWith<$Res> {
  factory _$BackupSnapshotCopyWith(_BackupSnapshot value, $Res Function(_BackupSnapshot) _then) = __$BackupSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime createdAt, int version, Map<String, List<Map<String, dynamic>>> data, BackupMetadata metadata
});


@override $BackupMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$BackupSnapshotCopyWithImpl<$Res>
    implements _$BackupSnapshotCopyWith<$Res> {
  __$BackupSnapshotCopyWithImpl(this._self, this._then);

  final _BackupSnapshot _self;
  final $Res Function(_BackupSnapshot) _then;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? version = null,Object? data = null,Object? metadata = null,}) {
  return _then(_BackupSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, List<Map<String, dynamic>>>,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as BackupMetadata,
  ));
}

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupMetadataCopyWith<$Res> get metadata {
  
  return $BackupMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$BackupMetadata {

 int get quizCount; int get questionCount; int get resultCount; String get deviceName; String get appVersion;
/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupMetadataCopyWith<BackupMetadata> get copyWith => _$BackupMetadataCopyWithImpl<BackupMetadata>(this as BackupMetadata, _$identity);

  /// Serializes this BackupMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupMetadata&&(identical(other.quizCount, quizCount) || other.quizCount == quizCount)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizCount,questionCount,resultCount,deviceName,appVersion);

@override
String toString() {
  return 'BackupMetadata(quizCount: $quizCount, questionCount: $questionCount, resultCount: $resultCount, deviceName: $deviceName, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class $BackupMetadataCopyWith<$Res>  {
  factory $BackupMetadataCopyWith(BackupMetadata value, $Res Function(BackupMetadata) _then) = _$BackupMetadataCopyWithImpl;
@useResult
$Res call({
 int quizCount, int questionCount, int resultCount, String deviceName, String appVersion
});




}
/// @nodoc
class _$BackupMetadataCopyWithImpl<$Res>
    implements $BackupMetadataCopyWith<$Res> {
  _$BackupMetadataCopyWithImpl(this._self, this._then);

  final BackupMetadata _self;
  final $Res Function(BackupMetadata) _then;

/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizCount = null,Object? questionCount = null,Object? resultCount = null,Object? deviceName = null,Object? appVersion = null,}) {
  return _then(_self.copyWith(
quizCount: null == quizCount ? _self.quizCount : quizCount // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupMetadata].
extension BackupMetadataPatterns on BackupMetadata {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupMetadata value)  $default,){
final _that = this;
switch (_that) {
case _BackupMetadata():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quizCount,  int questionCount,  int resultCount,  String deviceName,  String appVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that.quizCount,_that.questionCount,_that.resultCount,_that.deviceName,_that.appVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quizCount,  int questionCount,  int resultCount,  String deviceName,  String appVersion)  $default,) {final _that = this;
switch (_that) {
case _BackupMetadata():
return $default(_that.quizCount,_that.questionCount,_that.resultCount,_that.deviceName,_that.appVersion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quizCount,  int questionCount,  int resultCount,  String deviceName,  String appVersion)?  $default,) {final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that.quizCount,_that.questionCount,_that.resultCount,_that.deviceName,_that.appVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupMetadata implements BackupMetadata {
  const _BackupMetadata({required this.quizCount, required this.questionCount, required this.resultCount, required this.deviceName, required this.appVersion});
  factory _BackupMetadata.fromJson(Map<String, dynamic> json) => _$BackupMetadataFromJson(json);

@override final  int quizCount;
@override final  int questionCount;
@override final  int resultCount;
@override final  String deviceName;
@override final  String appVersion;

/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupMetadataCopyWith<_BackupMetadata> get copyWith => __$BackupMetadataCopyWithImpl<_BackupMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupMetadata&&(identical(other.quizCount, quizCount) || other.quizCount == quizCount)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizCount,questionCount,resultCount,deviceName,appVersion);

@override
String toString() {
  return 'BackupMetadata(quizCount: $quizCount, questionCount: $questionCount, resultCount: $resultCount, deviceName: $deviceName, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class _$BackupMetadataCopyWith<$Res> implements $BackupMetadataCopyWith<$Res> {
  factory _$BackupMetadataCopyWith(_BackupMetadata value, $Res Function(_BackupMetadata) _then) = __$BackupMetadataCopyWithImpl;
@override @useResult
$Res call({
 int quizCount, int questionCount, int resultCount, String deviceName, String appVersion
});




}
/// @nodoc
class __$BackupMetadataCopyWithImpl<$Res>
    implements _$BackupMetadataCopyWith<$Res> {
  __$BackupMetadataCopyWithImpl(this._self, this._then);

  final _BackupMetadata _self;
  final $Res Function(_BackupMetadata) _then;

/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizCount = null,Object? questionCount = null,Object? resultCount = null,Object? deviceName = null,Object? appVersion = null,}) {
  return _then(_BackupMetadata(
quizCount: null == quizCount ? _self.quizCount : quizCount // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
