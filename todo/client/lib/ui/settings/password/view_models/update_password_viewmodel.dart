import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class UpdatePasswordViewModel extends ChangeNotifier {
  UpdatePasswordViewModel({required UserRepository userRepository})
    : _userRepository = userRepository {
    updatePassword = Command1<void, (String newPassword, String oldPassword)>(
      _updatePassword,
    );
  }

  final UserRepository _userRepository;

  late Command1 updatePassword;

  Future<Result<String?>> _updatePassword(
    (String newPassword, String oldPassword) data,
  ) async {
    final (newPassword, oldPassword) = data;

    try {
      final result = await _userRepository.updatePassword(
        newPassword: newPassword,
        password: oldPassword,
      );
      return result;
    } finally {
      notifyListeners();
    }
  }
}
