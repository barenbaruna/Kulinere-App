import 'package:kulinere/data/models/restaurant_detail.dart';

sealed class RestaurantDetailState {}

class RestaurantDetailNoneState extends RestaurantDetailState {}

class RestaurantDetailLoadingState extends RestaurantDetailState {}

class RestaurantDetailLoadedState extends RestaurantDetailState {
  final RestaurantDetail data;
  RestaurantDetailLoadedState(this.data);
}

class RestaurantDetailErrorState extends RestaurantDetailState {
  final String error;
  RestaurantDetailErrorState(this.error);
}
