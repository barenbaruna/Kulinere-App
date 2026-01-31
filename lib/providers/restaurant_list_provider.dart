import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/states/restaurant_list_state.dart';

/// Manages restaurant list fetching and state.
///
/// Fetches list on construction. Uses sealed class state pattern.
class RestaurantListProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantListProvider(this._apiService) {
    fetchRestaurantList();
  }

  RestaurantListState _state = RestaurantListNoneState();
  RestaurantListState get state => _state;

  Future<void> fetchRestaurantList() async {
    _state = RestaurantListLoadingState();
    notifyListeners();

    try {
      final response = await _apiService.getRestaurantList();
      _state = RestaurantListLoadedState(response.restaurants);
    } catch (e) {
      _state = RestaurantListErrorState(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }
}
