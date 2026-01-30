import 'package:kulinere/data/models/restaurant.dart';

sealed class RestaurantSearchState {}

class RestaurantSearchNoneState extends RestaurantSearchState {}

class RestaurantSearchLoadingState extends RestaurantSearchState {}

class RestaurantSearchLoadedState extends RestaurantSearchState {
  final List<Restaurant> data;
  RestaurantSearchLoadedState(this.data);
}

class RestaurantSearchErrorState extends RestaurantSearchState {
  final String error;
  RestaurantSearchErrorState(this.error);
}
