import 'package:flutter/material.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/models/models.dart';
import 'package:todos_crud_pet/domain/todo_repository/todo_repository.dart';

class AddTodoModel extends ChangeNotifier {
  bool status = false;
  DateTime? deadline;
  final taskTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  String? _errorTask;
  bool _isRequestProgress = false;
  bool get isRequestProgress => _isRequestProgress;
  String? get errorTask => _errorTask;
  final BuildContext _context;
  final TodoRepository _todoRepo;
  final AuthRepository _authRepo;

  AddTodoModel({
    required context,
    required TodoRepository todoRepository,
    required AuthRepository authRepository,
  })  : _context = context,
        _todoRepo = todoRepository,
        _authRepo = authRepository;

  Future<void> onTaskConfirm() async {
    FocusScope.of(_context).unfocus();
    final task = taskTextController.text;
    final description = descriptionTextController.text;
    if (task.isEmpty) {
      _errorTask = 'Task can not be empty';
      notifyListeners();
      return;
    }
    _isRequestProgress = true;
    notifyListeners();
    try {
      if (_authRepo.jwt != null) {
        _todoRepo.addTodo(
            jwt: _authRepo.jwt!,
            newTodo: Todo(
              createdAt: DateTime.now(),
              id: '',
              task: task,
              status: status,
              description: description,
              deadline: deadline,
            ));
      }
      _isRequestProgress = false;
      notifyListeners();
      Navigator.of(_context).maybePop();
    } catch (e) {
      print(e);
      _isRequestProgress = false;
      notifyListeners();
    }
  }

  void onTaskChange() {
    if (_errorTask != null) {
      final isTaskNotEmpty = taskTextController.text.isNotEmpty;
      if (isTaskNotEmpty) {
        _errorTask = null;
        notifyListeners();
      }
    }
  }

  void onstatusTap() {
    status = !status;
    notifyListeners();
  }

  bool onDeadlineChange(DateTime? date) {
    deadline = date;
    notifyListeners();
    return true;
  }

  void onCancelBtnTap() => Navigator.of(_context).pop();
}
