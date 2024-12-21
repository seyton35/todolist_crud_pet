import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todos_crud_pet/features/app/app_model.dart';
import 'package:todos_crud_pet/features/todo_list/models/models.dart';
import 'package:todos_crud_pet/features/todo_list/todo_list_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel(
        context: context,
        todoRepo: context.read<AppModel>().todoRepository,
        authRepo: context.read<AppModel>().authRepository,
      ),
      child: const TodoList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todos'),
        backgroundColor: Colors.amber,
        actions: const [
          _SortDropdown(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<TodoListModel>().onAddTodoBtnTap,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      drawer: const _DrawwerWidget(),
      body: const BodyWidget(),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SortBy>(
      value: context.watch<TodoListModel>().sortMethod,
      onChanged: (value) =>
          context.read<TodoListModel>().onSortMethodChange(value!),
      items: SortBy.values
          .map(
            (sort) => DropdownMenuItem<SortBy>(
              value: sort,
              child: Text(sort.name),
            ),
          )
          .toList(),
    );
  }
}

class _DrawwerWidget extends StatelessWidget {
  const _DrawwerWidget();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          InkWell(
            onTap: () => context
                .read<TodoListModel>()
                .onDrawerTileTap(DrawerTileNames.archive),
            child: const ListTile(
                leading: Icon(Icons.archive_outlined),
                title: Text('archived todos')),
          ),
          InkWell(
            onTap: () => context
                .read<TodoListModel>()
                .onDrawerTileTap(DrawerTileNames.logout),
            child: const ListTile(
                leading: Icon(Icons.logout), title: Text('log out')),
          ),
        ],
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final todoList = context.watch<TodoListModel>().todoCardList;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
          context.read<TodoListModel>().loadNextPage();
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: context.read<TodoListModel>().refresh,
        child: ValueListenableBuilder<List<TodoCard>>(
          valueListenable: todoList,
          builder: (context, value, child) => ListView.builder(
            itemCount: todoList.value.length,
            itemBuilder: (context, index) {
              final todoCard = todoList.value[index];
              return Dismissible(
                key: ValueKey(todoCard.id),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    context.read<TodoListModel>().onDeleteTodo(todoCard.id);
                  } else if (direction == DismissDirection.startToEnd) {
                    context.read<TodoListModel>().onArchiveAddTodo(todoCard.id);
                  }
                },
                background: const ColoredBox(
                  color: Colors.brown,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.archive),
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
        ),
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
        context.watch<TodoListModel>().openedDescriptionAt == todoCard.id;
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
      onLongPress: () =>
          context.read<TodoListModel>().onTodoLongPress(todoCard.id),
      onTap: () => context.read<TodoListModel>().onTodoTileTap(todoCard.id),
      child: Card(
        child: ListTile(
          title: Text(todoCard.title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  if (todoCard.date != null)
                    Text(DateFormat('dd M yyyy').format(todoCard.date!)),
                  Text(DateFormat('dd M yyyy').format(todoCard.createdAt)),
                ],
              ),
              Checkbox(
                value: todoCard.isChecked,
                onChanged: (_) =>
                    context.read<TodoListModel>().onTileCheckboxTap(
                          newStatus: !todoCard.isChecked,
                          todoId: todoCard.id,
                        ),
              ),
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
