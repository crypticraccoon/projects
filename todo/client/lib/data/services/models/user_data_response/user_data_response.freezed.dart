// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDataResponse {

 String get id; String get username; String get email;
/// Create a copy of UserDataResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDataResponseCopyWith<UserDataResponse> get copyWith => _$UserDataResponseCopyWithImpl<UserDataResponse>(this as UserDataResponse, _$identity);

  /// Serializes this UserDataResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDataResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email);

@override
String toString() {
  return 'UserDataResponse(id: $id, username: $username, email: $email)';
}


}

/// @nodoc
abstract mixin class $UserDataResponseCopyWith<$Res>  {
  factory $UserDataResponseCopyWith(UserDataResponse value, $Res Function(UserDataResponse) _then) = _$UserDataResponseCopyWithImpl;
@useResult
$Res call({
 String id, String username, String email
});




}
/// @nodoc
class _$UserDataResponseCopyWithImpl<$Res>
    implements $UserDataResponseCopyWith<$Res> {
  _$UserDataResponseCopyWithImpl(this._self, this._then);

  final UserDataResponse _self;
  final $Res Function(UserDataResponse) _then;

/// Create a copy of UserDataResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserDataResponse implements UserDataResponse {
  const _UserDataResponse({required this.id, required this.username, required this.email});
  factory _UserDataResponse.fromJson(Map<String, dynamic> json) => _$UserDataResponseFromJson(json);

@override final  String id;
@override final  String username;
@override final  String email;

/// Create a copy of UserDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDataResponseCopyWith<_UserDataResponse> get copyWith => __$UserDataResponseCopyWithImpl<_UserDataResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDataResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDataResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email);

@override
String toString() {
  return 'UserDataResponse(id: $id, username: $username, email: $email)';
}


}

/// @nodoc
abstract mixin class _$UserDataResponseCopyWith<$Res> implements $UserDataResponseCopyWith<$Res> {
  factory _$UserDataResponseCopyWith(_UserDataResponse value, $Res Function(_UserDataResponse) _then) = __$UserDataResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String email
});




}
/// @nodoc
class __$UserDataResponseCopyWithImpl<$Res>
    implements _$UserDataResponseCopyWith<$Res> {
  __$UserDataResponseCopyWithImpl(this._self, this._then);

  final _UserDataResponse _self;
  final $Res Function(_UserDataResponse) _then;

/// Create a copy of UserDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,}) {
  return _then(_UserDataResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
