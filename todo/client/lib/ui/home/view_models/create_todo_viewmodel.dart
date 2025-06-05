import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class CreateTodoViewModel extends ChangeNotifier {
  CreateTodoViewModel({required TodoRepository todoRepository})
    : _todoRepository = todoRepository {
    createTodo = Command1<void, (String title, String body, String deadline)>(
      _createTodo,
    );
  }

  final TodoRepository _todoRepository;

  late Command1 createTodo;

  Future<Result<String?>> _createTodo(
    (String title, String body, String deadline) credentials,
  ) async {
    final (String title, String body, String deadline) = credentials;

    try {
      final result = await _todoRepository.createTodo(
        body: body,
        title: title,
        deadline: deadline,
      );
      switch (result) {
        case Ok<String?>():
          return Result.ok(null);
        case Error<String?>():
          return result;
      }
    } finally {
      notifyListeners();
    }
  }
}
