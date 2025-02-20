import 'package:flutter/material.dart';
import '../core/controller.dart';
import '../core/store.dart';

/// InheritedWidget that provides a controller to its descendants.
///
/// {@macro reign_provider}
///
/// Typical usage:
/// ```dart
/// ControllerProvider(
///   create: () => MyController(),
///   child: ChildWidget(),
/// )
/// ```
///
/// Access the controller with:
/// ```dart
/// final controller = ControllerProvider.of<MyController>(context);
/// ```
class ControllerProvider<T extends ReignController> extends StatefulWidget {
  final T Function() create;
  final Widget child;
  final String? scope;

  const ControllerProvider({
    super.key,
    required this.create,
    required this.child,
    this.scope,
  });

  static Future<T> of<T extends ReignController>(BuildContext context,
      {String? scope}) async {
    return ControllerStore.instance.use<T>();
  }

  @override
  State<ControllerProvider<T>> createState() => _ControllerProviderState<T>();
}

class _ControllerProviderState<T extends ReignController>
    extends State<ControllerProvider<T>> {
  late Future<T> _controllerFuture;
  T? _controller;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _initializeController();
  }

  Future<T> _initializeController() async {
    final controller = widget.create();
    ControllerStore.instance.save(controller);
    controller.init();

    // Add post-frame callback to mark ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !controller.isDisposed) {
        controller.markReady();
      }
    });

    _controller = controller;
    return controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Link controller context to widget tree
          _controller?.context = context;
          return _ScopedProvider(
            controller: snapshot.data!,
            child: widget.child,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class ControllerConsumer<T extends ReignController> extends StatefulWidget {
  final Widget Function(BuildContext, T) builder;

  const ControllerConsumer({super.key, required this.builder});

  @override
  State<ControllerConsumer<T>> createState() => _ControllerConsumerState<T>();
}

class _ControllerConsumerState<T extends ReignController>
    extends State<ControllerConsumer<T>> {
  late final Future<T> _controllerFuture;
  T? _controller;
  VoidCallback? _listener;

  @override
  void initState() {
    super.initState();
    _controllerFuture = ControllerProvider.of<T>(context);
    _controllerFuture.then((controller) {
      _controller = controller;
      _listener = () {
        if (mounted) setState(() {});
      };
      controller.addListener(_listener!);
    });
  }

  @override
  void dispose() {
    if (_controller != null && _listener != null) {
      _controller!.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!);
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class ReignMultiProvider extends StatelessWidget {
  const ReignMultiProvider({
    super.key,
    required this.controllers,
    required this.child,
  });

  final List<ReignController> controllers;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    for (final controller in controllers.reversed) {
      current = ControllerProvider(
        create: () => controller,
        child: current,
      );
    }
    return current;
  }
}

class ScopedControllerProvider<T extends ReignController>
    extends StatefulWidget {
  final T Function() create;
  final Widget child;
  final String scope;

  const ScopedControllerProvider({
    super.key,
    required this.create,
    required this.child,
    required this.scope,
  });

  static T of<T extends ReignController>(BuildContext context,
      {required String scope}) {
    return context
        .dependOnInheritedWidgetOfExactType<_ScopedProvider<T>>()!
        .controller;
  }

  @override
  State<ScopedControllerProvider<T>> createState() =>
      _ScopedControllerProviderState<T>();
}

class _ScopedControllerProviderState<T extends ReignController>
    extends State<ScopedControllerProvider<T>> {
  late final Future<T> _controllerFuture;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _initializeController();
  }

  Future<T> _initializeController() async {
    final controller = widget.create();
    controller.init();
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _ScopedProvider(
            controller: snapshot.data!,
            child: widget.child,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class _ScopedProvider<T extends ReignController> extends InheritedWidget {
  final T controller;

  const _ScopedProvider({
    required super.child,
    required this.controller,
  });

  @override
  bool updateShouldNotify(_ScopedProvider<T> oldWidget) {
    return controller != oldWidget.controller;
  }
}
