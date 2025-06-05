// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoStatsResponse {

 int get complete;@JsonKey(name: 'in_progress') int get inProgress;
/// Create a copy of TodoStatsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoStatsResponseCopyWith<TodoStatsResponse> get copyWith => _$TodoStatsResponseCopyWithImpl<TodoStatsResponse>(this as TodoStatsResponse, _$identity);

  /// Serializes this TodoStatsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoStatsResponse&&(identical(other.complete, complete) || other.complete == complete)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,complete,inProgress);

@override
String toString() {
  return 'TodoStatsResponse(complete: $complete, inProgress: $inProgress)';
}


}

/// @nodoc
abstract mixin class $TodoStatsResponseCopyWith<$Res>  {
  factory $TodoStatsResponseCopyWith(TodoStatsResponse value, $Res Function(TodoStatsResponse) _then) = _$TodoStatsResponseCopyWithImpl;
@useResult
$Res call({
 int complete,@JsonKey(name: 'in_progress') int inProgress
});




}
/// @nodoc
class _$TodoStatsResponseCopyWithImpl<$Res>
    implements $TodoStatsResponseCopyWith<$Res> {
  _$TodoStatsResponseCopyWithImpl(this._self, this._then);

  final TodoStatsResponse _self;
  final $Res Function(TodoStatsResponse) _then;

/// Create a copy of TodoStatsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? complete = null,Object? inProgress = null,}) {
  return _then(_self.copyWith(
complete: null == complete ? _self.complete : complete // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TodoStatsResponse implements TodoStatsResponse {
  const _TodoStatsResponse({required this.complete, @JsonKey(name: 'in_progress') required this.inProgress});
  factory _TodoStatsResponse.fromJson(Map<String, dynamic> json) => _$TodoStatsResponseFromJson(json);

@override final  int complete;
@override@JsonKey(name: 'in_progress') final  int inProgress;

/// Create a copy of TodoStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoStatsResponseCopyWith<_TodoStatsResponse> get copyWith => __$TodoStatsResponseCopyWithImpl<_TodoStatsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoStatsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoStatsResponse&&(identical(other.complete, complete) || other.complete == complete)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,complete,inProgress);

@override
String toString() {
  return 'TodoStatsResponse(complete: $complete, inProgress: $inProgress)';
}


}

/// @nodoc
abstract mixin class _$TodoStatsResponseCopyWith<$Res> implements $TodoStatsResponseCopyWith<$Res> {
  factory _$TodoStatsResponseCopyWith(_TodoStatsResponse value, $Res Function(_TodoStatsResponse) _then) = __$TodoStatsResponseCopyWithImpl;
@override @useResult
$Res call({
 int complete,@JsonKey(name: 'in_progress') int inProgress
});




}
/// @nodoc
class __$TodoStatsResponseCopyWithImpl<$Res>
    implements _$TodoStatsResponseCopyWith<$Res> {
  __$TodoStatsResponseCopyWithImpl(this._self, this._then);

  final _TodoStatsResponse _self;
  final $Res Function(_TodoStatsResponse) _then;

/// Create a copy of TodoStatsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? complete = null,Object? inProgress = null,}) {
  return _then(_TodoStatsResponse(
complete: null == complete ? _self.complete : complete // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
