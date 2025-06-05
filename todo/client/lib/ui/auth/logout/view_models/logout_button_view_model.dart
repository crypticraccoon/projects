import 'package:flutter/foundation.dart';
import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';

class LogoutButtonViewModel extends ChangeNotifier {
  LogoutButtonViewModel({required AuthRepository authRepo})
    : _authRepo = authRepo {
    logout = Command0(_logout);
  }

  final AuthRepository _authRepo;
  late Command0 logout;

  Future<Result<String?>> _logout() async {
    try {
      final result = await _authRepo.logout();
      return result;
    } finally {
      notifyListeners();
    }
  }
}
