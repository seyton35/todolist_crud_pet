import 'package:flutter/material.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/models/models.dart';
import 'package:todos_crud_pet/domain/todo_repository/todo_repository.dart';

class EditTodoModel extends ChangeNotifier {
  final BuildContext _context;
  final taskController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final TodoRepository _todoRepo;
  final AuthRepository _authRepo;
  final Todo todoToEdit;
  bool status;
  DateTime? deadline;
  String? get jwt => _authRepo.jwt;

  EditTodoModel({
    required BuildContext context,
    required this.todoToEdit,
    required TodoRepository todoRepository,
    required AuthRepository authRepository,
  })  : _context = context,
        status = todoToEdit.status,
        _todoRepo = todoRepository,
        _authRepo = authRepository {
    taskController.text = todoToEdit.task;
    deadline = todoToEdit.deadline;
    descriptionController.text = todoToEdit.description ?? '';
  }

  Future<void> onConfirmTap() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    final task = taskController.text;
    final description = descriptionController.text;
    todoToEdit.task = task;
    todoToEdit.status = status;
    todoToEdit.deadline = deadline;
    todoToEdit.description = description;
    if (jwt == null) return;
    _todoRepo.updateTodo(jwt: jwt!, updatedTodo: todoToEdit);
    Navigator.of(_context).pop();
  }

  void onCheckboxTap(bool value) {
    status = value;
    notifyListeners();
  }

  void setDeadline(DateTime? date) {
    deadline = date;
    notifyListeners();
  }
}
