class ControllerException implements Exception {
  final String message;
  ControllerException(this.message);

  @override
  String toString() => 'ControllerError: $message';
}

/// Error thrown when a requested controller isn't found in the store.
///
/// {@macro reign_controller_not_found}
///
/// Typically occurs when:
/// - Controller wasn't registered
/// - Wrong type parameter used
/// - Accessed before initialization
class ControllerNotFoundError extends Error {
  final Type controllerType;

  ControllerNotFoundError(this.controllerType);

  @override
  String toString() =>
      'ControllerNotFoundError: No controller found for type $controllerType';
}

class ControllerInitializationError extends ControllerException {
  ControllerInitializationError(super.message);
}

/// Error thrown when registering duplicate controllers.
///
/// {@macro reign_controller_conflict}
///
/// Prevented by:
/// - Checking existing registrations first
/// - Using unique types/scopes
/// - Proper cleanup
class ControllerConflictError extends Error {
  final Type controllerType;

  ControllerConflictError(this.controllerType);

  @override
  String toString() =>
      'ControllerConflictError: $controllerType already registered';
}
