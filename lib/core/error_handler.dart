import 'package:reign/core/controller.dart';
import 'dart:collection';

mixin ErrorHandler<T> on ReignController<T> {
  final _errors = Queue<Exception>();
  @override
  bool get hasError => _errors.isNotEmpty;

  void addError(Exception error) {
    _errors.add(error);
    update();
  }

  Exception? get lastError => _errors.isNotEmpty ? _errors.last : null;

  @override
  Future<R> handleAsync<R>(Future<R> Function() operation) async {
    try {
      return await operation();
    } catch (e) {
      if (e is Exception) {
        addError(e);
      } else {
        addError(Exception(e.toString()));
      }
      rethrow;
    } finally {
      update();
    }
  }
}
