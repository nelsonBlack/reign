class ControllerException implements Exception {
  final String message;
  ControllerException(this.message);

  @override
  String toString() => 'ControllerError: $message';
}

class ControllerNotFoundError extends ControllerException {
  ControllerNotFoundError(Type type)
      : super('No controller found for type $type');
}

class ControllerInitializationError extends ControllerException {
  ControllerInitializationError(super.message);
}
