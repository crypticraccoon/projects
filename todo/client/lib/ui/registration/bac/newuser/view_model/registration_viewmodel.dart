import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class RegistrationViewmodel extends ChangeNotifier {
  RegistrationViewmodel({
    required RegistrationRepository registrationRepository,
  }) : _registrationRepository = registrationRepository {
    registerUser = Command1<void, (String email, String password)>(
      _registerUser,
    );
  }

  final RegistrationRepository _registrationRepository;

  late Command1 registerUser;

  Future<Result<String>> _registerUser(
    (String email, String password) credentials,
  ) async {
    final (email, password) = credentials;
    final result = await _registrationRepository.register(
      email: email,
      password: password,
    );
    return result;
  }
}
