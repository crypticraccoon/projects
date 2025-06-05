import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class UpdateUsernameViewmodel extends ChangeNotifier {
  UpdateUsernameViewmodel({required UserRepository userRepository})
    : _userRepository = userRepository {
    updateUsername = Command1<void, (String email,)>(_updateUsername);
  }

  final UserRepository _userRepository;
  late Command1 updateUsername;

  Future<Result<String?>> _updateUsername((String username,) data) async {
    final (username,) = data;

    try {
      final result = await _userRepository.updateUsername(username: username);
      return result;
    } finally {
      notifyListeners();
    }
  }
}
