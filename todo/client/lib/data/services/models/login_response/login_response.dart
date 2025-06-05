import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';

part 'login_response.g.dart';

/// LoginResponse model.
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String id,
    required TokenData token_data,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
abstract class TokenData with _$TokenData {
  factory TokenData({
    required String access_token,
    required String refresh_token,
  }) = _TokenData;

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);
}
