// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_crud_pet/features/add_todo/add_todo_model.dart';
import 'package:todos_crud_pet/features/app/app_model.dart';

class AddTodo extends StatelessWidget {
  const AddTodo({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => AddTodoModel(
        context: context,
        todoRepository: context.read<AppModel>().todoRepository,
        authRepository: context.read<AppModel>().authRepository,
      ),
      child: const AddTodo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New todo'),
      ),
      body: const FormWidget(),
      backgroundColor: Colors.grey[300],
    );
  }
}

class FormWidget extends StatelessWidget {
  const FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        _TaskFieldItem(),
        _StatusSwitchItem(),
        _DeadlinePickItem(),
        _DescriptionFieldItem(),
        _ButtonsBarItem()
      ],
    );
  }
}

class _TaskFieldItem extends StatelessWidget {
  const _TaskFieldItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
        ),
        child: TextField(
          onChanged: (_) => {context.read<AddTodoModel>().onTaskChange()},
          controller: context.read<AddTodoModel>().taskTextController,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'Task',
            labelText: 'Task',
            errorText: context.watch<AddTodoModel>().errorTask,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusSwitchItem extends StatelessWidget {
  const _StatusSwitchItem({super.key});

  @override
  Widget build(BuildContext context) {
    final onstatusTap = context.read<AddTodoModel>().onstatusTap;
    final status = context.watch<AddTodoModel>().status;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1.3, color: Colors.grey),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('completed'),
              Switch(onChanged: (value) => {onstatusTap()}, value: status),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeadlinePickItem extends StatelessWidget {
  const _DeadlinePickItem({super.key});

  @override
  Widget build(BuildContext context) {
    final onDeadlineChange = context.read<AddTodoModel>().onDeadlineChange;
    final now = DateTime.now();
    final deadline = context.watch<AddTodoModel>().deadline;
    final date = deadline == null
        ? 'select deadline'
        : deadline.toString().substring(0, 10);
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(2000, 1, 1, 1),
          lastDate: DateTime(2030, 1, 1, 1),
          initialDate: DateTime(now.year, now.month, now.day + 1),
        );
        if (date == null) return;
        onDeadlineChange(date);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.3, color: Colors.grey),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date),
                const Icon(Icons.edit_calendar_outlined),
                IconButton(
                  onPressed: () => onDeadlineChange(null),
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: 0),
                  padding: const EdgeInsets.all(15),
                  icon: const Icon(Icons.cancel_outlined),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptionFieldItem extends StatelessWidget {
  const _DescriptionFieldItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            TextField(
              controller:
                  context.read<AddTodoModel>().descriptionTextController,
              maxLength: 500,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Description',
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonsBarItem extends StatelessWidget {
  const _ButtonsBarItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: context.watch<AddTodoModel>().isRequestProgress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: context.read<AddTodoModel>().onCancelBtnTap,
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: context.read<AddTodoModel>().onTaskConfirm,
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
