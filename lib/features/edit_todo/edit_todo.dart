import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_crud_pet/domain/models/models.dart';
import 'package:todos_crud_pet/features/app/app_model.dart';
import 'package:todos_crud_pet/features/edit_todo/edit_todo_model.dart';

class EditTodo extends StatelessWidget {
  const EditTodo({super.key});

  static Widget create({
    required Todo todoToEdit,
  }) {
    return ChangeNotifierProvider(
      create: (context) => EditTodoModel(
        context: context,
        todoRepository: context.read<AppModel>().todoRepository,
        authRepository: context.read<AppModel>().authRepository,
        todoToEdit: todoToEdit,
      ),
      child: const EditTodo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit task'),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: context.read<EditTodoModel>().formKey,
          child: const Column(
            children: [
              _TaskTextField(),
              _StatusCheckbox(),
              _DeadlineForm(),
              _DescriptionTextField(),
              _ConfirmBtn()
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTextField extends StatelessWidget {
  const _TaskTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.read<EditTodoModel>().taskController,
      decoration: InputDecoration(
        labelText: 'Task',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please, set the Task';
        }
        return null;
      },
    );
  }
}

class _StatusCheckbox extends StatelessWidget {
  const _StatusCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('task completed?'),
      value: context.watch<EditTodoModel>().status,
      onChanged: (value) =>
          context.read<EditTodoModel>().onCheckboxTap(value ?? false),
    );
  }
}

class _DeadlineForm extends StatelessWidget {
  const _DeadlineForm({super.key});

  @override
  Widget build(BuildContext context) {
    final deadline = context.watch<EditTodoModel>().deadline;
    final dateString = deadline != null
        ? 'Deadline: $deadline'
        : 'The deadline has not yet been set';
    return Column(
      children: [
        Text(dateString),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                context.read<EditTodoModel>().setDeadline(picked);
              },
              child: const Text('Set deadline'),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                context.read<EditTodoModel>().setDeadline(null);
              },
              child: const Text('Remove date'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionTextField extends StatelessWidget {
  const _DescriptionTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.read<EditTodoModel>().descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class _ConfirmBtn extends StatelessWidget {
  const _ConfirmBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: context.read<EditTodoModel>().onConfirmTap,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
