import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/states/restaurant_search_state.dart';
import 'package:kulinere/data/models/restaurant.dart';

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

  String? _selectedCity;
  String? get selectedCity => _selectedCity;

  String _sortBy = 'default';
  String get sortBy => _sortBy;

  void setSelectedCity(String? city) {
    _selectedCity = city;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  List<Restaurant> get result {
    if (_state is RestaurantSearchLoadedState) {
      var filtered = (_state as RestaurantSearchLoadedState).data;

      if (_selectedCity != null) {
        filtered = filtered.where((r) => r.city == _selectedCity).toList();
      }

      if (_sortBy == 'rating') {
        filtered = [...filtered]..sort((a, b) => b.rating.compareTo(a.rating));
      }

      return filtered;
    }
    return [];
  }

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
      _state = RestaurantSearchLoadedState(
        response.restaurants,
        founded: response.founded,
      );
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
    _selectedCity = null;
    _sortBy = 'default';
    notifyListeners();
  }
}
