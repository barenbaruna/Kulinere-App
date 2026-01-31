import 'package:flutter/material.dart';

/// Manages user's bookmarked/favorite restaurants.
///
/// Uses in-memory Set storage (can be extended with SharedPreferences).
class BookmarkProvider extends ChangeNotifier {
  final Set<String> _bookmarkedIds = {};

  /// Unmodifiable view of bookmarked restaurant IDs.
  Set<String> get bookmarkedIds => Set.unmodifiable(_bookmarkedIds);

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
  }

  void addBookmark(String id) {
    if (!_bookmarkedIds.contains(id)) {
      _bookmarkedIds.add(id);
      notifyListeners();
    }
  }

  void removeBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
      notifyListeners();
    }
  }
}
