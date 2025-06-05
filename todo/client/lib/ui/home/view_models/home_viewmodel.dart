import 'package:todo/data/repositories/api_repository.dart';
//import 'package:todo/data/services/models/todo_response/todo_response.dart';
import 'package:todo/data/services/shared_prefrences_service.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:todo/domain/models/todo/todo.dart';

/// Create endpoint to get month status to update calender widget
/// Get Todos by date and update
/// Add todo screen
/// Delete Todo

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required SharedPreferencesService sharedPrefrences,
    required UserRepository userRepository,
    required TodoRepository todoRepository,
  }) : _userRepository = userRepository,
       _todoRepository = todoRepository,
       _sharedPreferences = sharedPrefrences {
    getUserData = Command0(_getUserData)..execute();
    deleteTodo = Command1<void, (String date, String id)>(_deleteTodo);

    final date = DateTime.now().toString().split(" ")[0];
    getTodo = Command1<void, (String date, int page)>(_getTodoByData)
      ..execute((date, 1));
    completeTodo = Command1<void, (String date, String id)>(_completeTodo);
  }

  final UserRepository _userRepository;
  final TodoRepository _todoRepository;
  final SharedPreferencesService _sharedPreferences;

  late Command0 getUserData;
  late Command1 getTodo;
  late Command1 deleteTodo;
  late Command1 completeTodo;

  Future<Result<String?>> _getUserData() async {
    try {
      final result = await _userRepository.getUserData();
      switch (result) {
        case Ok<String?>():
          return Result.ok("");
        case Error<String?>():
          return result;
      }
    } finally {
      notifyListeners();
    }
  }

  late List<TodoResponse> _todoData = [];
  List<TodoResponse> get todoData => _todoData;

  Future<Result<String?>> _getTodoByData((String date, int page) data) async {
    final (date, page) = data;
    try {
      final result = await _todoRepository.getTodosByDate(
        page: page,
        date: date,
      );
      switch (result) {
        case Ok<List<TodoResponse>>():
          _todoData = result.value;
          return Result.ok(null);
        case Error<List<TodoResponse>>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<String?>> _completeTodo((String date, String id) data) async {
    final (date, id) = data;
    try {
      final result = await _todoRepository.completeTodo(todoId: id, date: date);
      switch (result) {
        case Ok<List<TodoResponse>>():
          _todoData = result.value;
          return Result.ok(null);
        case Error<List<TodoResponse>>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<String?>> _deleteTodo((String date, String id) data) async {
    final (date, id) = data;
    try {
      final result = await _todoRepository.deleteTodo(todoId: id, date: date);
      switch (result) {
        case Ok<List<TodoResponse>>():
          _todoData = result.value;
          return Result.ok(null);
        case Error<List<TodoResponse>>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }
}
