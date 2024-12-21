import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:todos_crud_pet/domain/auth_repository/auth_repository.dart';
import 'package:todos_crud_pet/domain/main_navigation/main_navigation.dart';
import 'package:todos_crud_pet/domain/todo_repository/todo_repository.dart';
import 'package:todos_crud_pet/features/app/app_model.dart';

class MainApp extends StatelessWidget {
  final bool isAuthorized;
  MainApp({super.key, required this.isAuthorized});

  static Widget create({
    required TodoRepository todoRepository,
    required AuthRepository authReoisitory,
    required FlutterSecureStorage secureStorage,
    required bool isAuthorized,
  }) =>
      ChangeNotifierProvider(
        lazy: false,
        create: (_) => AppModel(
          secureStorage: secureStorage,
          authRepository: authReoisitory,
          todoRepository: todoRepository,
        ),
        builder: (context, child) => MainApp(isAuthorized: isAuthorized),
      );

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return MaterialApp(
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(isAuthorized: isAuthorized),
      onGenerateRoute: mainNavigation.onGeneratedRoute,
    );
  }
}
