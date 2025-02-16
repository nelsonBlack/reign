import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import '../controllers/todo_controller.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoCtrl = ControllerProvider.of<TodoController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ControllerConsumer<TodoController>(
        builder: (context, controller) => ListView.builder(
          itemCount: controller.todos().length,
          itemBuilder: (ctx, i) => ListTile(
            title: Text(controller.todos()[i]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context, todoCtrl),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, TodoController controller) {
    showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(controller: textController),
          actions: [
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  controller.addTodo(textController.text);
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
