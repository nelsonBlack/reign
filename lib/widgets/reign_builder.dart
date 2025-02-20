import 'package:flutter/material.dart';
import 'package:reign/core/lifecycle.dart';
import 'package:reign/core/store.dart';
import '../core/controller.dart';
import 'package:reign/core/exceptions.dart';

typedef ReignControllerBuilder<T extends ReignController> = Widget Function(
    BuildContext context, T controller);

/// Widget that builds itself whenever the provided controller changes.
///
/// {@template reign_builder}
/// Two main usage patterns:
///
/// 1. Create new controller:
/// ```dart
/// ReignBuilder<CounterController>(
///   create: () => CounterController(),
///   builder: (context, controller) => Text('${controller.value}'),
/// )
/// ```
///
/// 2. Use existing controller:
/// ```dart
/// ReignBuilder<CounterController>.use(
///   builder: (context, controller) => Text('${controller.value}'),
/// )
/// ```
/// {@endtemplate}
class ReignBuilder<T extends ReignController> extends StatefulWidget {
  final T? controller;
  final T Function()? create;
  final Widget Function(BuildContext context, T controller) builder;
  final ThemeData? theme;
  final Widget? loading;
  final Widget Function(Object error)? error;

  const ReignBuilder({
    super.key,
    this.controller,
    this.create,
    required this.builder,
    this.theme,
    this.loading,
    this.error,
  });

  // Factory constructor for using global controller
  const ReignBuilder.use({
    super.key,
    required this.builder,
    this.theme,
    this.loading,
    this.error,
  })  : controller = null,
        create = null;

  @override
  State<ReignBuilder<T>> createState() => _ReignBuilderState<T>();
}

class _ReignBuilderState<T extends ReignController>
    extends State<ReignBuilder<T>> {
  T? _controller;
  bool _ownsController = false;
  VoidCallback? _updateListener;

  @override
  void initState() {
    super.initState();
    // For .use constructor, throw immediately and synchronously
    if (widget.create == null && widget.controller == null) {
      _controller = ControllerStore.instance.use<T>();
      _setupController();
    } else {
      _initializeController();
    }
  }

  Future<void> _initializeController() async {
    try {
      if (widget.controller != null) {
        _controller = widget.controller;
      } else if (widget.create != null) {
        _ownsController = true;
        _controller = widget.create!();
        ControllerStore.instance.save(_controller!);
      }

      if (_controller != null) {
        _setupController();
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (widget.error != null && mounted) {
        setState(() {});
      } else {
        rethrow;
      }
    }
  }

  void _setupController() {
    if (_controller == null) return;

    _updateListener = () {
      if (mounted) setState(() {});
    };

    // Set the context before initialization
    _controller!.context = context;
    _controller!.addListener(_updateListener!);

    if (!_controller!.isInitialized) {
      _controller!.init();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_controller!.isDisposed) {
        if (_controller!.isInitialized && !_controller!.isReady) {
          _controller!.markReady();
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    if (_controller != null && _updateListener != null) {
      _controller!.removeListener(_updateListener!);
      if (_ownsController) {
        _controller!.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      if (widget.error != null) {
        return widget.error!(Exception('Controller not found'));
      }
      return widget.loading ?? const CircularProgressIndicator();
    }

    Widget child = widget.builder(context, _controller as T);

    if (widget.theme != null) {
      child = Theme(
        data: widget.theme!,
        child: child,
      );
    }

    return child;
  }
}
