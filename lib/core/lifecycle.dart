import 'package:flutter/foundation.dart';

enum LifecycleState { created, initialized, ready, disposed }

mixin Lifecycle {
  LifecycleState _state = LifecycleState.created;

  @protected
  void initialize() {
    if (_state != LifecycleState.created) return;
    _state = LifecycleState.initialized;
    onInit();
  }

  @protected
  void markReady() {
    if (_state != LifecycleState.initialized) return;
    _state = LifecycleState.ready;
    onReady();
  }

  @mustCallSuper
  void dispose() {
    if (_state == LifecycleState.disposed) return;
    _state = LifecycleState.disposed;
    onDispose();
  }

  @mustCallSuper
  void init() {
    if (_state != LifecycleState.created) return;
    _state = LifecycleState.initialized;
    onInit();
  }

  @protected
  void onInit() {}

  @protected
  void onReady() {}

  @protected
  void onDispose() {}

  bool get isInitialized => _state.index >= LifecycleState.initialized.index;
  bool get isDisposed => _state == LifecycleState.disposed;
  bool get isReady => _state == LifecycleState.ready;
}
