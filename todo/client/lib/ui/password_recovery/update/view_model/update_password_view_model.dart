import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class UpdateRecoveryPasswordViewModel extends ChangeNotifier {
  UpdateRecoveryPasswordViewModel({
    required RecoveryRepository recoveryRepository,
  }) : _recoveryRepository = recoveryRepository {
    updatePassword =
        Command1<void, (String email, String code, String password)>(
          _updatePassword,
        );
  }
  final RecoveryRepository _recoveryRepository;

  late Command1 updatePassword;

  Future<Result<String>> _updatePassword(
    (String email, String code, String password) credentials,
  ) async {
    final (email, code, password) = credentials;
    try {
      final result = await _recoveryRepository.updatePassword(
        email: email,
        code: code,
        password: password,
      );
      return result;
    } finally {
      notifyListeners();
    }
  }
}
