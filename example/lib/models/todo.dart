class Todo {
  final String text;
  final DateTime createdAt;

  Todo(this.text) : createdAt = DateTime.now();
}
