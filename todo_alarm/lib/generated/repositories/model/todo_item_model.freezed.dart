// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../../repositories/model/todo_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoItemModel {

 String get id; String get title; TodoStatus get status; DateTime? get deadline;
/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoItemModelCopyWith<TodoItemModel> get copyWith => _$TodoItemModelCopyWithImpl<TodoItemModel>(this as TodoItemModel, _$identity);

  /// Serializes this TodoItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadline, deadline) || other.deadline == deadline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,deadline);

@override
String toString() {
  return 'TodoItemModel(id: $id, title: $title, status: $status, deadline: $deadline)';
}


}

/// @nodoc
abstract mixin class $TodoItemModelCopyWith<$Res>  {
  factory $TodoItemModelCopyWith(TodoItemModel value, $Res Function(TodoItemModel) _then) = _$TodoItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, TodoStatus status, DateTime? deadline
});




}
/// @nodoc
class _$TodoItemModelCopyWithImpl<$Res>
    implements $TodoItemModelCopyWith<$Res> {
  _$TodoItemModelCopyWithImpl(this._self, this._then);

  final TodoItemModel _self;
  final $Res Function(TodoItemModel) _then;

/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? deadline = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TodoStatus,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TodoItemModel].
extension TodoItemModelPatterns on TodoItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoItemModel value)  $default,){
final _that = this;
switch (_that) {
case _TodoItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  TodoStatus status,  DateTime? deadline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.deadline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  TodoStatus status,  DateTime? deadline)  $default,) {final _that = this;
switch (_that) {
case _TodoItemModel():
return $default(_that.id,_that.title,_that.status,_that.deadline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  TodoStatus status,  DateTime? deadline)?  $default,) {final _that = this;
switch (_that) {
case _TodoItemModel() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.deadline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodoItemModel implements TodoItemModel {
  const _TodoItemModel({required this.id, required this.title, this.status = TodoStatus.notStarted, this.deadline});
  factory _TodoItemModel.fromJson(Map<String, dynamic> json) => _$TodoItemModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  TodoStatus status;
@override final  DateTime? deadline;

/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoItemModelCopyWith<_TodoItemModel> get copyWith => __$TodoItemModelCopyWithImpl<_TodoItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadline, deadline) || other.deadline == deadline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,deadline);

@override
String toString() {
  return 'TodoItemModel(id: $id, title: $title, status: $status, deadline: $deadline)';
}


}

/// @nodoc
abstract mixin class _$TodoItemModelCopyWith<$Res> implements $TodoItemModelCopyWith<$Res> {
  factory _$TodoItemModelCopyWith(_TodoItemModel value, $Res Function(_TodoItemModel) _then) = __$TodoItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, TodoStatus status, DateTime? deadline
});




}
/// @nodoc
class __$TodoItemModelCopyWithImpl<$Res>
    implements _$TodoItemModelCopyWith<$Res> {
  __$TodoItemModelCopyWithImpl(this._self, this._then);

  final _TodoItemModel _self;
  final $Res Function(_TodoItemModel) _then;

/// Create a copy of TodoItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? deadline = freezed,}) {
  return _then(_TodoItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TodoStatus,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
