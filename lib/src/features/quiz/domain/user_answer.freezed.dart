// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserAnswer {

 int get questionIndex; int get selectedOptionIndex; List<int> get selectedIndices; DateTime get answeredAt;
/// Create a copy of UserAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAnswerCopyWith<UserAnswer> get copyWith => _$UserAnswerCopyWithImpl<UserAnswer>(this as UserAnswer, _$identity);

  /// Serializes this UserAnswer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAnswer&&(identical(other.questionIndex, questionIndex) || other.questionIndex == questionIndex)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&const DeepCollectionEquality().equals(other.selectedIndices, selectedIndices)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionIndex,selectedOptionIndex,const DeepCollectionEquality().hash(selectedIndices),answeredAt);

@override
String toString() {
  return 'UserAnswer(questionIndex: $questionIndex, selectedOptionIndex: $selectedOptionIndex, selectedIndices: $selectedIndices, answeredAt: $answeredAt)';
}


}

/// @nodoc
abstract mixin class $UserAnswerCopyWith<$Res>  {
  factory $UserAnswerCopyWith(UserAnswer value, $Res Function(UserAnswer) _then) = _$UserAnswerCopyWithImpl;
@useResult
$Res call({
 int questionIndex, int selectedOptionIndex, List<int> selectedIndices, DateTime answeredAt
});




}
/// @nodoc
class _$UserAnswerCopyWithImpl<$Res>
    implements $UserAnswerCopyWith<$Res> {
  _$UserAnswerCopyWithImpl(this._self, this._then);

  final UserAnswer _self;
  final $Res Function(UserAnswer) _then;

/// Create a copy of UserAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionIndex = null,Object? selectedOptionIndex = null,Object? selectedIndices = null,Object? answeredAt = null,}) {
  return _then(_self.copyWith(
questionIndex: null == questionIndex ? _self.questionIndex : questionIndex // ignore: cast_nullable_to_non_nullable
as int,selectedOptionIndex: null == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int,selectedIndices: null == selectedIndices ? _self.selectedIndices : selectedIndices // ignore: cast_nullable_to_non_nullable
as List<int>,answeredAt: null == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAnswer].
extension UserAnswerPatterns on UserAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAnswer value)  $default,){
final _that = this;
switch (_that) {
case _UserAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _UserAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int questionIndex,  int selectedOptionIndex,  List<int> selectedIndices,  DateTime answeredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAnswer() when $default != null:
return $default(_that.questionIndex,_that.selectedOptionIndex,_that.selectedIndices,_that.answeredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int questionIndex,  int selectedOptionIndex,  List<int> selectedIndices,  DateTime answeredAt)  $default,) {final _that = this;
switch (_that) {
case _UserAnswer():
return $default(_that.questionIndex,_that.selectedOptionIndex,_that.selectedIndices,_that.answeredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int questionIndex,  int selectedOptionIndex,  List<int> selectedIndices,  DateTime answeredAt)?  $default,) {final _that = this;
switch (_that) {
case _UserAnswer() when $default != null:
return $default(_that.questionIndex,_that.selectedOptionIndex,_that.selectedIndices,_that.answeredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAnswer implements UserAnswer {
  const _UserAnswer({required this.questionIndex, required this.selectedOptionIndex, final  List<int> selectedIndices = const [], required this.answeredAt}): _selectedIndices = selectedIndices;
  factory _UserAnswer.fromJson(Map<String, dynamic> json) => _$UserAnswerFromJson(json);

@override final  int questionIndex;
@override final  int selectedOptionIndex;
 final  List<int> _selectedIndices;
@override@JsonKey() List<int> get selectedIndices {
  if (_selectedIndices is EqualUnmodifiableListView) return _selectedIndices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedIndices);
}

@override final  DateTime answeredAt;

/// Create a copy of UserAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAnswerCopyWith<_UserAnswer> get copyWith => __$UserAnswerCopyWithImpl<_UserAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAnswer&&(identical(other.questionIndex, questionIndex) || other.questionIndex == questionIndex)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&const DeepCollectionEquality().equals(other._selectedIndices, _selectedIndices)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionIndex,selectedOptionIndex,const DeepCollectionEquality().hash(_selectedIndices),answeredAt);

@override
String toString() {
  return 'UserAnswer(questionIndex: $questionIndex, selectedOptionIndex: $selectedOptionIndex, selectedIndices: $selectedIndices, answeredAt: $answeredAt)';
}


}

/// @nodoc
abstract mixin class _$UserAnswerCopyWith<$Res> implements $UserAnswerCopyWith<$Res> {
  factory _$UserAnswerCopyWith(_UserAnswer value, $Res Function(_UserAnswer) _then) = __$UserAnswerCopyWithImpl;
@override @useResult
$Res call({
 int questionIndex, int selectedOptionIndex, List<int> selectedIndices, DateTime answeredAt
});




}
/// @nodoc
class __$UserAnswerCopyWithImpl<$Res>
    implements _$UserAnswerCopyWith<$Res> {
  __$UserAnswerCopyWithImpl(this._self, this._then);

  final _UserAnswer _self;
  final $Res Function(_UserAnswer) _then;

/// Create a copy of UserAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionIndex = null,Object? selectedOptionIndex = null,Object? selectedIndices = null,Object? answeredAt = null,}) {
  return _then(_UserAnswer(
questionIndex: null == questionIndex ? _self.questionIndex : questionIndex // ignore: cast_nullable_to_non_nullable
as int,selectedOptionIndex: null == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int,selectedIndices: null == selectedIndices ? _self._selectedIndices : selectedIndices // ignore: cast_nullable_to_non_nullable
as List<int>,answeredAt: null == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$QuizResult {

 String get quizId; Quiz get quiz; List<UserAnswer> get answers; DateTime get startedAt; DateTime get completedAt; int get correctAnswers; int get totalQuestions; double get percentage;
/// Create a copy of QuizResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizResultCopyWith<QuizResult> get copyWith => _$QuizResultCopyWithImpl<QuizResult>(this as QuizResult, _$identity);

  /// Serializes this QuizResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizResult&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.quiz, quiz) || other.quiz == quiz)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.correctAnswers, correctAnswers) || other.correctAnswers == correctAnswers)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,quiz,const DeepCollectionEquality().hash(answers),startedAt,completedAt,correctAnswers,totalQuestions,percentage);

@override
String toString() {
  return 'QuizResult(quizId: $quizId, quiz: $quiz, answers: $answers, startedAt: $startedAt, completedAt: $completedAt, correctAnswers: $correctAnswers, totalQuestions: $totalQuestions, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $QuizResultCopyWith<$Res>  {
  factory $QuizResultCopyWith(QuizResult value, $Res Function(QuizResult) _then) = _$QuizResultCopyWithImpl;
@useResult
$Res call({
 String quizId, Quiz quiz, List<UserAnswer> answers, DateTime startedAt, DateTime completedAt, int correctAnswers, int totalQuestions, double percentage
});


$QuizCopyWith<$Res> get quiz;

}
/// @nodoc
class _$QuizResultCopyWithImpl<$Res>
    implements $QuizResultCopyWith<$Res> {
  _$QuizResultCopyWithImpl(this._self, this._then);

  final QuizResult _self;
  final $Res Function(QuizResult) _then;

/// Create a copy of QuizResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizId = null,Object? quiz = null,Object? answers = null,Object? startedAt = null,Object? completedAt = null,Object? correctAnswers = null,Object? totalQuestions = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as String,quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<UserAnswer>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of QuizResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizCopyWith<$Res> get quiz {
  
  return $QuizCopyWith<$Res>(_self.quiz, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizResult].
extension QuizResultPatterns on QuizResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizResult value)  $default,){
final _that = this;
switch (_that) {
case _QuizResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizResult value)?  $default,){
final _that = this;
switch (_that) {
case _QuizResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String quizId,  Quiz quiz,  List<UserAnswer> answers,  DateTime startedAt,  DateTime completedAt,  int correctAnswers,  int totalQuestions,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizResult() when $default != null:
return $default(_that.quizId,_that.quiz,_that.answers,_that.startedAt,_that.completedAt,_that.correctAnswers,_that.totalQuestions,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String quizId,  Quiz quiz,  List<UserAnswer> answers,  DateTime startedAt,  DateTime completedAt,  int correctAnswers,  int totalQuestions,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _QuizResult():
return $default(_that.quizId,_that.quiz,_that.answers,_that.startedAt,_that.completedAt,_that.correctAnswers,_that.totalQuestions,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String quizId,  Quiz quiz,  List<UserAnswer> answers,  DateTime startedAt,  DateTime completedAt,  int correctAnswers,  int totalQuestions,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _QuizResult() when $default != null:
return $default(_that.quizId,_that.quiz,_that.answers,_that.startedAt,_that.completedAt,_that.correctAnswers,_that.totalQuestions,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizResult implements QuizResult {
  const _QuizResult({required this.quizId, required this.quiz, required final  List<UserAnswer> answers, required this.startedAt, required this.completedAt, required this.correctAnswers, required this.totalQuestions, required this.percentage}): _answers = answers;
  factory _QuizResult.fromJson(Map<String, dynamic> json) => _$QuizResultFromJson(json);

@override final  String quizId;
@override final  Quiz quiz;
 final  List<UserAnswer> _answers;
@override List<UserAnswer> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}

@override final  DateTime startedAt;
@override final  DateTime completedAt;
@override final  int correctAnswers;
@override final  int totalQuestions;
@override final  double percentage;

/// Create a copy of QuizResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizResultCopyWith<_QuizResult> get copyWith => __$QuizResultCopyWithImpl<_QuizResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizResult&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.quiz, quiz) || other.quiz == quiz)&&const DeepCollectionEquality().equals(other._answers, _answers)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.correctAnswers, correctAnswers) || other.correctAnswers == correctAnswers)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,quiz,const DeepCollectionEquality().hash(_answers),startedAt,completedAt,correctAnswers,totalQuestions,percentage);

@override
String toString() {
  return 'QuizResult(quizId: $quizId, quiz: $quiz, answers: $answers, startedAt: $startedAt, completedAt: $completedAt, correctAnswers: $correctAnswers, totalQuestions: $totalQuestions, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$QuizResultCopyWith<$Res> implements $QuizResultCopyWith<$Res> {
  factory _$QuizResultCopyWith(_QuizResult value, $Res Function(_QuizResult) _then) = __$QuizResultCopyWithImpl;
@override @useResult
$Res call({
 String quizId, Quiz quiz, List<UserAnswer> answers, DateTime startedAt, DateTime completedAt, int correctAnswers, int totalQuestions, double percentage
});


@override $QuizCopyWith<$Res> get quiz;

}
/// @nodoc
class __$QuizResultCopyWithImpl<$Res>
    implements _$QuizResultCopyWith<$Res> {
  __$QuizResultCopyWithImpl(this._self, this._then);

  final _QuizResult _self;
  final $Res Function(_QuizResult) _then;

/// Create a copy of QuizResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizId = null,Object? quiz = null,Object? answers = null,Object? startedAt = null,Object? completedAt = null,Object? correctAnswers = null,Object? totalQuestions = null,Object? percentage = null,}) {
  return _then(_QuizResult(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as String,quiz: null == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as Quiz,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<UserAnswer>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of QuizResult
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
