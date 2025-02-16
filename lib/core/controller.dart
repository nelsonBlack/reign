import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'disposable.dart';
import 'lifecycle.dart';
import 'store.dart';

/// Base class for all controllers in the Reign framework.
///
/// Controllers manage application state and business logic. They can be used to:
/// - Store and modify state
/// - Handle business logic
/// - Manage dependencies between controllers
/// - Respond to lifecycle events
///
/// Example:
/// ```dart
/// class CounterController extends Controller {
///   int count = 0;
///
///   void increment() {
///     count++;
///     update();
///   }
/// }
/// ```
abstract class ReignController
    with Lifecycle, Disposable
    implements ValueListenable<void> {
  /// The BuildContext of the nearest [ControllerProvider] ancestor
  BuildContext? _context;

  /// The central store that manages all controllers
  final ControllerStore _store = ControllerStore.instance;

  /// Internal notifier used to trigger widget rebuilds
  final ValueNotifier<Object?> _notifier = ValueNotifier<Object?>(null);

  /// Creates a controller and optionally registers it with the [ControllerStore].
  ///
  /// If [register] is true (default), the controller will be registered with the store
  /// and can be accessed via [ControllerProvider.of] or [dependOn].
  ReignController({bool register = true}) {
    if (register) {
      _store.register(this);
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

  /// Sets the BuildContext for this controller.
  /// This is called internally by [ControllerProvider].
  set context(BuildContext value) => _context = value;

  /// Notifies all listeners that the controller's state has changed.
  ///
  /// Call this method whenever the controller's state changes to rebuild
  /// dependent widgets.
  @protected
  void update() {
    _notifier.value = _notifier.value == null ? Object() : null;
    _store.notifyListeners(this);
  }

  /// Adds a listener that will be called whenever [update] is called.
  @override
  void addListener(VoidCallback listener) {
    _notifier.addListener(listener);
    _store.addListener(this, listener);
  }

  /// Removes a previously registered listener.
  @override
  void removeListener(VoidCallback listener) {
    _notifier.removeListener(listener);
    _store.removeListener(this, listener);
  }

  /// Disposes the controller, cleaning up resources and unregistering from the store.
  ///
  /// This is called automatically when the [ControllerProvider] is disposed.
  /// Subclasses should call super.dispose() if they override this method.
  @override
  @mustCallSuper
  void dispose() {
    _notifier.dispose();
    _store.unregister(this);
    super.dispose();
  }

  /// Returns the runtime type of this controller.
  Type get type => runtimeType;

  /// Retrieves another controller of type [T] from the store.
  ///
  /// This allows controllers to depend on and communicate with other controllers.
  /// Throws a [ControllerNotFoundError] if no controller of type [T] is registered.
  T dependOn<T extends ReignController>() {
    return ControllerStore.instance.get<T>();
  }

  /// Implementation of [ValueListenable.value].
  /// This is used internally and should not be called directly.
  @override
  void get value {}
}
