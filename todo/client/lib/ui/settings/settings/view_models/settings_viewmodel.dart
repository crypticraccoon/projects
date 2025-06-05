import 'package:todo/data/repositories/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:todo/data/services/shared_prefrences_service.dart';
import 'package:todo/domain/models/userdata/userdata.dart';
import 'package:todo/utils/command.dart';
import '../../../../utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required SharedPreferencesService sharedPrefrences,
    required UserRepository userRepository,
    required AuthRepository authRepository,
  }) : _sharedPrefrences = sharedPrefrences,
       _userRepository = userRepository,
       _authRepository = authRepository {
    loadUserData = Command0(_loadUserData)..execute();
    logout = Command0(_logout);
  }

  final SharedPreferencesService _sharedPrefrences;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  late UserData? _userData;
  UserData? get userData => _userData;

  late Command0 loadUserData;
  late Command0 logout;

  Future<Result<UserData?>> _loadUserData() async {
    try {
      final result = await _sharedPrefrences.fetchUserData();

      switch (result) {
        case Ok<UserData?>():
          _userData = result.value;
          return result;
        case Error<UserData?>():
          return result;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<String?>> _logout() async {
    try {
      final result = await _authRepository.logout();
      return result;
    } finally {
      notifyListeners();
    }
  }
}
