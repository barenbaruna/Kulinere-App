import 'package:flutter/material.dart';

class BookmarkProvider extends ChangeNotifier {
  final Set<String> _bookmarkedIds = {};

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
