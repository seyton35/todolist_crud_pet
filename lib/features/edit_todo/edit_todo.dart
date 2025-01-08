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
      backgroundColor: Colors.grey[300],
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<EditTodoModel>().formKey,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          _TaskTextField(),
          SizedBox(height: 10),
          _StatusCheckbox(),
          SizedBox(height: 10),
          _DeadlineForm(),
          SizedBox(height: 10),
          _DescriptionTextField(),
          SizedBox(height: 10),
          _ConfirmBtn()
        ],
      ),
    );
  }
}

class _TaskTextField extends StatelessWidget {
  const _TaskTextField();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextFormField(
        controller: context.read<EditTodoModel>().taskController,
        maxLength: 100,
        decoration: InputDecoration(
          labelText: 'Task',
          hintText: 'Task',
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
      ),
    );
  }
}

class _StatusCheckbox extends StatelessWidget {
  const _StatusCheckbox();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: CheckboxListTile(
        title: const Text('task completed?'),
        value: context.watch<EditTodoModel>().status,
        onChanged: (value) =>
            context.read<EditTodoModel>().onCheckboxTap(value ?? false),
      ),
    );
  }
}

class _DeadlineForm extends StatelessWidget {
  const _DeadlineForm();

  @override
  Widget build(BuildContext context) {
    final deadline = context.watch<EditTodoModel>().deadline;
    final dateString =
        deadline != null ? 'Deadline: $deadline' : 'Set Deadline';
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        context.read<EditTodoModel>().setDeadline(picked);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.grey, width: 1.5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateString),
              IconButton(
                onPressed: () =>
                    context.read<EditTodoModel>().setDeadline(null),
                visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                padding: const EdgeInsets.all(15),
                icon: const Icon(Icons.cancel_outlined),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionTextField extends StatelessWidget {
  const _DescriptionTextField();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      child: TextFormField(
        maxLength: 500,
        maxLines: 5,
        controller: context.read<EditTodoModel>().descriptionController,
        decoration: InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class _ConfirmBtn extends StatelessWidget {
  const _ConfirmBtn();

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
