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
abstract class ReignController extends ValueNotifier<void>
    with Lifecycle, Disposable {
  /// The BuildContext of the nearest [ControllerProvider] ancestor
  BuildContext? _context;

  /// The central store that manages all controllers
  final ControllerStore _store = ControllerStore.instance;

  /// Creates a controller and optionally registers it with the [ControllerStore].
  ///
  /// If [register] is true (default), the controller will be registered with the store
  /// and can be accessed via [ControllerProvider.of] or [dependOn].
  ReignController({bool register = true}) : super(null) {
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
    notifyListeners();
  }

  /// Disposes the controller, cleaning up resources and unregistering from the store.
  ///
  /// This is called automatically when the [ControllerProvider] is disposed.
  /// Subclasses should call super.dispose() if they override this method.
  @override
  @mustCallSuper
  void dispose() {
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
}
