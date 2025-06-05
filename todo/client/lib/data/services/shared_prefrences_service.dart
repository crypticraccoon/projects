import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/domain/models/todo/todo.dart';
import 'package:todo/domain/models/userdata/userdata.dart';

import '../../utils/result.dart';

const _accessTokenKey = 'accessToken';
const _refreshTokenKey = 'refreshTokenKey';
const _id = "id";
const _username = "username";
const _email = "email";

class SharedPreferencesService {
  Future<Result<String>> updateUsername({required String value}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("username", value);
      return Result.ok(value);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> updateEmail({required String value}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("email", value);
      return Result.ok(value);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUserData({
    required String id,
    required String email,
    required String username,
  }) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(_id, id);
      await sharedPreferences.setString(_email, email);
      await sharedPreferences.setString(_username, username);

      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchUserId() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_id));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchUserEmail() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_email));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchUserUsername() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_username));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<UserData?>> fetchUserData() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final username = sharedPreferences.getString(_username) ?? "";
      final email = sharedPreferences.getString(_email) ?? "";
      final id = sharedPreferences.getString(_id) ?? "";

      final userData = UserData(id: id, username: username, email: email);
      return Result.ok(userData);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchAccessToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_accessTokenKey));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchRefreshToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_refreshTokenKey));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Map<String, String?>>> fetchTokens() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok({
        "refreshToken": sharedPreferences.getString(_refreshTokenKey),
        "accessToken": sharedPreferences.getString(_accessTokenKey),
      });
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> saveTokens(
    String? accessToken,
    String? refreshToken,
  ) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (accessToken == null || refreshToken == null) {
        await sharedPreferences.clear();
      } else {
        await sharedPreferences.setString(_accessTokenKey, accessToken);
        await sharedPreferences.setString(_refreshTokenKey, refreshToken);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  //Add
  Future<Result<void>> addTodos(List<TodoResponse> data, String date) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? cachedData = sharedPreferences.getString(date);

    if (cachedData != null) {
      List<dynamic> dData = jsonDecode(cachedData);
      List<TodoResponse> decodedData =
          dData.map((dynamic data) => TodoResponse.fromJson(data)).toList();

      decodedData.removeWhere((item) => data.contains(item));

      String encodedData =
          jsonEncode(
            [
              ...data,
              ...decodedData,
            ].map((TodoResponse i) => i.toJson()).toList(),
          ).toString();

      sharedPreferences.setString(date, encodedData);
    } else {
      String encodedData =
          jsonEncode(
            data.map((TodoResponse i) => i.toJson()).toList(),
          ).toString();

      sharedPreferences.setString(date, encodedData);
    }

    return Result.ok(null);
  }

  //Get
  Future<List<TodoResponse>?> getTodos({required String date}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? cachedData = sharedPreferences.getString(date);

    if (cachedData != null) {
      List<dynamic> dData = jsonDecode(cachedData);
      List<TodoResponse> decodedData =
          dData.map((dynamic data) => TodoResponse.fromJson(data)).toList();
      return Future.value(decodedData);
    }
    return Future.value([]);
  }

  //Update
  Future<Result<List<TodoResponse>>> updateTodo({
    required String date,
    required TodoResponse updatedData,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? cachedData = sharedPreferences.getString(date);
    if (cachedData == null) {
      return Result.error(Exception("Missing todo."));
    }

    List<dynamic> dData = jsonDecode(cachedData);
    List<TodoResponse> decodedData =
        dData.map((dynamic data) => TodoResponse.fromJson(data)).toList();

    decodedData.removeWhere((e) => e.id == updatedData.id);

    final deadline = updatedData.deadline.toString().split(" ")[0];
    if (deadline != date) {
      String? cachedData = sharedPreferences.getString(deadline);
      if (cachedData == null) {
        String encodedData = jsonEncode([updatedData.toJson()]).toString();
        sharedPreferences.setString(date, encodedData);
      }
      return Result.ok(decodedData);
    }
    String encodedData =
        jsonEncode(
          [
            ...decodedData,
            updatedData,
          ].map((TodoResponse i) => i.toJson()).toList(),
        ).toString();

    sharedPreferences.setString(date, encodedData);
    return Result.ok([...decodedData, updatedData]);
  }

  Future<Result<List<TodoResponse>>> completeTodo({
    required String date,
    required String id,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? cachedData = sharedPreferences.getString(date);
    if (cachedData == null) {
      return Result.error(Exception("Missing todo."));
    }

    List<dynamic> dData = jsonDecode(cachedData);
    List<TodoResponse> decodedData =
        dData.map((dynamic data) => TodoResponse.fromJson(data)).toList();

    TodoResponse targetData = decodedData.firstWhere((data) => data.id == id);
    TodoResponse completedData = TodoResponse(
      isCompleted: true,
      id: targetData.id,
      userId: targetData.userId,
      title: targetData.title,
      body: targetData.body,
      deadline: targetData.deadline,
      createdAt: targetData.createdAt,
      completedAt: DateTime.now(),
    );
    decodedData.removeWhere((e) => e.id == id);

    String encodedData =
        jsonEncode(
          [
            ...decodedData,
            completedData,
          ].map((TodoResponse i) => i.toJson()).toList(),
        ).toString();

    sharedPreferences.setString(date, encodedData);
    return Result.ok([...decodedData, completedData]);
  }

  //Delete
  Future<Result<List<TodoResponse>>> deleteTodos({
    required String date,
    required String id,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? cachedData = sharedPreferences.getString(date);

    if (cachedData == null) {
      return Result.error(Exception("Missing todo."));
    }
    List<dynamic> dData = jsonDecode(cachedData);
    List<TodoResponse> decodedData =
        dData.map((dynamic data) => TodoResponse.fromJson(data)).toList();

    decodedData.removeWhere((e) => e.id == id);

    return Result.ok(decodedData);
  }
}
