import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/data/models/customer_review.dart';
import 'package:kulinere/states/restaurant_detail_state.dart';

enum ReviewSubmissionState { idle, submitting, success, error }

/// Manages restaurant detail fetching and review submission.
///
/// Uses sealed class state pattern with optimistic updates for reviews.
class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantDetailProvider(this._apiService);

  RestaurantDetailState _state = RestaurantDetailNoneState();
  RestaurantDetailState get state => _state;

  String? _currentRestaurantId;

  ReviewSubmissionState _submissionState = ReviewSubmissionState.idle;
  ReviewSubmissionState get submissionState => _submissionState;

  String _submissionError = '';
  String get submissionError => _submissionError;

  bool _showAllReviews = false;
  bool get showAllReviews => _showAllReviews;

  void toggleShowAllReviews() {
    _showAllReviews = !_showAllReviews;
    notifyListeners();
  }

  void resetReviewForm() {
    _submissionState = ReviewSubmissionState.idle;
    _submissionError = '';
    notifyListeners();
  }

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

  /// Adds a new review and updates state with API response.
  Future<void> addReview({required String name, required String review}) async {
    if (_currentRestaurantId == null) return;

    final currentState = _state;
    if (currentState is! RestaurantDetailLoadedState) return;

    _submissionState = ReviewSubmissionState.submitting;
    _submissionError = '';
    notifyListeners();

    try {
      final response = await _apiService.addReview(
        id: _currentRestaurantId!,
        name: name,
        review: review,
      );

      final updatedReviews = List<CustomerReview>.from(
        response.customerReviews,
      );
      final updatedDetail = currentState.data.copyWith(
        customerReviews: updatedReviews,
      );

      _state = RestaurantDetailLoadedState(updatedDetail);
      _submissionState = ReviewSubmissionState.success;
      notifyListeners();
    } catch (e) {
      _submissionState = ReviewSubmissionState.error;
      _submissionError = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  void reset() {
    _state = RestaurantDetailNoneState();
    _currentRestaurantId = null;
    notifyListeners();
  }
}
