import 'package:flutter/material.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/models/models.dart';
import 'package:todos_crud_pet/domain/todo_repository/todo_repository.dart';
import 'package:todos_crud_pet/features/todo_list/models/models.dart';

class ArchivedListModel extends ChangeNotifier {
  final TodoRepository _todoRepo;
  final AuthRepository _authRepo;
  String? get jwt => _authRepo.jwt;
  List<Todo> get archivedList => _todoRepo.archivedTodoList;
  final ValueNotifier<List<TodoCard>> archivedTodoCardList = ValueNotifier([]);
  String? openedDescriptionAt;

  ArchivedListModel({
    required TodoRepository todoRepository,
    required AuthRepository authRepository,
    required BuildContext context,
  })  : _todoRepo = todoRepository,
        _authRepo = authRepository {
    Future.delayed(
      const Duration(seconds: 0),
      () => _todoRepo.getLocalStoredArchivedTodos(),
    );
    _todoRepo.addListener(_onArchivedTodoListChange);
  }

  void onBackToRegularTodoList(String todoId) {
    if (jwt != null) _todoRepo.backOneFromArchive(jwt: jwt!, todoId: todoId);
  }

  void onDeleteTodo(String todoId) {
    _todoRepo.deleteOneArchivedTodo(todoId: todoId);
  }

  void _onArchivedTodoListChange() {
    archivedTodoCardList.value =
        archivedList.map((todo) => TodoCard.parse(todo)).toList();
  }

  void onTodoTileTap(String id) {
    openedDescriptionAt == id
        ? openedDescriptionAt = null
        : openedDescriptionAt = id;
    notifyListeners();
  }
}
