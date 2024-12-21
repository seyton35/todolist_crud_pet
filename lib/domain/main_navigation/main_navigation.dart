import 'package:flutter/material.dart';
import 'package:todos_crud_pet/domain/models/models.dart';
import 'package:todos_crud_pet/features/add_todo/add_todo.dart';
import 'package:todos_crud_pet/features/archived_list/archived_list.dart';
import 'package:todos_crud_pet/features/edit_todo/edit_todo.dart';
import 'package:todos_crud_pet/features/login/login.dart';
import 'package:todos_crud_pet/features/todo_list/todo_list.dart';

abstract class MainNavigationRouteNames {
  static const todoList = '/';
  static const addTodo = '/addTodo';
  static const login = '/login';
  static const editTodo = '/editTodo';
  static const archiveList = '/archiveList';
}

class MainNavigation {
  String initialRoute({required bool isAuthorized}) => isAuthorized
      ? MainNavigationRouteNames.todoList
      : MainNavigationRouteNames.login;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.todoList: (context) => TodoList.create(),
    MainNavigationRouteNames.addTodo: (context) => AddTodo.create(),
    // MainNavigationRouteNames.editTodo: (context) => EditTodo.create(),
    MainNavigationRouteNames.login: (context) => Login.create(),
    MainNavigationRouteNames.archiveList: (context) => ArchivedList.create(),
  };

  Route<Object> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.editTodo:
        final todoTodEdit = settings.arguments as Todo;

        return MaterialPageRoute(
          builder: (context) => EditTodo.create(
            todoToEdit: todoTodEdit,
          ),
        );
      // case MainNavigationRouteNames.chooseLocation:
      //   return MaterialPageRoute(
      //     builder: (context) => ChooseLocation.create(
      //       isRootRoute: settings.arguments as bool? ?? true,
      //     ),
      //   );
      default:
        const widget = Text('Navigation Error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
