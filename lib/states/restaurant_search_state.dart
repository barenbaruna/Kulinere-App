import 'package:kulinere/data/models/restaurant.dart';

/// Sealed state class for restaurant search operations.
///
/// Uses sealed class pattern for exhaustive state handling.
sealed class RestaurantSearchState {}

/// Initial state before any search.
class RestaurantSearchNoneState extends RestaurantSearchState {}

/// Loading state during search API call.
class RestaurantSearchLoadingState extends RestaurantSearchState {}

/// Success state with search results.
class RestaurantSearchLoadedState extends RestaurantSearchState {
  final List<Restaurant> data;
  RestaurantSearchLoadedState(this.data);
}

/// Error state with error message.
class RestaurantSearchErrorState extends RestaurantSearchState {
  final String error;
  RestaurantSearchErrorState(this.error);
}
