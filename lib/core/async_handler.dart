import 'package:reign/core/controller.dart';

mixin AsyncHandler on ReignController {
  @override
  Future<T> handleAsync<T>(Future<T> Function() fn) async {
    try {
      clearError();
      return await fn();
    } catch (e) {
      error = e;
      update();
      rethrow;
    }
  }
}
