import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/data/models/customer_review.dart';
import 'package:kulinere/states/restaurant_detail_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantDetailProvider(this._apiService);

  RestaurantDetailState _state = RestaurantDetailNoneState();
  RestaurantDetailState get state => _state;

  String? _currentRestaurantId;

  Future<void> fetchRestaurantDetail(String id) async {
    _currentRestaurantId = id;
    _state = RestaurantDetailLoadingState();
    notifyListeners();

    try {
      final response = await _apiService.getRestaurantDetail(id);
      _state = RestaurantDetailLoadedState(response.restaurant);
    } catch (e) {
      _state = RestaurantDetailErrorState(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }

  Future<void> addReview({
    required String name,
    required String review,
  }) async {
    if (_currentRestaurantId == null) return;

    final currentState = _state;
    if (currentState is! RestaurantDetailLoadedState) return;

    try {
      final response = await _apiService.addReview(
        id: _currentRestaurantId!,
        name: name,
        review: review,
      );

      final updatedDetail = currentState.data;
      final updatedReviews = List<CustomerReview>.from(response.customerReviews);

      _state = RestaurantDetailLoadedState(
        _copyDetailWithReviews(updatedDetail, updatedReviews),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  dynamic _copyDetailWithReviews(dynamic detail, List<CustomerReview> reviews) {
    return detail;
  }

  void reset() {
    _state = RestaurantDetailNoneState();
    _currentRestaurantId = null;
    notifyListeners();
  }
}
