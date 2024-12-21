import 'package:flutter/material.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/main_navigation/main_navigation.dart';
import 'package:todos_crud_pet/domain/models/models.dart';
import 'package:todos_crud_pet/domain/todo_repository/todo_repository.dart';
import 'package:todos_crud_pet/features/todo_list/models/models.dart';

abstract class DrawerTileNames {
  static const String archive = 'archive';
  static const String logout = 'logOut';
}

enum SortBy {
  byTitleASC,
  byTitleDESC,
  createdAtASC,
  createdAtDESC,
  completed,
  uncompleted,
}

class TodoListModel extends ChangeNotifier {
  final BuildContext _context;
  final TodoRepository _todoRepo;
  final AuthRepository _authRepo;
  final ValueNotifier<List<TodoCard>> todoCardList = ValueNotifier([]);
  List<Todo> get todoList => _todoRepo.todoList;
  SortBy sortMethod = SortBy.byTitleASC;
  String? openedDescriptionAt;
  String? get jwt => _authRepo.jwt;
  int _currentPage = 0;
  final int limit = 10;
  bool _isLoadingProgress = false;
  int _totalPages = 1;

  TodoListModel(
      {required context,
      required TodoRepository todoRepo,
      required AuthRepository authRepo})
      : _todoRepo = todoRepo,
        _authRepo = authRepo,
        _context = context {
    _todoRepo.addListener(onTodoListChange);
    _todoRepo.getLocalStoredTodoList();
    loadNextPage();
  }

  onTodoListChange() {
    todoCardList.value =
        todoList.map((element) => TodoCard.parse(element)).toList();
    _todoListSort();
    notifyListeners();
  }

  onSortMethodChange(SortBy sort) {
    if (sortMethod == sort) return;
    sortMethod = sort;
    _todoListSort();
    notifyListeners();
  }

  _todoListSort() {
    late List<TodoCard> sortedList;
    switch (sortMethod) {
      case SortBy.createdAtASC:
        sortedList = todoCardList.value.toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case SortBy.createdAtDESC:
        sortedList = todoCardList.value.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortBy.completed:
        sortedList = todoCardList.value.toList()
          ..sort((a, b) => a.isChecked ? -1 : 1);
      case SortBy.uncompleted:
        sortedList = todoCardList.value.toList()
          ..sort((a, b) => a.isChecked ? 1 : -1);
      case SortBy.byTitleASC:
        sortedList = todoCardList.value.toList()
          ..sort((a, b) => a.title.compareTo(b.title));
      case SortBy.byTitleDESC:
        sortedList = todoCardList.value.toList()
          ..sort((a, b) => b.title.compareTo(a.title));
      default:
        sortedList = todoCardList.value;
    }
    todoCardList.value = sortedList;
  }

  Future<void> loadNextPage() async {
    final nextPage = _currentPage + 1;
    if (jwt == null || _isLoadingProgress || nextPage > _totalPages) return;
    try {
      _isLoadingProgress = true;
      final totalPages =
          await _todoRepo.getTodos(jwt: jwt!, limit: limit, page: nextPage);
      if (totalPages != null) _totalPages = totalPages;
      _currentPage = nextPage;
      _isLoadingProgress = false;
    } catch (e) {
      print(e);
      _isLoadingProgress = false;
    }
  }

  Future<void> refresh() async {
    _todoRepo.getLocalStoredTodoList();
    _currentPage = 0;
    loadNextPage();
  }

  void onTodoTileTap(String todoId) {
    if (todoId == openedDescriptionAt) {
      openedDescriptionAt = null;
    } else {
      openedDescriptionAt = todoId;
    }
    notifyListeners();
  }

  void refreshTodoCardList(List<Todo> list) {
    todoCardList.value =
        list.map((element) => TodoCard.parse(element)).toList();
    _todoListSort();
    notifyListeners();
    notifyListeners();
  }

  void addTodo(Todo todo) {
    if (jwt != null) _todoRepo.addTodo(jwt: jwt!, newTodo: todo);
  }

  void onDeleteTodo(String todoId) {
    if (jwt != null) _todoRepo.deleteOneTodo(jwt: jwt!, todoId: todoId);
  }

  void onArchiveAddTodo(String todoId) {
    if (jwt != null) _todoRepo.addOneToArchive(jwt: jwt!, todoId: todoId);
  }

  void onTileCheckboxTap({
    required bool newStatus,
    required String todoId,
  }) async {
    try {
      if (jwt != null) {
        _todoRepo.checkTodo(jwt: jwt!, newStatus: newStatus, todoId: todoId);
      }
    } catch (e) {
      print(e);
    }
  }

  void onAddTodoBtnTap() =>
      Navigator.of(_context).pushNamed(MainNavigationRouteNames.addTodo);

  void onTodoLongPress(String todoId) {
    final todo = _todoRepo.todoList.firstWhere((todo) => todo.id == todoId);
    Navigator.of(_context)
        .pushNamed(MainNavigationRouteNames.editTodo, arguments: todo);
  }

  void onDrawerTileTap(String route) {
    switch (route) {
      case DrawerTileNames.archive:
        Navigator.of(_context).pushNamed(MainNavigationRouteNames.archiveList);
        break;
      case DrawerTileNames.logout:
        _authRepo.logout();
        Navigator.of(_context).pushNamed(MainNavigationRouteNames.login);
        break;
      default:
    }
  }
}
