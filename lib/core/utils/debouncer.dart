import 'dart:async';
import 'package:flutter/material.dart';

/// Utility class to debounce rapid function calls.
///
/// Commonly used for search input to avoid excessive API calls.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
