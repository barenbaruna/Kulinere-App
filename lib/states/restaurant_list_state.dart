import 'package:kulinere/data/models/restaurant.dart';

sealed class RestaurantListState {}

class RestaurantListNoneState extends RestaurantListState {}

class RestaurantListLoadingState extends RestaurantListState {}

class RestaurantListLoadedState extends RestaurantListState {
  final List<Restaurant> data;
  RestaurantListLoadedState(this.data);
}

class RestaurantListErrorState extends RestaurantListState {
  final String error;
  RestaurantListErrorState(this.error);
}
