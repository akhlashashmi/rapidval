// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizConfig {

 String get topic; QuizDifficulty get difficulty; int get questionCount; int get timePerQuestionSeconds;
/// Create a copy of QuizConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizConfigCopyWith<QuizConfig> get copyWith => _$QuizConfigCopyWithImpl<QuizConfig>(this as QuizConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizConfig&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.timePerQuestionSeconds, timePerQuestionSeconds) || other.timePerQuestionSeconds == timePerQuestionSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,topic,difficulty,questionCount,timePerQuestionSeconds);

@override
String toString() {
  return 'QuizConfig(topic: $topic, difficulty: $difficulty, questionCount: $questionCount, timePerQuestionSeconds: $timePerQuestionSeconds)';
}


}

/// @nodoc
abstract mixin class $QuizConfigCopyWith<$Res>  {
  factory $QuizConfigCopyWith(QuizConfig value, $Res Function(QuizConfig) _then) = _$QuizConfigCopyWithImpl;
@useResult
$Res call({
 String topic, QuizDifficulty difficulty, int questionCount, int timePerQuestionSeconds
});




}
/// @nodoc
class _$QuizConfigCopyWithImpl<$Res>
    implements $QuizConfigCopyWith<$Res> {
  _$QuizConfigCopyWithImpl(this._self, this._then);

  final QuizConfig _self;
  final $Res Function(QuizConfig) _then;

/// Create a copy of QuizConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topic = null,Object? difficulty = null,Object? questionCount = null,Object? timePerQuestionSeconds = null,}) {
  return _then(_self.copyWith(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as QuizDifficulty,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestionSeconds: null == timePerQuestionSeconds ? _self.timePerQuestionSeconds : timePerQuestionSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizConfig].
extension QuizConfigPatterns on QuizConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizConfig value)  $default,){
final _that = this;
switch (_that) {
case _QuizConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizConfig value)?  $default,){
final _that = this;
switch (_that) {
case _QuizConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String topic,  QuizDifficulty difficulty,  int questionCount,  int timePerQuestionSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizConfig() when $default != null:
return $default(_that.topic,_that.difficulty,_that.questionCount,_that.timePerQuestionSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String topic,  QuizDifficulty difficulty,  int questionCount,  int timePerQuestionSeconds)  $default,) {final _that = this;
switch (_that) {
case _QuizConfig():
return $default(_that.topic,_that.difficulty,_that.questionCount,_that.timePerQuestionSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String topic,  QuizDifficulty difficulty,  int questionCount,  int timePerQuestionSeconds)?  $default,) {final _that = this;
switch (_that) {
case _QuizConfig() when $default != null:
return $default(_that.topic,_that.difficulty,_that.questionCount,_that.timePerQuestionSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _QuizConfig implements QuizConfig {
  const _QuizConfig({this.topic = '', this.difficulty = QuizDifficulty.intermediate, this.questionCount = 5, this.timePerQuestionSeconds = 15});
  

@override@JsonKey() final  String topic;
@override@JsonKey() final  QuizDifficulty difficulty;
@override@JsonKey() final  int questionCount;
@override@JsonKey() final  int timePerQuestionSeconds;

/// Create a copy of QuizConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizConfigCopyWith<_QuizConfig> get copyWith => __$QuizConfigCopyWithImpl<_QuizConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizConfig&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.timePerQuestionSeconds, timePerQuestionSeconds) || other.timePerQuestionSeconds == timePerQuestionSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,topic,difficulty,questionCount,timePerQuestionSeconds);

@override
String toString() {
  return 'QuizConfig(topic: $topic, difficulty: $difficulty, questionCount: $questionCount, timePerQuestionSeconds: $timePerQuestionSeconds)';
}


}

/// @nodoc
abstract mixin class _$QuizConfigCopyWith<$Res> implements $QuizConfigCopyWith<$Res> {
  factory _$QuizConfigCopyWith(_QuizConfig value, $Res Function(_QuizConfig) _then) = __$QuizConfigCopyWithImpl;
@override @useResult
$Res call({
 String topic, QuizDifficulty difficulty, int questionCount, int timePerQuestionSeconds
});




}
/// @nodoc
class __$QuizConfigCopyWithImpl<$Res>
    implements _$QuizConfigCopyWith<$Res> {
  __$QuizConfigCopyWithImpl(this._self, this._then);

  final _QuizConfig _self;
  final $Res Function(_QuizConfig) _then;

/// Create a copy of QuizConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topic = null,Object? difficulty = null,Object? questionCount = null,Object? timePerQuestionSeconds = null,}) {
  return _then(_QuizConfig(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as QuizDifficulty,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,timePerQuestionSeconds: null == timePerQuestionSeconds ? _self.timePerQuestionSeconds : timePerQuestionSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
