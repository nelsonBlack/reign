import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import '../controllers/todo_controller.dart';
import '../widgets/todo_list_item.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Todos')),
      body: ControllerConsumer<TodoController>(
        builder: (context, controller) => ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (ctx, i) => TodoListItem(index: i),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(controller: textController),
          actions: [
            TextButton(
              onPressed: () async {
                if (textController.text.isNotEmpty) {
                  final todoCtrl =
                      await ControllerProvider.of<TodoController>(context);
                  todoCtrl.addTodo(textController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );
  }
}
