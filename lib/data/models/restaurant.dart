import 'package:kulinere/core/constants/api_constants.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pictureId: json['pictureId'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  String get smallImageUrl => ApiConstants.getSmallImageUrl(pictureId);
  String get mediumImageUrl => ApiConstants.getMediumImageUrl(pictureId);
  String get largeImageUrl => ApiConstants.getLargeImageUrl(pictureId);
}
