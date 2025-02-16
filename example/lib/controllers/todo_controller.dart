import 'package:reign/reign.dart';

class TodoController extends ReignController {
  final List<String> _todos = [];

  List<String> todos() => List.unmodifiable(_todos);

  void addTodo(String text) {
    _todos.add(text);
    update();
  }
}
