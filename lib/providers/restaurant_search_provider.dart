import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/states/restaurant_search_state.dart';

/// Manages restaurant search with query state tracking.
///
/// Uses sealed class state pattern. Tracks last query for retry.
class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantSearchProvider(this._apiService);

  RestaurantSearchState _state = RestaurantSearchNoneState();
  RestaurantSearchState get state => _state;

  String _lastQuery = '';
  String get lastQuery => _lastQuery;

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _state = RestaurantSearchNoneState();
      _lastQuery = '';
      notifyListeners();
      return;
    }

    _lastQuery = query;
    _state = RestaurantSearchLoadingState();
    notifyListeners();

    try {
      final response = await _apiService.searchRestaurants(query);
      _state = RestaurantSearchLoadedState(response.restaurants);
    } catch (e) {
      _state = RestaurantSearchErrorState(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }

  void reset() {
    _state = RestaurantSearchNoneState();
    _lastQuery = '';
    notifyListeners();
  }
}
