import 'package:flutter/material.dart';
import 'package:kulinere/core/database/favorites_database_service.dart';
import 'package:kulinere/data/models/restaurant.dart';

/// Manages user's favorite restaurants with SQLite persistence.
///
/// Features:
/// - SQLite backed storage (survives app restart)
/// - Real-time UI updates via notifyListeners()
/// - Duplicate prevention with ConflictAlgorithm.replace
class FavoritesProvider extends ChangeNotifier {
  final FavoritesDatabaseService _service;

  FavoritesProvider(this._service);

  List<Restaurant> _favorites = [];
  String? _error;
  bool _isLoading = false;

  /// Unmodifiable list of favorite restaurants.
  List<Restaurant> get favorites => List.unmodifiable(_favorites);

  /// Error message if any operation failed.
  String? get error => _error;

  /// Whether data is being loaded.
  bool get isLoading => _isLoading;

  /// Loads all favorites from SQLite database.
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.getAllFavorites();
      _favorites = data
          .map(
            (json) => Restaurant(
              id: json['id'] as String,
              name: json['name'] as String,
              city: json['city'] as String,
              rating: json['rating'] as double,
              pictureId: json['pictureId'] as String,
              description: '', // Not stored in favorites
            ),
          )
          .toList();
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat favorit: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Checks if a restaurant is in favorites by ID.
  bool isFavorite(String id) => _favorites.any((r) => r.id == id);

  /// Adds or removes a restaurant from favorites.
  ///
  /// If already favorite, removes it. Otherwise, adds it.
  /// Automatically refreshes the list after operation.
  Future<void> toggleFavorite(Restaurant restaurant) async {
    try {
      if (isFavorite(restaurant.id)) {
        await _service.deleteFavorite(restaurant.id);
      } else {
        await _service.insertFavorite({
          'id': restaurant.id,
          'name': restaurant.name,
          'city': restaurant.city,
          'rating': restaurant.rating,
          'pictureId': restaurant.pictureId,
        });
      }
      await loadFavorites();
    } catch (e) {
      _error = 'Gagal mengubah favorit: $e';
      notifyListeners();
    }
  }

  /// Adds a restaurant to favorites.
  Future<void> addFavorite(Restaurant restaurant) async {
    if (!isFavorite(restaurant.id)) {
      await toggleFavorite(restaurant);
    }
  }

  /// Removes a restaurant from favorites.
  Future<void> removeFavorite(String id) async {
    try {
      await _service.deleteFavorite(id);
      await loadFavorites();
    } catch (e) {
      _error = 'Gagal menghapus favorit: $e';
      notifyListeners();
    }
  }
}
