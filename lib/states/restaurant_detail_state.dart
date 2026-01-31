import 'package:kulinere/data/models/restaurant_detail.dart';

/// Sealed state class for restaurant detail operations.
///
/// Uses sealed class pattern for exhaustive state handling.
sealed class RestaurantDetailState {}

/// Initial state before any fetch.
class RestaurantDetailNoneState extends RestaurantDetailState {}

/// Loading state during API call.
class RestaurantDetailLoadingState extends RestaurantDetailState {}

/// Success state with restaurant detail data.
class RestaurantDetailLoadedState extends RestaurantDetailState {
  final RestaurantDetail data;
  RestaurantDetailLoadedState(this.data);
}

/// Error state with error message.
class RestaurantDetailErrorState extends RestaurantDetailState {
  final String error;
  RestaurantDetailErrorState(this.error);
}
