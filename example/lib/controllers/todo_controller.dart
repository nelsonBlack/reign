import 'package:reign/reign.dart';
import '../models/todo.dart';

class TodoController extends ReignController<List<Todo>> {
  final List<Todo> _todos = [];

  TodoController({required List<Todo> initialValue}) : super(initialValue);

  List<Todo> get todos => List.unmodifiable(_todos);

  void addTodo(String text) {
    _todos.add(Todo(text));
    update();
  }
}
