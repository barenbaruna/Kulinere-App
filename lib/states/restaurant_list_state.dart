import 'package:kulinere/data/models/restaurant.dart';

/// Sealed state class for restaurant list operations.
///
/// Uses sealed class pattern for exhaustive state handling.
sealed class RestaurantListState {}

/// Initial state before any fetch.
class RestaurantListNoneState extends RestaurantListState {}

/// Loading state during API call.
class RestaurantListLoadingState extends RestaurantListState {}

/// Success state with restaurant list data.
class RestaurantListLoadedState extends RestaurantListState {
  final List<Restaurant> data;
  RestaurantListLoadedState(this.data);
}

/// Error state with error message.
class RestaurantListErrorState extends RestaurantListState {
  final String error;
  RestaurantListErrorState(this.error);
}
