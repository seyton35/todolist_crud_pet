import 'package:flutter/material.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/main_navigation/main_navigation.dart';

class LoginModel extends ChangeNotifier {
  final BuildContext _context;
  String? errorEmail;
  String? errorPassword;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final AuthRepository _authRepo;

  LoginModel(
      {required BuildContext context, required AuthRepository authRepository})
      : _context = context,
        _authRepo = authRepository;

  Future<void> onLoginPress() async {
    final email = emailTextController.text.trim();
    final password = passwordTextController.text.trim();
    if (email == '') {
      errorEmail = 'email can not be empty';
      notifyListeners();
      return;
    }
    if (password == '') {
      errorPassword = 'password can not be empty';
      notifyListeners();
      return;
    }
    try {
      final token = await _authRepo.login(email, password);
      if (token == null) return;
      Navigator.of(_context)
          .pushReplacementNamed(MainNavigationRouteNames.todoList);
    } catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(const SnackBar(
        content: Text("e"),
      ));
      print(e);
    }
  }

  void onEmailChange(text) {
    if (errorEmail == null) return;
    errorEmail = _onEditChange(text, errorEmail);
    notifyListeners();
  }

  void onPasswordChange(text) {
    if (errorPassword == null) return;
    errorPassword = _onEditChange(text, errorPassword);
    notifyListeners();
  }

  _onEditChange(String text, errorMessage) {
    if (errorMessage != null) {
      final isTextNotEmpty = text.isNotEmpty;
      if (isTextNotEmpty) {
        errorMessage = null;
        return errorMessage;
      }
    }
  }
}
