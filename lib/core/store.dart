import 'package:flutter/foundation.dart';
import 'package:reign/core/controller.dart';
import '../core/exceptions.dart';

class ControllerStore {
  static final ControllerStore instance = ControllerStore._();
  final Map<Type, ReignController> _controllers = {};
  final Map<ReignController, List<VoidCallback>> _listeners = {};
  static bool debugMode = false;

  ControllerStore._();

  void register(ReignController controller) {
    if (debugMode) {
      debugPrint('Registering ${controller.runtimeType}');
    }
    if (_controllers.containsKey(controller.type)) {
      throw FlutterError(
          'ReignController of type ${controller.type} already registered');
    }
    _controllers[controller.type] = controller;
  }

  T get<T extends ReignController>() {
    final controller = _controllers[T];
    if (controller == null) {
      throw ControllerNotFoundError(T);
    }
    return controller as T;
  }

  void unregister(ReignController controller) {
    if (debugMode) {
      debugPrint('Disposing ${controller.runtimeType}');
    }
    controller.onDispose();
    _controllers.remove(controller.type);
    _listeners.remove(controller);
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
