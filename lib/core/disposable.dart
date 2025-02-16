import 'package:flutter/foundation.dart';
import 'package:reign/core/lifecycle.dart';

mixin Disposable on Lifecycle {
  final List<Disposable> _disposables = [];

  void addDisposable(Disposable disposable) => _disposables.add(disposable);

  @override
  @mustCallSuper
  void dispose() {
    for (final disposable in _disposables) {
      disposable.dispose();
    }
    _disposables.clear();
    super.dispose();
  }
}
