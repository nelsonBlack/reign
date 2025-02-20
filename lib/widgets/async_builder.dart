import 'package:flutter/material.dart';

class ReignAsyncBuilder<T> extends StatelessWidget {
  final Future<T> Function() future;
  final Widget Function(T data) builder;
  final Widget Function(Object error)? errorBuilder;
  final Widget? loadingWidget;

  const ReignAsyncBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.errorBuilder,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return errorBuilder?.call(snapshot.error!) ??
              Text('Error: ${snapshot.error}');
        }
        return builder(snapshot.data as T);
      },
    );
  }
}
