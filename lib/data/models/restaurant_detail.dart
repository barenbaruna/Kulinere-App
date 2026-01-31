import 'package:kulinere/core/constants/api_constants.dart';
import 'menu_item.dart';
import 'customer_review.dart';

/// Detailed restaurant model with full information.
///
/// Includes menus, categories, reviews, and copyWith for immutable updates.
class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menus menus;
  final double rating;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      pictureId: json['pictureId'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      menus: Menus.fromJson(json['menus'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((item) => CustomerReview.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  RestaurantDetail copyWith({
    String? id,
    String? name,
    String? description,
    String? city,
    String? address,
    String? pictureId,
    List<Category>? categories,
    Menus? menus,
    double? rating,
    List<CustomerReview>? customerReviews,
  }) {
    return RestaurantDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      city: city ?? this.city,
      address: address ?? this.address,
      pictureId: pictureId ?? this.pictureId,
      categories: categories ?? this.categories,
      menus: menus ?? this.menus,
      rating: rating ?? this.rating,
      customerReviews: customerReviews ?? this.customerReviews,
    );
  }

  String get smallImageUrl => ApiConstants.getSmallImageUrl(pictureId);
  String get mediumImageUrl => ApiConstants.getMediumImageUrl(pictureId);
  String get largeImageUrl => ApiConstants.getLargeImageUrl(pictureId);
}
