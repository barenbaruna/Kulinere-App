import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kulinere/core/constants/api_constants.dart';
import 'package:kulinere/data/models/api_response.dart';

/// HTTP API service for restaurant data operations.
///
/// Provides methods for:
/// - Fetching restaurant list
/// - Fetching restaurant details (with cache busting)
/// - Searching restaurants
/// - Submitting reviews
class ApiService {
  /// Fetches list of all restaurants.
  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.listEndpoint}'),
    );

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Gagal memuat daftar restoran');
    }
  }

  /// Fetches restaurant detail by ID with timestamp to bypass API cache.
  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.detailEndpoint}/$id?_t=$timestamp',
      ),
    );

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Gagal memuat detail restoran');
    }
  }

  /// Searches restaurants by query string.
  Future<SearchResponse> searchRestaurants(String query) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint}?q=${Uri.encodeComponent(query)}',
      ),
    );

    if (response.statusCode == 200) {
      return SearchResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Gagal mencari restoran');
    }
  }

  /// Submits a customer review for a restaurant.
  Future<ReviewResponse> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reviewEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'name': name, 'review': review}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReviewResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Gagal mengirim review');
    }
  }
}
