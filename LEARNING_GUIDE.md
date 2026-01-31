# Kulinere App - Panduan Belajar Lengkap 🚀

**Untuk Pemula | Step-by-Step | Berurutan dari Nol**

> Ketik semua kode sendiri untuk membangun muscle memory. Jangan copy-paste!

---

## 📋 Daftar Isi

| No | Fase | Hari | File yang Dibuat |
|----|------|------|------------------|
| 0 | [Setup Project](#fase-0-setup-project) | 1 | `pubspec.yaml`, `analysis_options.yaml` |
| 1 | [Core Layer](#fase-1-core-layer) | 1-2 | Constants, Colors, Theme |
| 2 | [Data Layer](#fase-2-data-layer) | 3-4 | Models, API Service |
| 3 | [State Layer](#fase-3-state-layer) | 5-6 | States, Providers |
| 4 | [Widget Layer](#fase-4-widget-layer) | 7 | Reusable widgets |
| 5 | [Screen Layer](#fase-5-screen-layer) | 8-11 | All screens |
| 6 | [Polish](#fase-6-polish) | 12 | Testing, cleanup |

---

## 🧠 Mental Model: Urutan Membangun

```
STEP 1: Configuration (.yaml files)
    ↓
STEP 2: Core (constants, colors, theme)
    ↓
STEP 3: Data (models, api service)
    ↓
STEP 4: States (sealed classes)
    ↓
STEP 5: Providers (state management)
    ↓
STEP 6: Widgets (reusable components)
    ↓
STEP 7: Screens (UI pages)
    ↓
STEP 8: Main.dart (entry point - LAST!)
```

**Aturan:** Selalu bangun dari bawah ke atas. File yang di-import harus dibuat duluan!

---

## Fase 0: Setup Project

### Step 0.1: Buat Project

```bash
flutter create kulinere
cd kulinere
```

### Step 0.2: pubspec.yaml

**File:** `pubspec.yaml`

Hapus semua komentar bawaan, ganti dengan ini:

```yaml
name: kulinere
description: "A restaurant app."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.10.7

dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.5

  # Networking
  http: ^1.2.2

  # Image Caching
  cached_network_image: ^3.4.1

  # Icons
  cupertino_icons: ^1.0.8

  # Fonts
  google_fonts: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
  assets:
    - images/
```

### Step 0.3: analysis_options.yaml

**File:** `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Tambahkan rules jika perlu
```

### Step 0.4: Buat Folder Structure

```bash
# Buat folder assets
mkdir images

# Buat folder structure di lib/
mkdir lib\core\constants
mkdir lib\core\theme
mkdir lib\core\utils
mkdir lib\data\api
mkdir lib\data\models
mkdir lib\providers
mkdir lib\states
mkdir lib\widgets
mkdir lib\screens\splash
mkdir lib\screens\main
mkdir lib\screens\home\widgets
mkdir lib\screens\detail\widgets
mkdir lib\screens\search
mkdir lib\screens\bookmark
mkdir lib\screens\profile
```

### Step 0.5: Install Dependencies

```bash
flutter pub get
```

---

## Fase 1: Core Layer

### Step 1.1: API Constants

**File:** `lib/core/constants/api_constants.dart`

```dart
/// API endpoint constants dan image URL builders.
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
```

### Step 1.2: App Colors

**File:** `lib/core/theme/app_colors.dart`

```dart
import 'package:flutter/material.dart';

/// App-wide color palette following design system.
class AppColors {
  // Brand Colors
  static const Color gold = Color(0xFFf3d396);
  static const Color goldDark = Color(0xFFC9A86C);

  /// Returns gold color with proper contrast for the current theme.
  static Color goldVisible(bool isDark) => isDark ? gold : goldDark;

  // Light Mode
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFDF8F0);
  static const Color lightTextPrimary = Color(0xFF1F1F1F);
  static const Color lightTextSecondary = Color(0xFF5C5C5C);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1A14);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info = Color(0xFF2196F3);
}
```

### Step 1.3: App Typography

**File:** `lib/core/theme/app_typography.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography using Google Fonts.
class AppTypography {
  static TextTheme textTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        height: 1.25,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.29,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.33,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.44,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        height: 1.5,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.43,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        height: 1.33,
      ),
    );
  }
}
```

### Step 1.4: App Theme

**File:** `lib/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// App theme configuration with Material 3.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.goldDark,
        onPrimary: AppColors.lightTextPrimary,
        secondary: AppColors.gold,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightDivider,
      textTheme: AppTypography.textTheme(
        AppColors.lightTextPrimary,
        AppColors.lightTextSecondary,
      ),
      appBarTheme: _buildAppBarTheme(isDark: false),
      cardTheme: _buildCardTheme(AppColors.lightSurface),
      filledButtonTheme: _buildFilledButtonTheme(
        backgroundColor: AppColors.goldDark,
        foregroundColor: AppColors.lightTextPrimary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.gold,
        onPrimary: AppColors.lightTextPrimary,
        secondary: AppColors.goldDark,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
      textTheme: AppTypography.textTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      appBarTheme: _buildAppBarTheme(isDark: true),
      cardTheme: _buildCardTheme(AppColors.darkSurface),
      filledButtonTheme: _buildFilledButtonTheme(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.lightTextPrimary,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme({required bool isDark}) {
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final fgColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    
    return AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: bgColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: fgColor,
      ),
    );
  }

  static CardThemeData _buildCardTheme(Color color) {
    return CardThemeData(
      color: color,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
```

### Step 1.5: Debouncer Utility

**File:** `lib/core/utils/debouncer.dart`

```dart
import 'dart:async';
import 'package:flutter/material.dart';

/// Utility class to debounce rapid function calls.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
```

---

## Fase 2: Data Layer

### Step 2.1: Customer Review Model

**File:** `lib/data/models/customer_review.dart`

```dart
/// Customer review from API.
class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] as String,
      review: json['review'] as String,
      date: json['date'] as String,
    );
  }
}
```

### Step 2.2: Menu Item Model

**File:** `lib/data/models/menu_item.dart`

```dart
/// Single menu item (food or drink).
class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] as String);
  }
}

/// Container for food and drink menus.
class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List<dynamic>)
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>)
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Restaurant category tag.
class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] as String);
  }
}
```

### Step 2.3: Restaurant Model

**File:** `lib/data/models/restaurant.dart`

```dart
import 'package:kulinere/core/constants/api_constants.dart';

/// Restaurant model for list display.
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
```

### Step 2.4: Restaurant Detail Model

**File:** `lib/data/models/restaurant_detail.dart`

```dart
import 'package:kulinere/core/constants/api_constants.dart';
import 'menu_item.dart';
import 'customer_review.dart';

/// Detailed restaurant model with full information.
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

  RestaurantDetail copyWith({List<CustomerReview>? customerReviews}) {
    return RestaurantDetail(
      id: id,
      name: name,
      description: description,
      city: city,
      address: address,
      pictureId: pictureId,
      categories: categories,
      menus: menus,
      rating: rating,
      customerReviews: customerReviews ?? this.customerReviews,
    );
  }

  String get smallImageUrl => ApiConstants.getSmallImageUrl(pictureId);
  String get mediumImageUrl => ApiConstants.getMediumImageUrl(pictureId);
  String get largeImageUrl => ApiConstants.getLargeImageUrl(pictureId);
}
```

### Step 2.5: API Response Models

**File:** `lib/data/models/api_response.dart`

```dart
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
```

### Step 2.6: API Service

**File:** `lib/data/api/api_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kulinere/core/constants/api_constants.dart';
import 'package:kulinere/data/models/api_response.dart';

/// HTTP API service for restaurant data operations.
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

  /// Fetches restaurant detail by ID.
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
```

---

## Fase 3: State Layer

### Step 3.1: Restaurant List State

**File:** `lib/states/restaurant_list_state.dart`

```dart
import 'package:kulinere/data/models/restaurant.dart';

/// Sealed class for restaurant list states.
sealed class RestaurantListState {}

/// Initial state before any action.
class RestaurantListNoneState extends RestaurantListState {}

/// Loading state while fetching data.
class RestaurantListLoadingState extends RestaurantListState {}

/// Error state when fetch fails.
class RestaurantListErrorState extends RestaurantListState {
  final String message;
  RestaurantListErrorState(this.message);
}

/// Success state with restaurant data.
class RestaurantListLoadedState extends RestaurantListState {
  final List<Restaurant> data;
  RestaurantListLoadedState(this.data);
}
```

### Step 3.2: Restaurant Detail State

**File:** `lib/states/restaurant_detail_state.dart`

```dart
import 'package:kulinere/data/models/restaurant_detail.dart';

/// Sealed class for restaurant detail states.
sealed class RestaurantDetailState {}

/// Initial state before any action.
class RestaurantDetailNoneState extends RestaurantDetailState {}

/// Loading state while fetching data.
class RestaurantDetailLoadingState extends RestaurantDetailState {}

/// Error state when fetch fails.
class RestaurantDetailErrorState extends RestaurantDetailState {
  final String message;
  RestaurantDetailErrorState(this.message);
}

/// Success state with restaurant detail data.
class RestaurantDetailLoadedState extends RestaurantDetailState {
  final RestaurantDetail data;
  RestaurantDetailLoadedState(this.data);
}
```

### Step 3.3: Restaurant Search State

**File:** `lib/states/restaurant_search_state.dart`

```dart
import 'package:kulinere/data/models/restaurant.dart';

/// Sealed class for restaurant search states.
sealed class RestaurantSearchState {}

/// Initial state before any search.
class RestaurantSearchNoneState extends RestaurantSearchState {}

/// Loading state while searching.
class RestaurantSearchLoadingState extends RestaurantSearchState {}

/// Error state when search fails.
class RestaurantSearchErrorState extends RestaurantSearchState {
  final String message;
  RestaurantSearchErrorState(this.message);
}

/// Success state with search results.
class RestaurantSearchLoadedState extends RestaurantSearchState {
  final List<Restaurant> data;
  RestaurantSearchLoadedState(this.data);
}
```

### Step 3.4: Restaurant List Provider

**File:** `lib/providers/restaurant_list_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/states/restaurant_list_state.dart';

/// Provider for managing restaurant list state.
class RestaurantListProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantListState _state = RestaurantListNoneState();
  RestaurantListState get state => _state;

  RestaurantListProvider(this._apiService);

  /// Fetches restaurant list from API.
  Future<void> fetchRestaurantList() async {
    _state = RestaurantListLoadingState();
    notifyListeners();

    try {
      final response = await _apiService.getRestaurantList();
      _state = RestaurantListLoadedState(response.restaurants);
    } catch (e) {
      _state = RestaurantListErrorState(e.toString());
    }

    notifyListeners();
  }
}
```

### Step 3.5: Restaurant Detail Provider

**File:** `lib/providers/restaurant_detail_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/states/restaurant_detail_state.dart';

/// Provider for managing restaurant detail state.
class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantDetailState _state = RestaurantDetailNoneState();
  RestaurantDetailState get state => _state;

  RestaurantDetailProvider(this._apiService);

  /// Fetches restaurant detail by ID.
  Future<void> fetchRestaurantDetail(String id) async {
    _state = RestaurantDetailLoadingState();
    notifyListeners();

    try {
      final response = await _apiService.getRestaurantDetail(id);
      _state = RestaurantDetailLoadedState(response.restaurant);
    } catch (e) {
      _state = RestaurantDetailErrorState(e.toString());
    }

    notifyListeners();
  }

  /// Adds a review and updates the current state.
  Future<void> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await _apiService.addReview(
        id: id,
        name: name,
        review: review,
      );

      final currentState = _state;
      if (currentState is RestaurantDetailLoadedState) {
        _state = RestaurantDetailLoadedState(
          currentState.data.copyWith(customerReviews: response.customerReviews),
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
```

### Step 3.6: Restaurant Search Provider

**File:** `lib/providers/restaurant_search_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/states/restaurant_search_state.dart';

/// Provider for managing restaurant search state.
class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantSearchState _state = RestaurantSearchNoneState();
  RestaurantSearchState get state => _state;

  String _lastQuery = '';
  String get lastQuery => _lastQuery;

  RestaurantSearchProvider(this._apiService);

  /// Searches restaurants by query.
  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _state = RestaurantSearchNoneState();
      _lastQuery = '';
      notifyListeners();
      return;
    }

    _lastQuery = query;
    _state = RestaurantSearchLoadingState();
    notifyListeners();

    try {
      final response = await _apiService.searchRestaurants(query);
      _state = RestaurantSearchLoadedState(response.restaurants);
    } catch (e) {
      _state = RestaurantSearchErrorState(e.toString());
    }

    notifyListeners();
  }

  /// Clears search results.
  void clearSearch() {
    _state = RestaurantSearchNoneState();
    _lastQuery = '';
    notifyListeners();
  }
}
```

### Step 3.7: Bookmark Provider

**File:** `lib/providers/bookmark_provider.dart`

```dart
import 'package:flutter/material.dart';

/// Provider for managing bookmarked restaurants.
class BookmarkProvider extends ChangeNotifier {
  final Set<String> _bookmarkedIds = {};

  Set<String> get bookmarkedIds => _bookmarkedIds;

  /// Checks if a restaurant is bookmarked.
  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  /// Toggles bookmark status for a restaurant.
  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
  }
}
```

### Step 3.8: Navigation Provider

**File:** `lib/providers/navigation_provider.dart`

```dart
import 'package:flutter/material.dart';

/// Provider for managing bottom navigation state.
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _shouldFocusSearch = false;

  int get currentIndex => _currentIndex;
  bool get shouldFocusSearch => _shouldFocusSearch;

  /// Sets current navigation index.
  void setIndex(int index, {bool focusSearch = false}) {
    _currentIndex = index;
    _shouldFocusSearch = focusSearch;
    notifyListeners();
  }

  /// Clears search focus flag.
  void clearSearchFocus() {
    _shouldFocusSearch = false;
  }
}
```

### Step 3.9: User Profile Provider

**File:** `lib/providers/user_profile_provider.dart`

```dart
import 'package:flutter/material.dart';

/// Provider for managing user profile data and dynamic greetings.
class UserProfileProvider extends ChangeNotifier {
  String _userName = 'Baren Baruna Harahap';

  String get userName => _userName;
  String get firstName => _userName.split(' ').first;

  void setUserName(String name) {
    if (_userName != name) {
      _userName = name;
      notifyListeners();
    }
  }

  /// Time-based greeting in Indonesian.
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  String get fullGreeting => '$greeting, $firstName!';
}
```

---

## Fase 4: Widget Layer

### Step 4.1: Loading Widget

**File:** `lib/widgets/loading_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';

/// Centered loading indicator with optional message.
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.goldVisible(isDark)),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
```

### Step 4.2: Error Widget

**File:** `lib/widgets/error_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';

/// Error display with retry button.
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Oops! Terjadi Kesalahan',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 4.3: Cached Image Widget

**File:** `lib/widgets/cached_image.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Cached network image with loading and error states.
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
```

### Step 4.4: Profile Avatar Widget

**File:** `lib/widgets/profile_avatar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:kulinere/core/theme/app_colors.dart';

/// Reusable profile avatar widget with gold ring styling.
class ProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final bool showImage;

  static const String _profileImagePath = 'images/profile_photo.jpg';

  const ProfileAvatar({
    super.key,
    this.size = 36,
    this.onTap,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = AppColors.goldVisible(isDark);

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: goldColor, width: size > 40 ? 3 : 2),
      ),
      child: ClipOval(
        child: showImage
            ? _buildImageAvatar(isDark, goldColor)
            : _buildInitialsAvatar(isDark, goldColor),
      ),
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: avatar) : avatar;
  }

  Widget _buildImageAvatar(bool isDark, Color goldColor) {
    return Image.asset(
      _profileImagePath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _buildInitialsAvatar(isDark, goldColor),
    );
  }

  Widget _buildInitialsAvatar(bool isDark, Color goldColor) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Text(
        'B',
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: goldColor,
        ),
      ),
    );
  }
}
```

---

## Fase 5: Screen Layer

**Urutan pembuatan screens:**

1. `SplashScreen` - Entry point visual
2. `MainScreen` - Container dengan bottom navigation
3. `HomeScreen` - Daftar restoran
4. `SearchScreen` - Pencarian
5. `BookmarkScreen` - Restoran tersimpan
6. `ProfileScreen` - Profil user
7. `DetailScreen` - Detail restoran

> **Catatan:** Kode lengkap untuk setiap screen cukup panjang. Lihat file-file di `lib/screens/` untuk implementasi lengkap.

### Pola Umum untuk Screens:

```dart
class ExampleScreen extends StatefulWidget {
  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data
    Future.microtask(() {
      context.read<SomeProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SomeProvider>(
        builder: (context, provider, child) {
          // Pattern matching dengan switch expression
          return switch (provider.state) {
            LoadingState() => const LoadingWidget(),
            LoadedState(data: var items) => _buildContent(items),
            ErrorState(message: var msg) => AppErrorWidget(
              message: msg,
              onRetry: () => provider.fetchData(),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }

  Widget _buildContent(List<Item> items) {
    // Build your UI here
  }
}
```

---

## Fase 6: Main.dart (Entry Point)

**File:** `lib/main.dart`

**BUAT INI TERAKHIR** setelah semua file lain selesai!

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_theme.dart';
import 'package:kulinere/data/api/api_service.dart';
import 'package:kulinere/providers/bookmark_provider.dart';
import 'package:kulinere/providers/navigation_provider.dart';
import 'package:kulinere/providers/restaurant_detail_provider.dart';
import 'package:kulinere/providers/restaurant_list_provider.dart';
import 'package:kulinere/providers/restaurant_search_provider.dart';
import 'package:kulinere/providers/user_profile_provider.dart';
import 'package:kulinere/screens/splash/splash_screen.dart';

void main() {
  runApp(const KulinereApp());
}

/// Root application widget with provider configuration.
class KulinereApp extends StatelessWidget {
  const KulinereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantListProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantDetailProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantSearchProvider(ctx.read<ApiService>()),
        ),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Kulinere',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
```

---

## Fase 7: Polish

### Final Checklist

```bash
# 1. Jalankan analyzer
dart analyze

# 2. Format code
dart format .

# 3. Test di device
flutter run
```

### Kriteria Wajib ✅
- [ ] Halaman daftar restoran dari API
- [ ] Halaman detail restoran dengan menu & review
- [ ] Theme light/dark dengan font custom
- [ ] Loading indicator
- [ ] State management dengan Provider + sealed classes

### Kriteria Tambahan ✅
- [ ] Clean code (no dead comments)
- [ ] Error widget dengan retry
- [ ] Hero animation
- [ ] Search dengan debounce
- [ ] Review form dengan POST

---

## 📌 Urutan File Lengkap

| No | Path | Deskripsi |
|----|------|-----------|
| 1 | `pubspec.yaml` | Dependencies |
| 2 | `analysis_options.yaml` | Lint rules |
| 3 | `lib/core/constants/api_constants.dart` | API URLs |
| 4 | `lib/core/theme/app_colors.dart` | Color palette |
| 5 | `lib/core/theme/app_typography.dart` | Font styles |
| 6 | `lib/core/theme/app_theme.dart` | Theme config |
| 7 | `lib/core/utils/debouncer.dart` | Search debounce |
| 8 | `lib/data/models/customer_review.dart` | Review model |
| 9 | `lib/data/models/menu_item.dart` | Menu models |
| 10 | `lib/data/models/restaurant.dart` | Restaurant model |
| 11 | `lib/data/models/restaurant_detail.dart` | Detail model |
| 12 | `lib/data/models/api_response.dart` | Response wrappers |
| 13 | `lib/data/api/api_service.dart` | HTTP service |
| 14 | `lib/states/restaurant_list_state.dart` | List states |
| 15 | `lib/states/restaurant_detail_state.dart` | Detail states |
| 16 | `lib/states/restaurant_search_state.dart` | Search states |
| 17 | `lib/providers/restaurant_list_provider.dart` | List provider |
| 18 | `lib/providers/restaurant_detail_provider.dart` | Detail provider |
| 19 | `lib/providers/restaurant_search_provider.dart` | Search provider |
| 20 | `lib/providers/bookmark_provider.dart` | Bookmark provider |
| 21 | `lib/providers/navigation_provider.dart` | Nav provider |
| 22 | `lib/providers/user_profile_provider.dart` | Profile provider |
| 23 | `lib/widgets/loading_widget.dart` | Loading UI |
| 24 | `lib/widgets/error_widget.dart` | Error UI |
| 25 | `lib/widgets/cached_image.dart` | Image caching |
| 26 | `lib/widgets/profile_avatar.dart` | Avatar widget |
| 27 | `lib/screens/splash/splash_screen.dart` | Splash |
| 28 | `lib/screens/main/main_screen.dart` | Main container |
| 29 | `lib/screens/home/home_screen.dart` | Home |
| 30 | `lib/screens/home/widgets/restaurant_card.dart` | Card widget |
| 31 | `lib/screens/search/search_screen.dart` | Search |
| 32 | `lib/screens/bookmark/bookmark_screen.dart` | Bookmarks |
| 33 | `lib/screens/profile/profile_screen.dart` | Profile |
| 34 | `lib/screens/detail/detail_screen.dart` | Detail |
| 35 | `lib/screens/detail/widgets/restaurant_header.dart` | Header |
| 36 | `lib/screens/detail/widgets/menu_section.dart` | Menu |
| 37 | `lib/screens/detail/widgets/review_section.dart` | Reviews |
| 38 | `lib/screens/detail/widgets/review_form.dart` | Form |
| 39 | `lib/main.dart` | Entry point (LAST!) |

---

**Selamat belajar!** 🚀 Ketik semua kode sendiri untuk membangun muscle memory.
