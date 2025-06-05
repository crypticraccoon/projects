// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      id: json['id'] as String,
      token_data: TokenData.fromJson(
        json['token_data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{'id': instance.id, 'token_data': instance.token_data};

_TokenData _$TokenDataFromJson(Map<String, dynamic> json) => _TokenData(
  access_token: json['access_token'] as String,
  refresh_token: json['refresh_token'] as String,
);

Map<String, dynamic> _$TokenDataToJson(_TokenData instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'refresh_token': instance.refresh_token,
    };
