import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/states/restaurant_list_state.dart';
import 'package:kulinere/data/models/restaurant.dart';

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

  String? _selectedCity;
  String? get selectedCity => _selectedCity;

  List<Restaurant> get restaurants {
    if (_state is RestaurantListLoadedState) {
      final list = (_state as RestaurantListLoadedState).data;
      if (_selectedCity != null) {
        return list.where((r) => r.city == _selectedCity).toList();
      }
      return list;
    }
    return [];
  }

  void setSelectedCity(String? city) {
    if (_selectedCity != city) {
      _selectedCity = city;
      notifyListeners();
    }
  }

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
