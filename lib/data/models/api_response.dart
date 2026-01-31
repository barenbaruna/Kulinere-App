import 'restaurant.dart';
import 'restaurant_detail.dart';
import 'customer_review.dart';

/// Response wrapper for restaurant list API.
class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      count: json['count'] as int,
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((item) => Restaurant.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Response wrapper for restaurant detail API.
class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      restaurant: RestaurantDetail.fromJson(
        json['restaurant'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response wrapper for search API.
class SearchResponse {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  SearchResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      error: json['error'] as bool,
      founded: json['founded'] as int,
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((item) => Restaurant.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Response wrapper for review submission API.
class ReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  ReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((item) => CustomerReview.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
