import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todos_crud_pet/domain/models/models.dart';
import 'package:todos_crud_pet/domain/sharedPreferencesApi/shared_preferences_api.dart';
import 'package:todos_crud_pet/domain/todos_api/todos_api.dart';
import 'package:uuid/uuid.dart';

abstract class SharedPreferencesKeyNames {
  static const archivedTodoList = 'archived_todo_list';
  static const regularTodoList = 'regular_todo_list';
}

class TodoRepository with ChangeNotifier {
  late final TodosApi _todosApi;
  final SharedPreferencesApi _shaPrefApi;
  final _uuid = const Uuid();
  List<Todo> _todoList = [];
  List<Todo> get todoList => _todoList;
  List<Todo> _archivedTodoList = [];
  List<Todo> get archivedTodoList => _archivedTodoList;

  TodoRepository({
    required SharedPreferencesApi sharedPreferencesApi,
  }) : _shaPrefApi = sharedPreferencesApi {
    _todosApi = TodosApi();
  }

  Future<int?> getTodos(
      {required String jwt, required int page, required int limit}) async {
    try {
      final res = await _todosApi.getTodos(jwt: jwt, limit: limit, page: page);
      final todoListRes = res['todo_list'];
      final totalPages = res['total_pages'] as int;
      if (page == 1) {
        _todoList = todoListRes;
      } else {
        _todoList.addAll(todoListRes);
      }
      saveTodoListToLocalStorage();
      notifyListeners();
      return totalPages;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void getLocalStoredArchivedTodos() {
    final archString =
        _shaPrefApi.getValue(SharedPreferencesKeyNames.archivedTodoList);
    if (archString == null) return;
    final archList = json.decode(archString) as List<dynamic>;
    _archivedTodoList = archList.map((el) => Todo.fromJson(el)).toList();
    notifyListeners();
  }

  void getLocalStoredTodoList() async {
    final todoListString =
        _shaPrefApi.getValue(SharedPreferencesKeyNames.regularTodoList);
    if (todoListString == null) return;
    final todoListRaw = json.decode(todoListString) as List<dynamic>;
    _todoList = todoListRaw.map((todoRaw) => Todo.fromJson(todoRaw)).toList();
    notifyListeners();
  }

  deleteOneTodo({required String jwt, required String todoId}) {
    _todoList.removeWhere((todo) => todo.id == todoId);
    saveTodoListToLocalStorage();
    notifyListeners();
    _todosApi.deleteOne(jwt: jwt, todoId: todoId);
  }

  deleteOneArchivedTodo({required String todoId}) {
    _archivedTodoList.removeWhere((todo) => todo.id == todoId);
    saveArchivedTodoListToLocalStorage();
    notifyListeners();
  }

  void addOneToArchive({required String jwt, required String todoId}) {
    final todo = _todoList.firstWhere((todo) => todo.id == todoId);
    _archivedTodoList.add(todo);
    saveArchivedTodoListToLocalStorage();
    _todoList.remove(todo);
    saveTodoListToLocalStorage();
    _todosApi.deleteOne(jwt: jwt, todoId: todoId);
    notifyListeners();
  }

  void backOneFromArchive({required String jwt, required String todoId}) {
    final todo = _archivedTodoList.firstWhere((todo) => todo.id == todoId);
    _todoList.add(todo);
    saveTodoListToLocalStorage();
    _archivedTodoList.remove(todo);
    saveArchivedTodoListToLocalStorage();
    notifyListeners();
    _todosApi.postTodo(jwt: jwt, todo: todo);
  }

  void addTodo({required String jwt, required Todo newTodo}) {
    newTodo.id = _uuid.v4();
    _todoList.add(newTodo);
    saveTodoListToLocalStorage();
    _postTodo(jwt: jwt, todo: newTodo);
    notifyListeners();
  }

  void saveTodoListToLocalStorage() {
    final jsonList = _todoList.map((todo) => todo.toJson()).toList();
    _shaPrefApi.setValut(
        SharedPreferencesKeyNames.regularTodoList, json.encode(jsonList));
  }

  void saveArchivedTodoListToLocalStorage() {
    final jsonList = _archivedTodoList.map((todo) => todo.toJson()).toList();
    _shaPrefApi.setValut(
        SharedPreferencesKeyNames.archivedTodoList, json.encode(jsonList));
  }

  Future<void> _postTodo({required String jwt, required Todo todo}) async {
    try {
      _todosApi.postTodo(jwt: jwt, todo: todo);
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkTodo({
    required String jwt,
    required bool newStatus,
    required String todoId,
  }) async {
    final index = todoList.indexWhere((todo) => todo.id == todoId);
    final todo =
        await _todosApi.checkTodo(jwt: jwt, todoId: todoId, status: newStatus);
    if (todo != null) todoList[index] = todo;
    saveTodoListToLocalStorage();
    notifyListeners();
  }

  Future<void> updateTodo(
      {required String jwt, required Todo updatedTodo}) async {
    final index = todoList.indexWhere((todo) => todo.id == updatedTodo.id);
    _todoList[index] = updatedTodo;
    notifyListeners();
    saveTodoListToLocalStorage();
    _todosApi.patchTodo(jwt: jwt, todo: updatedTodo);
  }
}
