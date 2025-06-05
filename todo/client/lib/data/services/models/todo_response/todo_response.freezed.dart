// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoResponse {

 String get id;@JsonKey(name: 'user_id') String get userId; String get title; String get body; DateTime get deadline;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'is_completed') bool get isCompleted;
/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoResponseCopyWith<TodoResponse> get copyWith => _$TodoResponseCopyWithImpl<TodoResponse>(this as TodoResponse, _$identity);

  /// Serializes this TodoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,body,deadline,createdAt,completedAt,isCompleted);

@override
String toString() {
  return 'TodoResponse(id: $id, userId: $userId, title: $title, body: $body, deadline: $deadline, createdAt: $createdAt, completedAt: $completedAt, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $TodoResponseCopyWith<$Res>  {
  factory $TodoResponseCopyWith(TodoResponse value, $Res Function(TodoResponse) _then) = _$TodoResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String title, String body, DateTime deadline,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'is_completed') bool isCompleted
});




}
/// @nodoc
class _$TodoResponseCopyWithImpl<$Res>
    implements $TodoResponseCopyWith<$Res> {
  _$TodoResponseCopyWithImpl(this._self, this._then);

  final TodoResponse _self;
  final $Res Function(TodoResponse) _then;

/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? body = null,Object? deadline = null,Object? createdAt = null,Object? completedAt = freezed,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TodoResponse implements TodoResponse {
  const _TodoResponse({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.title, required this.body, required this.deadline, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'is_completed') required this.isCompleted});
  factory _TodoResponse.fromJson(Map<String, dynamic> json) => _$TodoResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String title;
@override final  String body;
@override final  DateTime deadline;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;

/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoResponseCopyWith<_TodoResponse> get copyWith => __$TodoResponseCopyWithImpl<_TodoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,body,deadline,createdAt,completedAt,isCompleted);

@override
String toString() {
  return 'TodoResponse(id: $id, userId: $userId, title: $title, body: $body, deadline: $deadline, createdAt: $createdAt, completedAt: $completedAt, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$TodoResponseCopyWith<$Res> implements $TodoResponseCopyWith<$Res> {
  factory _$TodoResponseCopyWith(_TodoResponse value, $Res Function(_TodoResponse) _then) = __$TodoResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String title, String body, DateTime deadline,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'is_completed') bool isCompleted
});




}
/// @nodoc
class __$TodoResponseCopyWithImpl<$Res>
    implements _$TodoResponseCopyWith<$Res> {
  __$TodoResponseCopyWithImpl(this._self, this._then);

  final _TodoResponse _self;
  final $Res Function(_TodoResponse) _then;

/// Create a copy of TodoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? body = null,Object? deadline = null,Object? createdAt = null,Object? completedAt = freezed,Object? isCompleted = null,}) {
  return _then(_TodoResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
