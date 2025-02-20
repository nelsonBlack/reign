import 'package:flutter/material.dart';

class TodoListItem extends StatelessWidget {
  final int index;

  const TodoListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text('Todo $index'));
  }
}
