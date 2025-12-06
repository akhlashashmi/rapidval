// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizHistoryItem {

 Quiz get quiz; QuizResult? get result;
/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizHistoryItemCopyWith<QuizHistoryItem> get copyWith => _$QuizHistoryItemCopyWithImpl<QuizHistoryItem>(this as QuizHistoryItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizHistoryItem&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,quiz,result);

@override
String toString() {
  return 'QuizHistoryItem(quiz: $quiz, result: $result)';
}


}

/// @nodoc
abstract mixin class $QuizHistoryItemCopyWith<$Res>  {
  factory $QuizHistoryItemCopyWith(QuizHistoryItem value, $Res Function(QuizHistoryItem) _then) = _$QuizHistoryItemCopyWithImpl;
@useResult
$Res call({
 Quiz quiz, QuizResult? result
});


$QuizCopyWith<$Res> get quiz;$QuizResultCopyWith<$Res>? get result;

}
/// @nodoc
class _$QuizHistoryItemCopyWithImpl<$Res>
    implements $QuizHistoryItemCopyWith<$Res> {
  _$QuizHistoryItemCopyWithImpl(this._self, this._then);

  final QuizHistoryItem _self;
  final $Res Function(QuizHistoryItem) _then;

/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quiz = null,Object? result = freezed,}) {
  return _then(_self.copyWith(
quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as QuizResult?,
  ));
}
/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizCopyWith<$Res> get quiz {
  
  return $QuizCopyWith<$Res>(_self.quiz, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $QuizResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizHistoryItem].
extension QuizHistoryItemPatterns on QuizHistoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _QuizHistoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Quiz quiz,  QuizResult? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
return $default(_that.quiz,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Quiz quiz,  QuizResult? result)  $default,) {final _that = this;
switch (_that) {
case _QuizHistoryItem():
return $default(_that.quiz,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Quiz quiz,  QuizResult? result)?  $default,) {final _that = this;
switch (_that) {
case _QuizHistoryItem() when $default != null:
return $default(_that.quiz,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _QuizHistoryItem implements QuizHistoryItem {
  const _QuizHistoryItem({required this.quiz, this.result});
  

@override final  Quiz quiz;
@override final  QuizResult? result;

/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizHistoryItemCopyWith<_QuizHistoryItem> get copyWith => __$QuizHistoryItemCopyWithImpl<_QuizHistoryItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizHistoryItem&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,quiz,result);

@override
String toString() {
  return 'QuizHistoryItem(quiz: $quiz, result: $result)';
}


}

/// @nodoc
abstract mixin class _$QuizHistoryItemCopyWith<$Res> implements $QuizHistoryItemCopyWith<$Res> {
  factory _$QuizHistoryItemCopyWith(_QuizHistoryItem value, $Res Function(_QuizHistoryItem) _then) = __$QuizHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 Quiz quiz, QuizResult? result
});


@override $QuizCopyWith<$Res> get quiz;@override $QuizResultCopyWith<$Res>? get result;

}
/// @nodoc
class __$QuizHistoryItemCopyWithImpl<$Res>
    implements _$QuizHistoryItemCopyWith<$Res> {
  __$QuizHistoryItemCopyWithImpl(this._self, this._then);

  final _QuizHistoryItem _self;
  final $Res Function(_QuizHistoryItem) _then;

/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quiz = null,Object? result = freezed,}) {
  return _then(_QuizHistoryItem(
quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as QuizResult?,
  ));
}

/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizCopyWith<$Res> get quiz {
  
  return $QuizCopyWith<$Res>(_self.quiz, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}/// Create a copy of QuizHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $QuizResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
