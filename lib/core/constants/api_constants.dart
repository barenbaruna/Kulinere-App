class ApiConstants {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  static const String listEndpoint = '/list';
  static const String detailEndpoint = '/detail';
  static const String searchEndpoint = '/search';
  static const String reviewEndpoint = '/review';

  static String getSmallImageUrl(String pictureId) =>
      '$baseUrl/images/small/$pictureId';

  static String getMediumImageUrl(String pictureId) =>
      '$baseUrl/images/medium/$pictureId';

  static String getLargeImageUrl(String pictureId) =>
      '$baseUrl/images/large/$pictureId';
}
