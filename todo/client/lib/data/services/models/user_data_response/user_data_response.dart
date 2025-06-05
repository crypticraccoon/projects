import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data_response.freezed.dart';

part 'user_data_response.g.dart';

/// UserDataResponse model.
@freezed
abstract class UserDataResponse with _$UserDataResponse {
  const factory UserDataResponse({
    required String id,
    required String username,
    required String email,
  }) = _UserDataResponse;

  factory UserDataResponse.fromJson(Map<String, Object?> json) =>
      _$UserDataResponseFromJson(json);
}
