import 'package:flutter/foundation.dart';
import 'package:reign/core/controller.dart';
import '../core/exceptions.dart';

/// Central registry for managing controller instances.
///
/// {@macro reign_store}
///
/// Use this singleton to:
/// - Register controllers with [save]
/// - Retrieve controllers with [use]
/// - Remove controllers with [remove]
///
/// Example:
/// ```dart
/// final store = ControllerStore.instance;
/// store.save(MyController());
/// final controller = store.use<MyController>();
/// ```
class ControllerStore {
  static final ControllerStore instance = ControllerStore._();
  final _controllers = <Type, ReignController>{};
  final Map<ReignController, List<VoidCallback>> _listeners = {};
  static bool debugMode = false;

  ControllerStore._();

  void save(ReignController controller) {
    if (debugMode) {
      debugPrint('Saving ${controller.runtimeType}');
    }
    if (_controllers.containsKey(controller.runtimeType) && !debugMode) {
      throw ControllerConflictError(controller.runtimeType);
    }
    _controllers[controller.runtimeType] = controller;
  }

  T use<T extends ReignController>() {
    final controller = _controllers[T];
    if (controller == null) {
      if (debugMode) {
        debugPrint('Controller not found: $T');
      }
      throw ControllerNotFoundError(T);
    }
    return controller as T;
  }

  void remove(Type type) {
    final controller = _controllers.remove(type);
    controller?.dispose();
    _listeners.removeWhere((key, value) => key.runtimeType == type);
  }

  void addListener(ReignController controller, VoidCallback listener) {
    _listeners.putIfAbsent(controller, () => []).add(listener);
  }

  void removeListener(ReignController controller, VoidCallback listener) {
    _listeners[controller]?.remove(listener);
  }

  void notifyListeners(ReignController controller) {
    _listeners[controller]?.forEach((listener) => listener());
  }

  void reset() {
    // Dispose all controllers properly
    _controllers.values.toList().forEach((c) => c.dispose());
    _controllers.clear();
    _listeners.clear();
    if (debugMode) debugPrint('Store reset');
  }
}
