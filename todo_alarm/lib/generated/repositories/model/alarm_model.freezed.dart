// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../../repositories/model/alarm_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlarmModel {

 String get id; DateTime get alarmTime;// アラーム時刻
 bool get isEnabled;
/// Create a copy of AlarmModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmModelCopyWith<AlarmModel> get copyWith => _$AlarmModelCopyWithImpl<AlarmModel>(this as AlarmModel, _$identity);

  /// Serializes this AlarmModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmModel&&(identical(other.id, id) || other.id == id)&&(identical(other.alarmTime, alarmTime) || other.alarmTime == alarmTime)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,alarmTime,isEnabled);

@override
String toString() {
  return 'AlarmModel(id: $id, alarmTime: $alarmTime, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $AlarmModelCopyWith<$Res>  {
  factory $AlarmModelCopyWith(AlarmModel value, $Res Function(AlarmModel) _then) = _$AlarmModelCopyWithImpl;
@useResult
$Res call({
 String id, DateTime alarmTime, bool isEnabled
});




}
/// @nodoc
class _$AlarmModelCopyWithImpl<$Res>
    implements $AlarmModelCopyWith<$Res> {
  _$AlarmModelCopyWithImpl(this._self, this._then);

  final AlarmModel _self;
  final $Res Function(AlarmModel) _then;

/// Create a copy of AlarmModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? alarmTime = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alarmTime: null == alarmTime ? _self.alarmTime : alarmTime // ignore: cast_nullable_to_non_nullable
as DateTime,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmModel].
extension AlarmModelPatterns on AlarmModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmModel value)  $default,){
final _that = this;
switch (_that) {
case _AlarmModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmModel value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime alarmTime,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmModel() when $default != null:
return $default(_that.id,_that.alarmTime,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime alarmTime,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _AlarmModel():
return $default(_that.id,_that.alarmTime,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime alarmTime,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _AlarmModel() when $default != null:
return $default(_that.id,_that.alarmTime,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmModel implements AlarmModel {
  const _AlarmModel({required this.id, required this.alarmTime, required this.isEnabled});
  factory _AlarmModel.fromJson(Map<String, dynamic> json) => _$AlarmModelFromJson(json);

@override final  String id;
@override final  DateTime alarmTime;
// アラーム時刻
@override final  bool isEnabled;

/// Create a copy of AlarmModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmModelCopyWith<_AlarmModel> get copyWith => __$AlarmModelCopyWithImpl<_AlarmModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmModel&&(identical(other.id, id) || other.id == id)&&(identical(other.alarmTime, alarmTime) || other.alarmTime == alarmTime)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,alarmTime,isEnabled);

@override
String toString() {
  return 'AlarmModel(id: $id, alarmTime: $alarmTime, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$AlarmModelCopyWith<$Res> implements $AlarmModelCopyWith<$Res> {
  factory _$AlarmModelCopyWith(_AlarmModel value, $Res Function(_AlarmModel) _then) = __$AlarmModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime alarmTime, bool isEnabled
});




}
/// @nodoc
class __$AlarmModelCopyWithImpl<$Res>
    implements _$AlarmModelCopyWith<$Res> {
  __$AlarmModelCopyWithImpl(this._self, this._then);

  final _AlarmModel _self;
  final $Res Function(_AlarmModel) _then;

/// Create a copy of AlarmModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? alarmTime = null,Object? isEnabled = null,}) {
  return _then(_AlarmModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alarmTime: null == alarmTime ? _self.alarmTime : alarmTime // ignore: cast_nullable_to_non_nullable
as DateTime,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
