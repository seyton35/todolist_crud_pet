import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/todo_repository/todo_repository.dart';

class AppModel with ChangeNotifier {
  final FlutterSecureStorage secureStorage;
  final AuthRepository authRepository;
  final TodoRepository todoRepository;

  AppModel({
    required this.authRepository,
    required this.secureStorage,
    required this.todoRepository,
  });
}
