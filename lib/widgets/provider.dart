import 'package:flutter/material.dart';
import '../core/controller.dart';
import '../core/store.dart';

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

  static T of<T extends ReignController>(BuildContext context) {
    return ControllerStore.instance.get<T>();
  }

  @override
  State<ControllerProvider<T>> createState() => _ControllerProviderState<T>();
}

class _ControllerProviderState<T extends ReignController>
    extends State<ControllerProvider<T>> {
  late final T controller;

  @override
  void initState() {
    super.initState();
    controller = widget.create();
    controller.context = context;
    controller.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.context.mounted) {
        controller.onReady();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
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
  late final T controller;

  @override
  void initState() {
    super.initState();
    controller = ControllerProvider.of<T>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<void>(
      valueListenable: controller,
      builder: (context, _, __) => widget.builder(context, controller),
    );
  }
}
