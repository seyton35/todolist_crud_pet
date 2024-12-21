import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todos_crud_pet/features/app/app_model.dart';
import 'package:todos_crud_pet/features/archived_list/archived_list_model.dart';
import 'package:todos_crud_pet/features/todo_list/models/models.dart';

class ArchivedList extends StatelessWidget {
  const ArchivedList({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => ArchivedListModel(
        context: context,
        todoRepository: context.read<AppModel>().todoRepository,
        authRepository: context.read<AppModel>().authRepository,
      ),
      child: const ArchivedList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('arhived'),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final archivedTodoCardList =
        context.watch<ArchivedListModel>().archivedTodoCardList;
    return ValueListenableBuilder<List<TodoCard>>(
      valueListenable: archivedTodoCardList,
      builder: (context, value, child) => ListView.builder(
        itemCount: archivedTodoCardList.value.length,
        itemBuilder: (context, index) {
          final todoCard = archivedTodoCardList.value[index];
          return Dismissible(
            key: ValueKey(todoCard.id),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                context.read<ArchivedListModel>().onDeleteTodo(todoCard.id);
              } else if (direction == DismissDirection.startToEnd) {
                context
                    .read<ArchivedListModel>()
                    .onBackToRegularTodoList(todoCard.id);
              }
            },
            background: const ColoredBox(
              color: Colors.blue,
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.backup),
                ],
              ),
            ),
            secondaryBackground: const ColoredBox(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete_forever),
                  SizedBox(width: 20),
                ],
              ),
            ),
            child: CardWidget(todoCard: todoCard),
          );
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final TodoCard todoCard;

  const CardWidget({super.key, required this.todoCard});

  @override
  Widget build(BuildContext context) {
    final showDescription =
        context.watch<ArchivedListModel>().openedDescriptionAt == todoCard.id;
    String? description;
    if (todoCard.description != null) {
      if (showDescription) {
        description = todoCard.description;
      } else {
        if (todoCard.description!.length > 80) {
          description = '${todoCard.description!.substring(0, 80)}...';
        } else {
          description = todoCard.description;
        }
      }
    }
    return InkWell(
      onTap: () => context.read<ArchivedListModel>().onTodoTileTap(todoCard.id),
      child: Card(
        child: ListTile(
          title: Text(todoCard.title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (todoCard.date != null)
                Text(DateFormat('dd M yyyy').format(todoCard.date!)),
              Icon(
                todoCard.isChecked
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
              )
            ],
          ),
          subtitle: description != null
              ? Text(
                  description,
                  maxLines: showDescription ? null : 2,
                )
              : null,
        ),
      ),
    );
  }
}
