import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/data/services/api/api.dart';
import 'package:todo/data/services/models/login_response/login_response.dart';
import 'package:todo/data/services/models/todo_stats_response/todo_stats_response.dart';
import 'package:todo/data/services/models/user_data_response/user_data_response.dart';
import 'package:todo/data/services/shared_prefrences_service.dart';
import 'package:flutter/material.dart';
import 'package:todo/domain/models/todo/todo.dart' as todo_domain;
import 'package:todo/data/services/models/todo_response/todo_response.dart';

import '../../../utils/result.dart';

typedef RefreshTokens =
    Map<String, String>? Function(String refreshToken, String accessToken);

class AuthRepository extends ChangeNotifier {
  AuthRepository({
    required ApiClient apiClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _apiClient = apiClient,
       _sharedPreferencesService = sharedPreferencesService {
    _apiClient.authenticated = authToggler;
  }

  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;

  void authToggler() => _isAuthenticated = false;

  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    await _fetch();
    return _isAuthenticated ?? false;
  }

  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchAccessToken();
    switch (result) {
      case Ok<String?>():
        _isAuthenticated = result.value != null;
      case Error<String?>():
        return Future.value();
    }
  }

  Future<Result<String?>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _apiClient.login(email: email, password: password);
      final sp = await SharedPreferences.getInstance();
      await sp.clear();
      switch (result) {
        case Ok<LoginResponse>():
          _isAuthenticated = true;
          await _sharedPreferencesService.saveTokens(
            result.value.token_data.access_token,
            result.value.token_data.refresh_token,
          );
          return Result.ok(null);
        case Error<LoginResponse>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<String?>> logout() async {
    try {
      final result = await _apiClient.logout();
      _isAuthenticated = false;
      await _sharedPreferencesService.saveTokens(null, null);
      switch (result) {
        case Ok<String>():
          return Result.ok(null);
        case Error<String>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }
}

class RecoveryRepository {
  RecoveryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<String>> sendRecoveryEmail({required String email}) async {
    final result = await _apiClient.sendPasswordRecoveryEmail(email: email);
    switch (result) {
      case Ok<String>():
        return Result.ok(result.value);
      case Error<String>():
        return Result.error(result.error);
    }
  }

  Future<Result<String>> updatePassword({
    required String email,
    required String code,
    required String password,
  }) async {
    final result = await _apiClient.updateRecoveryPassword(
      email: email,
      code: code,
      password: password,
    );
    switch (result) {
      case Ok<String>():
        return Result.ok(result.value);
      case Error<String>():
        return Result.error(result.error);
    }
  }
}

class RegistrationRepository {
  RegistrationRepository({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<String>> register({
    required String email,
    required String password,
  }) async {
    final result = await _apiClient.registerUser(
      email: email,
      password: password,
    );
    switch (result) {
      case Ok<String>():
        return Result.ok(result.value);
      case Error<String>():
        return Result.error(result.error);
    }
  }

  Future<Result<String>> setUserData({
    required String username,
    required String id,
    required String code,
  }) async {
    final result = await _apiClient.registerUserData(
      username: username,
      id: id,
      code: code,
    );
    switch (result) {
      case Ok<String>():
        return Result.ok(result.value);
      case Error<String>():
        return Result.error(result.error);
    }
  }
}

class UserRepository {
  UserRepository({
    required ApiClient apiClient,
    required SharedPreferencesService sharedPreferencesService,
    required AuthRepository authRepository,
  }) : _apiClient = apiClient,
       _sharedPreferencesService = sharedPreferencesService,
       _authRepository = authRepository;

  final ApiClient _apiClient;
  final AuthRepository _authRepository;
  final SharedPreferencesService _sharedPreferencesService;

  Future<String?> _fetchAccessToken() async {
    final result = await _sharedPreferencesService.fetchAccessToken();
    switch (result) {
      case Ok<String?>():
        return result.value;
      case Error<String?>():
        await _authRepository.logout();
        return null;
    }
  }

  //Get Userdata
  Future<Result<String?>> getUserData() async {
    final result = await _apiClient.getUserData(
      accessToken: await _fetchAccessToken() ?? "",
    );

    switch (result) {
      case Ok<UserDataResponse>():
        await _sharedPreferencesService.saveUserData(
          email: result.value.email,
          username: result.value.username,
          id: result.value.id,
        );
        return Result.ok(null);
      case Error<UserDataResponse>():
        return Result.error(result.error);
    }
  }

  //Update Username
  Future<Result<String?>> updateUsername({required String username}) async {
    final result = await _apiClient.updateUsername(
      accessToken: await _fetchAccessToken() ?? "",
      username: username,
    );

    switch (result) {
      case Ok<String>():
        await _sharedPreferencesService.updateUsername(value: username);
        return Result.ok(null);
      case Error<String>():
        return Result.error(result.error);
    }
  }

  //Update Email
  Future<Result<String?>> updateUserEmail({required String email}) async {
    final result = await _apiClient.updateEmail(
      accessToken: await _fetchAccessToken() ?? "",
      email: email,
    );

    switch (result) {
      case Ok<String>():
        await _sharedPreferencesService.updateEmail(value: email);

        return Result.ok(null);
      case Error<String>():
        return Result.error(result.error);
    }
  }

  //Uodate Password
  Future<Result<String?>> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    final result = await _apiClient.updatePassword(
      accessToken: await _fetchAccessToken() ?? "",
      password: password,
      newPassword: newPassword,
    );

    switch (result) {
      case Ok<String>():
        return Result.ok(null);
      case Error<String>():
        return Result.error(result.error);
    }
  }
}

class TodoRepository {
  TodoRepository({
    required ApiClient apiClient,
    required SharedPreferencesService sharedPreferencesService,
    required AuthRepository authRepository,
  }) : _apiClient = apiClient,
       _authRepository = authRepository,
       _sharedPreferencesService = sharedPreferencesService;

  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService;
  final AuthRepository _authRepository;

  Future<String?> _fetchAccessToken() async {
    final result = await _sharedPreferencesService.fetchAccessToken();
    switch (result) {
      case Ok<String?>():
        return result.value;
      case Error<String?>():
        await _authRepository.logout();
        return null;
    }
  }

  //Create Todo

  Future<Result<String?>> createTodo({
    required String title,
    required String body,
    required String deadline,
  }) async {
    final result = await _apiClient.createTodo(
      accessToken: await _fetchAccessToken() ?? "",
      deadline: deadline,
      title: title,
      body: body,
    );

    switch (result) {
      case Ok<TodoResponse>():
        return Result.ok(null);
      case Error<TodoResponse>():
        return Result.error(result.error);
    }
  }

  //Get Todo by Id
  Future<Result<TodoResponse>> getTodoById({required String todoId}) async {
    final result = await _apiClient.getTodo(
      accessToken: await _fetchAccessToken() ?? "",
      id: todoId,
    );

    switch (result) {
      case Ok<TodoResponse>():
        return Result.ok(result.value);
      case Error<TodoResponse>():
        return Result.error(result.error);
    }
  }

  // Get Todo by date
  Future<Result<List<todo_domain.TodoResponse>>> getTodosByDate({
    required int page,
    required String date,
  }) async {
    final result = await _apiClient.getTodosByDate(
      accessToken: await _fetchAccessToken() ?? "",
      page: page,
      size: 10,
      date: date,
    );

    switch (result) {
      case Ok<List<TodoResponse>>():
        final convertedData =
            result.value.map((TodoResponse e) {
              return todo_domain.TodoResponse(
                id: e.id,
                body: e.body,
                title: e.title,
                createdAt: e.createdAt,
                completedAt: e.completedAt,
                isCompleted: e.isCompleted,
                userId: e.userId,
                deadline: e.deadline,
              );
            }).toList();

        _sharedPreferencesService.addTodos(convertedData, date);
        return Result.ok(convertedData);
      case Error<List<TodoResponse>>():
        return Result.error(result.error);
    }
  }

  // Get Completed Todo
  Future<Result<List<TodoResponse>>> getTodosCompletedTodos({
    required int page,
    required String date,
  }) async {
    final result = await _apiClient.getCompletedTodos(
      accessToken: await _fetchAccessToken() ?? "",
      page: page,
      size: 10,
    );

    switch (result) {
      case Ok<List<TodoResponse>>():
        return Result.ok(result.value);
      case Error<List<TodoResponse>>():
        return Result.error(result.error);
    }
  }

  // Get Todo Stats
  Future<Result<TodoStatsResponse>> getTodosStats() async {
    final result = await _apiClient.getTodoStats(
      accessToken: await _fetchAccessToken() ?? "",
    );

    switch (result) {
      case Ok<TodoStatsResponse>():
        return Result.ok(result.value);
      case Error<TodoStatsResponse>():
        return Result.error(result.error);
    }
  }

  // Complete Todo
  Future<Result<List<todo_domain.TodoResponse>>> completeTodo({
    required String date,
    required String todoId,
  }) async {
    final result = await _apiClient.completeTodo(
      accessToken: await _fetchAccessToken() ?? "",
      id: todoId,
    );

    switch (result) {
      case Ok<String>():
        final result = await _sharedPreferencesService.completeTodo(
          date: date,
          id: todoId,
        );
        return result;

      case Error<String>():
        return Result.error(result.error);
    }
  }

  // Updated Todo
  Future<Result<String?>> updateTodo({
    required todo_domain.TodoResponse data,
    required String date,
  }) async {
    final result = await _apiClient.updateTodo(
      accessToken: await _fetchAccessToken() ?? "",
      id: data.id,
      deadline: data.deadline.toUtc().toIso8601String(),
      title: data.title,
      body: data.body,
    );

    switch (result) {
      case Ok<String>():
        await _sharedPreferencesService.updateTodo(
          updatedData: data,
          date: date,
        );

        return Result.ok(null);
      case Error<String>():
        return Result.error(result.error);
    }
  }

  // Delete Todo
  Future<Result<List<todo_domain.TodoResponse>>> deleteTodo({
    required String date,
    required String todoId,
  }) async {
    final result = await _apiClient.deleteTodo(
      accessToken: await _fetchAccessToken() ?? "",
      id: todoId,
    );

    switch (result) {
      case Ok<String>():
        final result = await _sharedPreferencesService.deleteTodos(
          date: date,
          id: todoId,
        );
        return result;
      case Error<String>():
        return Result.error(result.error);
    }
  }
}
