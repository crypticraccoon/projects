import 'package:freezed_annotation/freezed_annotation.dart';

part 'userdata.freezed.dart';

part 'userdata.g.dart';

/// UserData model.
@freezed
abstract class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String username,
    required String email,
  }) = _UserData;

  const UserData._();

  String get getUsername => username;
  String get getEmail => email;
  factory UserData.fromJson(Map<String, Object?> json) =>
      _$UserDataFromJson(json);
}
