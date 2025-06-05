import 'package:flutter/material.dart';
import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';

class RegistrationViewModel extends ChangeNotifier {
  RegistrationViewModel({
    required RegistrationRepository registrationRepository,
  }) : _registrationRepository = registrationRepository {
    register = Command1<void, (String, String)>(_register);
  }

  final RegistrationRepository _registrationRepository;
  late Command1 register;

  Future<Result<String?>> _register((String, String) data) async {
    final (email, password) = data;
    try {
      final result = await _registrationRepository.register(
        email: email,
        password: password,
      );
      return result;
    } finally {
      notifyListeners();
    }
  }
}
