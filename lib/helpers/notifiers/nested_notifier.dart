import 'package:flutter/material.dart';

class NestedNotifier<T extends ChangeNotifier> extends ChangeNotifier {
  final T firstNotifier;

  NestedNotifier(this.firstNotifier) {
    firstNotifier.addListener(_onFirstNotifierChanged);
  }

  void _onFirstNotifierChanged() {
    print('First Notifier Changed');
    notifyListeners();
  }

  @override
  void dispose() {
    firstNotifier.removeListener(_onFirstNotifierChanged);
    super.dispose();
  }
}
