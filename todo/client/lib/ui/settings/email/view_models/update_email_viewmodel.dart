import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class UpdateEmailViewmodel extends ChangeNotifier {
  UpdateEmailViewmodel({required UserRepository userRepository})
    : _userRepository = userRepository {
    updateEmail = Command1<void, (String email,)>(_updateEmail);
  }

  final UserRepository _userRepository;

  late Command1 updateEmail;

  Future<Result<String?>> _updateEmail((String email,) data) async {
    final (email,) = data;

    try {
      final result = await _userRepository.updateUserEmail(email: email);
      return result;
    } finally {
      notifyListeners();
    }
  }
}
