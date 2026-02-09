# Restaurant App Implementation Guide

**Version:** 1.0  
**Based on:** Tourism App Implementation + Product Requirement Document  
**Target SDK:** Flutter 3.9.x / Dart 3.x  
**Last Updated:** January 2026

---

## Related Documents

| Document | Path | Description |
|----------|------|-------------|
| Product Requirement Document | [product_requirement.MD](./product_requirement.MD) | Berisi spesifikasi lengkap fitur, kriteria wajib/tambahan, dan **dokumentasi API lengkap** (endpoints, request/response examples, image URLs) |
| Implementation Guide | (dokumen ini) | Panduan teknis implementasi dengan code patterns dan best practices |

> **Note:** Untuk dokumentasi API yang lengkap (endpoints, contoh JSON response, format URL gambar), silakan rujuk ke [product_requirement.MD](./product_requirement.MD) bagian **Resources**.

---

## Table of Contents

1. [Overview](#overview)
2. [Lessons from Tourism App Implementation](#lessons-from-tourism-app-implementation)
3. [Project Architecture](#project-architecture)
4. [Mandatory Features](#mandatory-features)
5. [Additional Features](#additional-features)
6. [Recommended Code Patterns](#recommended-code-patterns)
7. [UI/UX Guidelines](#uiux-guidelines)
8. [API Integration](#api-integration)
9. [Dependencies](#dependencies)
10. [Implementation Checklist](#implementation-checklist)
11. [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)
12. [Roadmap for Next Iterations](#roadmap-for-next-iterations)

---

## Overview

### Objective
Build a user-centered Restaurant App with minimalist design, using Provider for state management, sealed classes for API state handling, and modular widget architecture. The app should be production-ready, cross-platform compatible (iOS/Android), and follow Flutter best practices.

### Core Principles
- **User-Centered Design:** Prioritize intuitive navigation and clean visual hierarchy
- **Minimalist Aesthetics:** Avoid excessive gradients, shadows, or decorative elements
- **Modular Architecture:** Separation of concerns between data, domain, and presentation layers
- **Type-Safe State Management:** Use sealed classes for exhaustive pattern matching
- **Performance First:** Implement caching, lazy loading, and efficient widget builds

---

## Lessons from Tourism App Implementation

### What Worked Well

#### 1. Sealed Classes for API States
The tourism_app implementation uses sealed classes effectively for handling asynchronous states:

```dart
sealed class RestaurantListResultState {}
class RestaurantListNoneState extends RestaurantListResultState {}
class RestaurantListLoadingState extends RestaurantListResultState {}
class RestaurantListErrorState extends RestaurantListResultState {
  final String error;
  RestaurantListErrorState(this.error);
}
class RestaurantListLoadedState extends RestaurantListResultState {
  final List<Restaurant> data;
  RestaurantListLoadedState(this.data);
}
```

**Benefits:**
- Compile-time exhaustiveness checking with `switch` expressions
- Clear separation of states (None, Loading, Error, Loaded)
- Type-safe data access in each state

#### 2. Provider Architecture with Dependency Injection
The tourism_app correctly injects `ApiServices` into providers:

```dart
MultiProvider(
  providers: [
    Provider(create: (context) => ApiServices()),
    ChangeNotifierProvider(
      create: (context) => RestaurantListProvider(context.read<ApiServices>()),
    ),
  ],
)
```

**Benefits:**
- Testable providers (can inject mock services)
- Single source of truth for API service instance
- Clean dependency graph

#### 3. Modular Widget Structure
Widgets are separated by responsibility:
- `RestaurantCard` - Reusable list item widget
- `BodyOfDetailScreenWidget` - Detail content separated from screen logic
- `BookmarkIconWidget` - Isolated bookmark functionality

### Areas Improved in This Guide

| Tourism App Issue | Restaurant App Solution |
|-------------------|------------------------|
| Commented-out legacy code | Clean code without dead comments |
| Missing Hero animation | Hero animation on images |
| Basic Image.network | CachedNetworkImage with placeholder |
| No search functionality | Debounced search with dedicated screen |
| No retry mechanism | Error state with retry button |
| Hardcoded error messages | User-friendly localized messages |

---

## Project Architecture

### Recommended Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_typography.dart
│   └── utils/
│       └── debouncer.dart
├── data/
│   ├── api/
│   │   └── api_service.dart
│   └── models/
│       ├── restaurant.dart
│       ├── restaurant_detail.dart
│       ├── menu_item.dart
│       ├── customer_review.dart
│       └── api_response.dart
├── providers/
│   ├── restaurant_list_provider.dart
│   ├── restaurant_detail_provider.dart
│   ├── restaurant_search_provider.dart
│   ├── bookmark_provider.dart
│   └── navigation_provider.dart
├── states/
│   ├── restaurant_list_state.dart
│   ├── restaurant_detail_state.dart
│   └── restaurant_search_state.dart
├── screens/
│   ├── main/
│   │   └── main_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       └── restaurant_card.dart
│   ├── detail/
│   │   ├── detail_screen.dart
│   │   └── widgets/
│   │       ├── restaurant_header.dart
│   │       ├── menu_section.dart
│   │       ├── review_section.dart
│   │       └── review_form.dart
│   ├── search/
│   │   └── search_screen.dart
│   └── bookmark/
│       └── bookmark_screen.dart
└── widgets/
    ├── error_widget.dart
    ├── loading_widget.dart
    └── cached_image.dart
```

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                           │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │  Home   │ │ Detail  │ │ Search  │ │Bookmark │       │
│  │ Screen  │ │ Screen  │ │ Screen  │ │ Screen  │       │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘       │
│       │           │           │           │             │
│       └───────────┴───────────┴───────────┘             │
│                         │                               │
│                   Consumer<T>                           │
└─────────────────────────┬───────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────┐
│                   Provider Layer                        │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐    │
│  │ ListProvider │ │DetailProvider│ │SearchProvider│    │
│  │              │ │              │ │              │    │
│  │ ResultState  │ │ ResultState  │ │ ResultState  │    │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘    │
│         │                │                │             │
│         └────────────────┴────────────────┘             │
│                          │                              │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────┴──────────────────────────────┐
│                    Data Layer                           │
│  ┌─────────────────────────────────────────────┐       │
│  │               ApiService                     │       │
│  │  - getRestaurantList()                       │       │
│  │  - getRestaurantDetail(id)                   │       │
│  │  - searchRestaurant(query)                   │       │
│  │  - addReview(id, name, review)               │       │
│  └─────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────┘
```

---

## Mandatory Features

### 1. Restaurant List Screen

**Requirements:**
- Display scrollable list of restaurants from API
- Each item shows: name, image, city, rating
- Use `ListView.builder` for efficient rendering
- Hero animation on restaurant image

**Implementation Notes:**
```dart
// Use pattern matching with sealed class
return switch (provider.resultState) {
  RestaurantListLoadingState() => const LoadingWidget(),
  RestaurantListLoadedState(data: var restaurants) => ListView.builder(
    itemCount: restaurants.length,
    itemBuilder: (context, index) => RestaurantCard(
      restaurant: restaurants[index],
      onTap: () => _navigateToDetail(restaurants[index].id),
    ),
  ),
  RestaurantListErrorState(error: var message) => ErrorWidget(
    message: message,
    onRetry: () => provider.fetchRestaurantList(),
  ),
  _ => const SizedBox(),
};
```

### 2. Restaurant Detail Screen

**Requirements:**
- Display: name, large image, description, city, address, rating
- Show food and drink menus in organized sections
- Display customer reviews
- Form to add new review (POST to API)

**Data Structure:**
```dart
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
}

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;
}
```

### 3. Theme System

**Light and Dark Theme:**
```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primary,
    textTheme: AppTypography.textTheme,
    appBarTheme: _appBarTheme(Brightness.light),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: AppColors.primary,
    textTheme: AppTypography.textTheme,
    appBarTheme: _appBarTheme(Brightness.dark),
  );
}
```

**Custom Font Integration (pubspec.yaml):**
```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

### 4. Loading Indicator

**Centralized Loading Widget:**
```dart
class LoadingWidget extends StatelessWidget {
  final String? message;
  
  const LoadingWidget({super.key, this.message});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
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

### 5. State Management with Provider

**Provider Registration:**
```dart
void main() {
  runApp(
    MultiProvider(
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
      ],
      child: const RestaurantApp(),
    ),
  );
}
```

---

## Additional Features

### 1. Clean Code Standards

**Checklist:**
- [ ] Remove all commented-out code
- [ ] Remove unused imports (use `flutter analyze`)
- [ ] Consistent 2-space indentation
- [ ] Run `dart format .` before commits
- [ ] Follow naming conventions (camelCase for variables, PascalCase for classes)

### 2. Error Handling

**User-Friendly Error Widget:**
```dart
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
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

### 3. Hero Animation

**Implementation:**
```dart
// In RestaurantCard (list item)
Hero(
  tag: 'restaurant-image-${restaurant.id}',
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: CachedNetworkImage(
      imageUrl: restaurant.imageUrl,
      fit: BoxFit.cover,
      width: 100,
      height: 80,
    ),
  ),
)

// In DetailScreen (destination)
Hero(
  tag: 'restaurant-image-${restaurant.id}',
  child: CachedNetworkImage(
    imageUrl: restaurant.largeImageUrl,
    fit: BoxFit.cover,
    width: double.infinity,
    height: 250,
  ),
)
```

### 4. Search Functionality

**Debouncer Utility:**
```dart
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

**Search Screen Implementation:**
```dart
class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer();
  
  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }
  
  void _onSearchChanged(String query) {
    _debouncer.run(() {
      if (query.isNotEmpty) {
        context.read<RestaurantSearchProvider>().searchRestaurants(query);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Cari restoran...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
          autofocus: true,
        ),
      ),
      body: Consumer<RestaurantSearchProvider>(
        builder: (context, provider, child) {
          return switch (provider.resultState) {
            SearchLoadingState() => const LoadingWidget(),
            SearchLoadedState(data: var results) => ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) => RestaurantCard(restaurant: results[i]),
            ),
            SearchErrorState(error: var msg) => AppErrorWidget(
              message: msg,
              onRetry: () => _onSearchChanged(_controller.text),
            ),
            _ => const Center(child: Text('Ketik untuk mencari restoran')),
          };
        },
      ),
    );
  }
}
```

### 5. Review Feature

**Review Form Widget:**
```dart
class ReviewForm extends StatefulWidget {
  final String restaurantId;
  final VoidCallback onSubmitted;
  
  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;
  
  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      await context.read<RestaurantDetailProvider>().addReview(
        id: widget.restaurantId,
        name: _nameController.text,
        review: _reviewController.text,
      );
      
      _nameController.clear();
      _reviewController.clear();
      widget.onSubmitted();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review berhasil dikirim!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim review: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Tulis Review', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
            validator: (v) => v?.isEmpty == true ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _reviewController,
            decoration: const InputDecoration(
              labelText: 'Review',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (v) => v?.isEmpty == true ? 'Review wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isSubmitting ? null : _submitReview,
            child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kirim Review'),
          ),
        ],
      ),
    );
  }
}
```

---

## UI/UX Guidelines

### Design Principles

1. **Whitespace:** Use consistent padding (16dp for screen edges, 8dp between elements)
2. **Typography Hierarchy:** Clear distinction between headings, body, and labels
3. **Color Palette:** Neutral backgrounds, single accent color, avoid gradients
4. **Touch Targets:** Minimum 48x48dp for interactive elements
5. **Feedback:** Loading states, success/error messages, haptic feedback

### Responsive Design

**Avoid Overflow:**
```dart
// Use Expanded for flexible content
Row(
  children: [
    Image(...),
    const SizedBox(width: 12),
    Expanded(  // Prevents overflow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            restaurant.city,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  ],
)
```

**Scrollable Content:**
```dart
// Always wrap potentially long content
SingleChildScrollView(
  child: Column(
    children: [
      // Header image
      // Restaurant info
      // Menu sections
      // Reviews
    ],
  ),
)
```

### Accessibility

```dart
// Use Semantics for screen readers
Semantics(
  label: 'Restoran ${restaurant.name}, rating ${restaurant.rating}',
  child: RestaurantCard(...),
)

// High contrast colors for text
// Minimum font size 12sp for body text
// Support for system font scaling
```

---

## API Integration

> **Referensi Lengkap:** Untuk dokumentasi API yang detail (endpoints, contoh request/response JSON, format URL gambar), lihat [product_requirement.MD - Resources](./product_requirement.MD#resources).

### Base Configuration

```dart
class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  
  String getImageUrl(String pictureId, {ImageSize size = ImageSize.medium}) {
    return '$_baseUrl/images/${size.name}/$pictureId';
  }
}

enum ImageSize { small, medium, large }
```

### Endpoints Overview

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/list` | GET | Get all restaurants |
| `/detail/:id` | GET | Get restaurant detail |
| `/search?q=:query` | GET | Search restaurants |
| `/review` | POST | Add new review |

*Lihat [product_requirement.MD](./product_requirement.MD) untuk contoh response JSON lengkap.*

### API Service Implementation

```dart
class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  
  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat daftar restoran');
    }
  }
  
  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail restoran');
    }
  }
  
  Future<SearchResponse> searchRestaurants(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}'),
    );
    
    if (response.statusCode == 200) {
      return SearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mencari restoran');
    }
  }
  
  Future<ReviewResponse> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'name': name, 'review': review}),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengirim review');
    }
  }
}
```

---

## Dependencies

### Required Packages (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.5
  
  # Networking
  http: ^1.6.0
  
  # Image Caching
  cached_network_image: ^3.3.1
  
  # Fonts (optional - if using Google Fonts)
  google_fonts: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

### Optional Packages for Enhanced Features

```yaml
dependencies:
  # Animation
  lottie: ^3.1.0  # For loading animations
  
  # Local Storage (for favorites/bookmarks persistence)
  shared_preferences: ^2.2.3
  
  # Connectivity Check
  connectivity_plus: ^6.0.3
```

---

## Implementation Checklist

### Phase 1: Foundation
- [ ] Create project structure following architecture diagram
- [ ] Set up theme system (light/dark, custom fonts, colors)
- [ ] Implement ApiService with all endpoints
- [ ] Create data models (Restaurant, RestaurantDetail, etc.)
- [ ] Create sealed classes for all API states

### Phase 2: Core Screens
- [ ] Implement RestaurantListProvider with state management
- [ ] Create HomeScreen with restaurant list
- [ ] Create RestaurantCard widget with Hero animation
- [ ] Implement RestaurantDetailProvider
- [ ] Create DetailScreen with all sections
- [ ] Add loading and error widgets

### Phase 3: Additional Features
- [ ] Implement search functionality with debounce
- [ ] Create SearchScreen
- [ ] Add review list display
- [ ] Implement review form with POST
- [ ] Add bookmark functionality

### Phase 4: Polish
- [ ] Add Hero animations throughout
- [ ] Implement CachedNetworkImage
- [ ] Test on iOS and Android
- [ ] Run `flutter analyze` and fix issues
- [ ] Format code with `dart format .`
- [ ] Remove all debug prints and commented code

---

## Common Pitfalls and Solutions

### 1. State Not Updating in UI
**Problem:** `notifyListeners()` called but UI doesn't rebuild  
**Solution:** Ensure widget uses `Consumer<T>` or `context.watch<T>()`

### 2. Switch Expression Not Exhaustive
**Problem:** Compiler warning about missing cases  
**Solution:** Add catch-all case `_ => const SizedBox()` for `NoneState`

### 3. Duplicate Switch Cases
**Problem:** Two identical state types in switch (causes wrong behavior)  
**Solution:** Carefully check state class names (LoadingState vs LoadedState)

### 4. Missing ID in API URL
**Problem:** Detail API returns error  
**Solution:** Ensure URL is `$baseUrl/detail/$id` not just `$baseUrl/detail`

### 5. Image Overflow
**Problem:** Large images break layout  
**Solution:** Wrap in `ConstrainedBox` or use `fit: BoxFit.cover`

### 6. Text Overflow
**Problem:** Long text pushes widgets off-screen  
**Solution:** Use `Expanded` wrapper and `TextOverflow.ellipsis`

---

## Roadmap for Next Iterations

### Version 1.1 (Short-term)
- [ ] Add pull-to-refresh on list screen
- [ ] Implement offline mode with local caching
- [ ] Add restaurant categories filter
- [ ] Implement favorites persistence with SharedPreferences

### Version 1.2 (Medium-term)
- [ ] Add location-based sorting
- [ ] Implement image gallery in detail screen
- [ ] Add share restaurant feature
- [ ] Implement push notifications for new restaurants

### Version 2.0 (Long-term)
- [ ] User authentication
- [ ] User profile management
- [ ] Restaurant reservation feature
- [ ] Integration with maps for directions
- [ ] Unit and widget tests coverage > 80%

---

## Quick Reference

### Sealed Class Pattern
```dart
sealed class State {}
class LoadingState extends State {}
class LoadedState extends State { final T data; }
class ErrorState extends State { final String error; }
```

### Provider Pattern
```dart
// Read once
context.read<Provider>().method();

// Watch for changes
context.watch<Provider>().property;

// Consumer widget
Consumer<Provider>(builder: (ctx, value, child) => ...)
```

### Image URL Helper
```dart
String getImageUrl(String pictureId) =>
  'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
```

---

### Checkpoint
```
┌─────────────────────────────────────────────────────────┐
│               PHASE 1: Foundation + Core                │
│  Project structure, theme, API, models, providers       │
│  HomeScreen, DetailScreen, Loading/Error widgets        │
│                                                         │
│              ▼ [CHECKPOINT: Review] ▼                   │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│             PHASE 2: Features + Polish                  │
│  Search, Review form, Bookmark, Hero animation          │
│  Clean code, testing, final verification                │
└─────────────────────────────────────────────────────────┘
```
**Document End**

