import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryViewmodel extends ChangeNotifier {
  PasswordRecoveryViewmodel({required RecoveryRepository recoveryRepository})
    : _recoveryRepository = recoveryRepository {
    sendRecoveryEmail = Command1<void, (String email,)>(_sendRecoveryEmail);
  }

  final RecoveryRepository _recoveryRepository;
  late Command1 sendRecoveryEmail;

  Future<Result<String>> _sendRecoveryEmail((String,) credentials) async {
    final (String email,) = credentials;
    try {
      final result = await _recoveryRepository.sendRecoveryEmail(email: email);
      return result;
    } finally {
      notifyListeners();
    }
  }
}
