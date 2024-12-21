import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/sharedPreferencesApi/shared_preferences_api.dart';
import 'package:todos_crud_pet/domain/todo_repository/todo_repository.dart';
import 'package:todos_crud_pet/features/app/app.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  const secureStorage = FlutterSecureStorage();
  final shaPref = await SharedPreferences.getInstance();
  final shaPrefApi = SharedPreferencesApi(shaPref: shaPref);
  final authRepo = AuthRepository(
    secureStorage: secureStorage,
    sharedPreferencesApi: shaPrefApi,
  );
  await authRepo.getJwt();
  final todoRepo = TodoRepository(
    sharedPreferencesApi: shaPrefApi,
  );
  final isAuthorized = authRepo.jwt != null;
  runApp(MainApp.create(
    todoRepository: todoRepo,
    secureStorage: secureStorage,
    isAuthorized: isAuthorized,
    authReoisitory: authRepo,
  ));
}
