import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'disposable.dart';
import 'lifecycle.dart';
import 'store.dart';

/// Base class for all state controllers in the Reign system.
///
/// {@template reign_controller}
/// Controllers manage business logic and state for your application.
/// They automatically handle lifecycle events when used with [ReignBuilder]
/// or [ControllerProvider].
///
/// Example usage:
/// ```dart
/// class CounterController extends ReignController<int> {
///   CounterController() : super(0);
///
///   void increment() {
///     value++;
///     update();
///   }
/// }
/// ```
/// {@endtemplate}
abstract class ReignController<T> extends ValueNotifier<T>
    with Lifecycle, Disposable {
  /// The BuildContext of the nearest [ControllerProvider] ancestor
  BuildContext? _context;

  /// The central store that manages all controllers
  final ControllerStore _store = ControllerStore.instance;

  /// Creates a controller and optionally registers it with the [ControllerStore].
  ///
  /// If [register] is true (default), the controller will be registered with the store
  /// and can be accessed via [ControllerProvider.of] or [dependOn].
  ReignController(T initialValue, {bool register = true})
      : super(initialValue) {
    if (register) {
      _store.save(this);
    }
  }

  /// The BuildContext of the nearest [ControllerProvider] ancestor.
  ///
  /// This can be used to access inherited widgets and perform navigation.
  /// Throws an assertion error if accessed before the controller is initialized.
  BuildContext get context {
    assert(_context != null, 'Context accessed before initialization');
    return _context!;
  }

  BuildContext? get safeContext {
    assert(_context != null, 'Context accessed before initialization');
    return _context!;
  }

  /// Sets the BuildContext for this controller.
  /// This is called internally by [ControllerProvider].
  @protected
  set context(BuildContext value) => _context = value;

  /// Notifies all listeners that the controller's state has changed.
  ///
  /// Call this method whenever the controller's state changes to rebuild
  /// dependent widgets.
  @protected
  void update() {
    notifyListeners();
  }

  /// Disposes the controller, cleaning up resources and unregistering from the store.
  ///
  /// This is called automatically when the [ControllerProvider] is disposed.
  /// Subclasses should call super.dispose() if they override this method.
  @override
  @mustCallSuper
  void dispose() {
    _store.remove(runtimeType);
    _context = null;
    super.dispose();
  }

  /// Returns the runtime type of this controller.
  Type get type => runtimeType;

  /// Retrieves another controller of type [T] from the store.
  ///
  /// This allows controllers to depend on and communicate with other controllers.
  /// Throws a [ControllerNotFoundError] if no controller of type [T] is registered.
  T dependOn<T extends ReignController>() {
    return ControllerStore.instance.use<T>();
  }

  Object? error;
  bool hasError = false;

  Future<T> handleAsync<T>(Future<T> Function() operation) async {
    try {
      hasError = false;
      update();
      return await operation();
    } catch (e) {
      error = e;
      hasError = true;
      update();
      rethrow;
    } finally {
      update();
    }
  }

  void clearError() {
    error = null;
    update();
  }

  bool _isReady = false;
  @override
  bool get isReady => _isReady;

  @override
  void onReady() {
    _isReady = true;
    _onReady();
  }

  @protected
  void _onReady() {}

  @override
  void onDispose() {
    super.onDispose();
    // Controller dispose logic
  }
}
