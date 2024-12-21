import 'package:todos_crud_pet/domain/models/models.dart';

class TodoCard {
  final String id;
  final String title;
  bool isChecked;
  DateTime? date;
  String? description;
  DateTime createdAt;

  TodoCard({
    required this.id,
    required this.title,
    this.isChecked = false,
    required this.date,
    required this.description,
    required this.createdAt,
  });

  factory TodoCard.parse(Todo todo) => TodoCard(
        id: todo.id,
        title: todo.task,
        isChecked: todo.status,
        date: todo.deadline,
        description: todo.description,
        createdAt: todo.createdAt!,
      );
}
