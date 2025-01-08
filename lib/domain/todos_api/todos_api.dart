import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todos_crud_pet/domain/models/models.dart';

enum ApiClientExeptionType { network, apiKey, emptyResponse, other }

class TodosApi {
  final Dio _client = Dio();
  final _host = dotenv.env['HOST'] ?? '';
  late final _todosHost = '${_host}todos/';

  TodosApi() {
    _client.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.type == DioExceptionType.connectionTimeout) {
          throw ApiClientExeptionType.network;
        }
        if (error.response == null) throw error;
        if (error.response!.statusCode == null) throw error;
        switch (error.response!.statusCode) {
          case 401:
            throw ApiClientExeptionType.emptyResponse;
          case 409:
            throw ApiClientExeptionType.apiKey;
          case 400:
          case 500:
          default:
            throw ApiClientExeptionType.other;
        }
      },
    ));
  }

  Future<dynamic> getTodos(
      {required String jwt, required int page, required int limit}) async {
    try {
      final res = await _client.get(_todosHost,
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
          queryParameters: {
            'limit': limit,
            'page': page,
          });
      final List rawTodosList = res.data['todo_list'];
      final int totalPages = res.data['total_pages'];
      final todoList = <Todo>[];
      rawTodosList
          .map((dynamic element) => {todoList.add(Todo.fromJson(element))})
          .toList();
      return {'todo_list': todoList, 'total_pages': totalPages};
    } on DioException catch (e) {
      print(' ssss');
    } catch (e) {
      print(e);
      print(' ssss');
      return [];
    }
  }

  Future<Todo?> checkTodo({
    required String jwt,
    required String todoId,
    required bool status,
  }) async {
    try {
      final res = await _client.patch(_todosHost,
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
          queryParameters: {
            'id_todo': todoId,
            'status': '',
          });
      final rawTodo = res.data['data'];
      final todo = Todo.fromJson(rawTodo);
      return todo;
    } catch (e) {
      print(e);
    }
  }

  Future<Todo?> patchTodo({required String jwt, required Todo todo}) async {
    try {
      final res = await _client.patch(_todosHost,
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
          queryParameters: {
            'id_todo': todo.id,
            'task': todo.task,
            'status': todo.status,
            'deadline': todo.deadline,
            'description': todo.description,
          });
      final updatedTodo = Todo.fromJson(res.data['data']);
      return updatedTodo;
    } catch (e) {
      print('\n');
      print('n');
      print(e);
      print('\n');
      return null;
    }
  }

  Future<void> deleteOne({required String jwt, required String todoId}) async {
    try {
      final res = await _client.delete(
        _todosHost,
        options: Options(
          headers: {'Authorization': 'Bearer $jwt'},
        ),
        queryParameters: {
          'id_todo': todoId,
        },
      );
      print(res.data['message']);
    } catch (e) {
      print(e);
    }
  }

  Future<Todo?> postTodo({
    required String jwt,
    required Todo todo,
  }) async {
    final todoId = todo.id;
    final task = todo.task;
    final status = todo.status;
    final deadline = todo.deadline;
    final description = todo.description;
    final createdAt = todo.createdAt;
    try {
      final res = await _client.post(
        '${_todosHost}create',
        options: Options(
          headers: {'Authorization': 'Bearer $jwt'},
        ),
        queryParameters: {
          'id_todo': todoId,
          'task': task,
          'status': status,
          'deadline': deadline,
          'description': description,
          'created_at': createdAt
        },
      );
      final todo = Todo.fromJson(res.data['data']);
      return todo;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
