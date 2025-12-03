// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizState {

 Quiz get quiz; int get currentQuestionIndex; List<UserAnswer> get userAnswers; int get timeLeft; bool get isCompleted; DateTime get startedAt;
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizStateCopyWith<QuizState> get copyWith => _$QuizStateCopyWithImpl<QuizState>(this as QuizState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizState&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&const DeepCollectionEquality().equals(other.userAnswers, userAnswers)&&(identical(other.timeLeft, timeLeft) || other.timeLeft == timeLeft)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode => Object.hash(runtimeType,quiz,currentQuestionIndex,const DeepCollectionEquality().hash(userAnswers),timeLeft,isCompleted,startedAt);

@override
String toString() {
  return 'QuizState(quiz: $quiz, currentQuestionIndex: $currentQuestionIndex, userAnswers: $userAnswers, timeLeft: $timeLeft, isCompleted: $isCompleted, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class $QuizStateCopyWith<$Res>  {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) _then) = _$QuizStateCopyWithImpl;
@useResult
$Res call({
 Quiz quiz, int currentQuestionIndex, List<UserAnswer> userAnswers, int timeLeft, bool isCompleted, DateTime startedAt
});


$QuizCopyWith<$Res> get quiz;

}
/// @nodoc
class _$QuizStateCopyWithImpl<$Res>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._self, this._then);

  final QuizState _self;
  final $Res Function(QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quiz = null,Object? currentQuestionIndex = null,Object? userAnswers = null,Object? timeLeft = null,Object? isCompleted = null,Object? startedAt = null,}) {
  return _then(_self.copyWith(
quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,userAnswers: null == userAnswers ? _self.userAnswers : userAnswers // ignore: cast_nullable_to_non_nullable
as List<UserAnswer>,timeLeft: null == timeLeft ? _self.timeLeft : timeLeft // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizCopyWith<$Res> get quiz {
  
  return $QuizCopyWith<$Res>(_self.quiz, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizState].
extension QuizStatePatterns on QuizState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizState value)  $default,){
final _that = this;
switch (_that) {
case _QuizState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizState value)?  $default,){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Quiz quiz,  int currentQuestionIndex,  List<UserAnswer> userAnswers,  int timeLeft,  bool isCompleted,  DateTime startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.quiz,_that.currentQuestionIndex,_that.userAnswers,_that.timeLeft,_that.isCompleted,_that.startedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Quiz quiz,  int currentQuestionIndex,  List<UserAnswer> userAnswers,  int timeLeft,  bool isCompleted,  DateTime startedAt)  $default,) {final _that = this;
switch (_that) {
case _QuizState():
return $default(_that.quiz,_that.currentQuestionIndex,_that.userAnswers,_that.timeLeft,_that.isCompleted,_that.startedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Quiz quiz,  int currentQuestionIndex,  List<UserAnswer> userAnswers,  int timeLeft,  bool isCompleted,  DateTime startedAt)?  $default,) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.quiz,_that.currentQuestionIndex,_that.userAnswers,_that.timeLeft,_that.isCompleted,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc


class _QuizState implements QuizState {
  const _QuizState({required this.quiz, this.currentQuestionIndex = 0, final  List<UserAnswer> userAnswers = const [], this.timeLeft = 0, this.isCompleted = false, required this.startedAt}): _userAnswers = userAnswers;
  

@override final  Quiz quiz;
@override@JsonKey() final  int currentQuestionIndex;
 final  List<UserAnswer> _userAnswers;
@override@JsonKey() List<UserAnswer> get userAnswers {
  if (_userAnswers is EqualUnmodifiableListView) return _userAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userAnswers);
}

@override@JsonKey() final  int timeLeft;
@override@JsonKey() final  bool isCompleted;
@override final  DateTime startedAt;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizStateCopyWith<_QuizState> get copyWith => __$QuizStateCopyWithImpl<_QuizState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizState&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&const DeepCollectionEquality().equals(other._userAnswers, _userAnswers)&&(identical(other.timeLeft, timeLeft) || other.timeLeft == timeLeft)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode => Object.hash(runtimeType,quiz,currentQuestionIndex,const DeepCollectionEquality().hash(_userAnswers),timeLeft,isCompleted,startedAt);

@override
String toString() {
  return 'QuizState(quiz: $quiz, currentQuestionIndex: $currentQuestionIndex, userAnswers: $userAnswers, timeLeft: $timeLeft, isCompleted: $isCompleted, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$QuizStateCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$QuizStateCopyWith(_QuizState value, $Res Function(_QuizState) _then) = __$QuizStateCopyWithImpl;
@override @useResult
$Res call({
 Quiz quiz, int currentQuestionIndex, List<UserAnswer> userAnswers, int timeLeft, bool isCompleted, DateTime startedAt
});


@override $QuizCopyWith<$Res> get quiz;

}
/// @nodoc
class __$QuizStateCopyWithImpl<$Res>
    implements _$QuizStateCopyWith<$Res> {
  __$QuizStateCopyWithImpl(this._self, this._then);

  final _QuizState _self;
  final $Res Function(_QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quiz = null,Object? currentQuestionIndex = null,Object? userAnswers = null,Object? timeLeft = null,Object? isCompleted = null,Object? startedAt = null,}) {
  return _then(_QuizState(
quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,userAnswers: null == userAnswers ? _self._userAnswers : userAnswers // ignore: cast_nullable_to_non_nullable
as List<UserAnswer>,timeLeft: null == timeLeft ? _self.timeLeft : timeLeft // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizCopyWith<$Res> get quiz {
  
  return $QuizCopyWith<$Res>(_self.quiz, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}
}

// dart format on
