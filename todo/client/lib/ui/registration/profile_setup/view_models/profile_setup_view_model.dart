import 'package:flutter/material.dart';
import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';

class ProfileSetupViewModel extends ChangeNotifier {
  ProfileSetupViewModel({
    required RegistrationRepository registrationRepository,
  }) : _registrationRepository = registrationRepository {
    setupProfile = Command1<void, (String, String, String)>(_setupProfile);
  }

  final RegistrationRepository _registrationRepository;
  late Command1 setupProfile;

  Future<Result<String?>> _setupProfile((String, String, String) data) async {
    final (id, code, username) = data;

    try {
      final result = await _registrationRepository.setUserData(
        id: id,
        code: code,
        username: username,
      );
      return result;
    } finally {
      notifyListeners();
    }
  }
}
