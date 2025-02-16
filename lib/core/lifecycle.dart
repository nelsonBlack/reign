import 'package:flutter/foundation.dart';

mixin Lifecycle {
  bool _initialized = false;
  bool _disposed = false;

  bool get isInitialized => _initialized;
  bool get isDisposed => _disposed;

  void init() {
    assert(!_disposed, 'Cannot initialize a disposed controller');
    if (!_initialized) {
      onInit();
      _initialized = true;
    }
  }

  void onInit() {}
  void onReady() {}

  @mustCallSuper
  void dispose() {
    if (!_disposed) {
      onDispose();
      _disposed = true;
    }
  }

  void onDispose() {}
}
