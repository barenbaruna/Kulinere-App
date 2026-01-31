import 'package:flutter/material.dart';

/// Manages bottom navigation state across the app.
///
/// Also handles search focus signal for auto-focus when
/// navigating from home search bar to Jelajahi tab.
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _shouldFocusSearch = false;

  int get currentIndex => _currentIndex;
  bool get shouldFocusSearch => _shouldFocusSearch;

  /// Sets the current tab index.
  ///
  /// Optional [focusSearch] triggers auto-focus on search field.
  void setIndex(int index, {bool focusSearch = false}) {
    _shouldFocusSearch = focusSearch;
    if (_currentIndex != index || focusSearch) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Clears the focus signal after it's been consumed.
  void clearSearchFocus() {
    _shouldFocusSearch = false;
  }
}
