import 'package:intl/intl.dart';

class Todo {
  String id;
  String task;
  bool status;
  DateTime? deadline;
  String? description;
  DateTime? createdAt;

  Todo({
    required this.id,
    required this.task,
    required this.status,
    this.deadline,
    this.description,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    final status = json['status'] == 1 || json['status'] == true ? true : false;
    return Todo(
      id: json['id_todo'] as String,
      task: json['task'] as String,
      status: status,
      deadline: json['deadline'] != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(json['deadline'])
          : null,
      description: json['description'] as String?,
      // createdAt: json['created_at'] as DateTime,
      createdAt: json['created_at'] != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_todo'] = id;
    data['task'] = task;
    data['status'] = status;
    data['deadline'] = deadline?.toIso8601String();
    data['description'] = description;
    data['created_at'] = createdAt?.toIso8601String();
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
