// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginResponse {

 String get id; TokenData get token_data;
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginResponseCopyWith<LoginResponse> get copyWith => _$LoginResponseCopyWithImpl<LoginResponse>(this as LoginResponse, _$identity);

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.token_data, token_data) || other.token_data == token_data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token_data);

@override
String toString() {
  return 'LoginResponse(id: $id, token_data: $token_data)';
}


}

/// @nodoc
abstract mixin class $LoginResponseCopyWith<$Res>  {
  factory $LoginResponseCopyWith(LoginResponse value, $Res Function(LoginResponse) _then) = _$LoginResponseCopyWithImpl;
@useResult
$Res call({
 String id, TokenData token_data
});


$TokenDataCopyWith<$Res> get token_data;

}
/// @nodoc
class _$LoginResponseCopyWithImpl<$Res>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._self, this._then);

  final LoginResponse _self;
  final $Res Function(LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? token_data = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token_data: null == token_data ? _self.token_data : token_data // ignore: cast_nullable_to_non_nullable
as TokenData,
  ));
}
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenDataCopyWith<$Res> get token_data {
  
  return $TokenDataCopyWith<$Res>(_self.token_data, (value) {
    return _then(_self.copyWith(token_data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _LoginResponse implements LoginResponse {
  const _LoginResponse({required this.id, required this.token_data});
  factory _LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

@override final  String id;
@override final  TokenData token_data;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginResponseCopyWith<_LoginResponse> get copyWith => __$LoginResponseCopyWithImpl<_LoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.token_data, token_data) || other.token_data == token_data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token_data);

@override
String toString() {
  return 'LoginResponse(id: $id, token_data: $token_data)';
}


}

/// @nodoc
abstract mixin class _$LoginResponseCopyWith<$Res> implements $LoginResponseCopyWith<$Res> {
  factory _$LoginResponseCopyWith(_LoginResponse value, $Res Function(_LoginResponse) _then) = __$LoginResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, TokenData token_data
});


@override $TokenDataCopyWith<$Res> get token_data;

}
/// @nodoc
class __$LoginResponseCopyWithImpl<$Res>
    implements _$LoginResponseCopyWith<$Res> {
  __$LoginResponseCopyWithImpl(this._self, this._then);

  final _LoginResponse _self;
  final $Res Function(_LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? token_data = null,}) {
  return _then(_LoginResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token_data: null == token_data ? _self.token_data : token_data // ignore: cast_nullable_to_non_nullable
as TokenData,
  ));
}

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenDataCopyWith<$Res> get token_data {
  
  return $TokenDataCopyWith<$Res>(_self.token_data, (value) {
    return _then(_self.copyWith(token_data: value));
  });
}
}


/// @nodoc
mixin _$TokenData {

 String get access_token; String get refresh_token;
/// Create a copy of TokenData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenDataCopyWith<TokenData> get copyWith => _$TokenDataCopyWithImpl<TokenData>(this as TokenData, _$identity);

  /// Serializes this TokenData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenData&&(identical(other.access_token, access_token) || other.access_token == access_token)&&(identical(other.refresh_token, refresh_token) || other.refresh_token == refresh_token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,access_token,refresh_token);

@override
String toString() {
  return 'TokenData(access_token: $access_token, refresh_token: $refresh_token)';
}


}

/// @nodoc
abstract mixin class $TokenDataCopyWith<$Res>  {
  factory $TokenDataCopyWith(TokenData value, $Res Function(TokenData) _then) = _$TokenDataCopyWithImpl;
@useResult
$Res call({
 String access_token, String refresh_token
});




}
/// @nodoc
class _$TokenDataCopyWithImpl<$Res>
    implements $TokenDataCopyWith<$Res> {
  _$TokenDataCopyWithImpl(this._self, this._then);

  final TokenData _self;
  final $Res Function(TokenData) _then;

/// Create a copy of TokenData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? access_token = null,Object? refresh_token = null,}) {
  return _then(_self.copyWith(
access_token: null == access_token ? _self.access_token : access_token // ignore: cast_nullable_to_non_nullable
as String,refresh_token: null == refresh_token ? _self.refresh_token : refresh_token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TokenData implements TokenData {
   _TokenData({required this.access_token, required this.refresh_token});
  factory _TokenData.fromJson(Map<String, dynamic> json) => _$TokenDataFromJson(json);

@override final  String access_token;
@override final  String refresh_token;

/// Create a copy of TokenData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenDataCopyWith<_TokenData> get copyWith => __$TokenDataCopyWithImpl<_TokenData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenData&&(identical(other.access_token, access_token) || other.access_token == access_token)&&(identical(other.refresh_token, refresh_token) || other.refresh_token == refresh_token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,access_token,refresh_token);

@override
String toString() {
  return 'TokenData(access_token: $access_token, refresh_token: $refresh_token)';
}


}

/// @nodoc
abstract mixin class _$TokenDataCopyWith<$Res> implements $TokenDataCopyWith<$Res> {
  factory _$TokenDataCopyWith(_TokenData value, $Res Function(_TokenData) _then) = __$TokenDataCopyWithImpl;
@override @useResult
$Res call({
 String access_token, String refresh_token
});




}
/// @nodoc
class __$TokenDataCopyWithImpl<$Res>
    implements _$TokenDataCopyWith<$Res> {
  __$TokenDataCopyWithImpl(this._self, this._then);

  final _TokenData _self;
  final $Res Function(_TokenData) _then;

/// Create a copy of TokenData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? access_token = null,Object? refresh_token = null,}) {
  return _then(_TokenData(
access_token: null == access_token ? _self.access_token : access_token // ignore: cast_nullable_to_non_nullable
as String,refresh_token: null == refresh_token ? _self.refresh_token : refresh_token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
