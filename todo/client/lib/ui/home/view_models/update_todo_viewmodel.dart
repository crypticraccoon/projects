import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/domain/models/todo/todo.dart';
import 'package:todo/utils/command.dart';
import 'package:todo/utils/result.dart';
import 'package:flutter/material.dart';

class UpdateTodoViewModel extends ChangeNotifier {
  UpdateTodoViewModel({required TodoRepository todoRepository})
    : _todoRepository = todoRepository {
    updateTodo = Command1<void, (String date, TodoResponse data)>(_updateTodo);
  }

  final TodoRepository _todoRepository;

  late Command1 updateTodo;

  Future<Result<String?>> _updateTodo(
    (String date, TodoResponse updatedData) data,
  ) async {
    final (String date, TodoResponse updatedData) = data;

    try {
      final result = await _todoRepository.updateTodo(
        date: date,
        data: updatedData,
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
