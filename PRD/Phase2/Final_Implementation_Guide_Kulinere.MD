# Final Implementation Guide: Kulinere Phase 2

**Version:** 2.0  
**Based on:** PRD Phase 2 + 7 Use Case Projects Analysis  
**Target:** Production-Ready Restaurant App with Persistence, Notifications & Testing  
**Last Updated:** February 2026

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [⚠️ Forbidden Conditions (REJECTION CRITERIA)](#-forbidden-conditions-rejection-criteria)
3. [UI Reference & Mockup Analysis](#ui-reference--mockup-analysis)
4. [Lessons Learned from Use Cases](#lessons-learned-from-use-cases)
5. [Updated Requirements](#updated-requirements)
6. [Step-by-Step Implementation Plan](#step-by-step-implementation-plan)
7. [Testing Strategy](#testing-strategy)
8. [Potential Pitfalls & Solutions](#potential-pitfalls--solutions)

---

## Project Overview

### Objective
Enhance **Kulinere** restaurant app with:
- **SQLite-based favorites** for persistent bookmark storage
- **SharedPreferences** for theme and reminder toggle persistence
- **Daily reminder notifications** at 11:00 AM with random restaurant recommendation
- **Comprehensive testing** (6+ test cases across unit/widget/integration)

### Preservation Principles
All existing Phase 1 features remain intact:
- Restaurant list, detail, search, and review functionality
- Provider-based state management with sealed classes
- Hero animations, caching, error handling
- Light/Dark theme with Playfair Display + Inter fonts

---

## ⚠️ Forbidden Conditions (REJECTION CRITERIA)

> [!CAUTION]
> Your project will be **REJECTED** if it doesn't meet the following criteria. Check carefully before submission!

### General Criteria
| ❌ Forbidden | ✅ Required Action |
|-------------|------------------------|
| Not maintaining Phase 1 features | All list, detail, search, review features must remain functional |
| Not following specified criteria | Follow every point in the PRD precisely |

### Favorites Page Criteria
| ❌ Forbidden | ✅ Required Action |
|-------------|------------------------|
| Not using SQLite | **MUST** use `sqflite` for local storage |
| Data not immediately visible after adding | Call `loadFavorites()` after `addFavorite()` and call `notifyListeners()` |
| Duplicate items on favorites page | Use `id TEXT PRIMARY KEY` and `ConflictAlgorithm.replace` |
| Cannot open detail from favorites | Ensure `onTap` navigates to `DetailScreen` with `restaurant.id` |

### Theme Settings Criteria
| ❌ Forbidden | ✅ Required Action |
|-------------|------------------------|
| Not using SharedPreferences | **MUST** use `shared_preferences` for persistence |
| No theme settings menu | Create `SettingsScreen` with theme toggle (see UI Reference) |
| Theme doesn't persist on app restart | Load preferences in `main()` **BEFORE** `runApp()` |

### Testing Criteria
| ❌ Forbidden | ✅ Required Action |
|-------------|------------------------|
| Test description doesn't represent feature | Test name **MUST** be clear: `'should return empty list when no favorites'` |
| Test file outside `test/` folder | Place in `test/` parallel to `lib/` |
| File name doesn't end with `_test.dart` | Example: `favorites_provider_test.dart` |

---

## UI Reference & Mockup Analysis

Based on the visual reference (`PRD/Phase2/referensi.jpeg`), here are the 4 main screens to implement:

### 1. Restaurant Detail with Favorite Button
```
┌─────────────────────────────┐
│  [Header Image - Restaurant] │
│                         ♡   │  ← Favorite button (heart icon)
│  Restaurant Name            │
│  📍 Location                │
│  ────────────────────────── │
│  Description...             │
│  ┌─────┐ ┌─────┐            │
│  │Menu │ │Menu │            │
│  └─────┘ └─────┘            │
└─────────────────────────────┘
```
**Implementation:**
- Button `♡` (empty) → add to favorites
- Button `♥` (filled) → remove from favorites
- Position: overlay on header image

### 2. Favorites List Screen
```
┌─────────────────────────────┐
│  Favorites              🔍  │
│ ─────────────────────────── │
│ ┌─────┐ Restaurant 1        │
│ │ Img │ 📍 Location         │
│ └─────┘ ⭐ 4.6               │
│ ─────────────────────────── │
│ ┌─────┐ Restaurant 2        │
│ │ Img │ 📍 Location         │
│ └─────┘ ⭐ 4.6               │
└─────────────────────────────┘
```
**Implementation:**
- `ListView.builder` from `FavoritesProvider.favorites`
- Each item navigates to `DetailScreen`
- Empty state when no favorites exist

### 3. Daily Reminder Notification
```
┌─────────────────────────────┐
│   ○ ○ ○ ○ ○ ○               │  ← App indicators
│ ┌─────────────────────────┐ │
│ │ ✓  Restaurant 1         │ │
│ │    Recommendation for   │ │
│ │    you                  │ │
│ └─────────────────────────┘ │
│                             │
└─────────────────────────────┘
```
**Implementation:**
- Appears at 11:00 AM daily
- Body: random restaurant name from API
- Tap notification → open app

### 4. Settings Screen
```
┌─────────────────────────────┐
│  Setting               🔍   │
│ ─────────────────────────── │
│  Restaurant Notification    │
│  Enable notification   [◯]  │  ← Toggle switch
│                             │
│  Theme                      │  ← Optional: theme toggle
│  Dark Mode            [◯]   │
│                             │
└─────────────────────────────┘
```
**Implementation:**
- `SwitchListTile` for reminder toggle
- Boolean value persists to SharedPreferences
- When toggle ON → schedule notification
- When toggle OFF → cancel notification

---

## Phase 1 Current State Analysis

> [!IMPORTANT]
> This section documents the **actual** Phase 1 implementation to ensure accurate Phase 2 changes.

### Existing Project Structure

```
lib/
├── core/
│   ├── constants/api_constants.dart
│   ├── theme/
│   │   ├── app_colors.dart      ← ✅ Has gold (#f3d396), goldDark (#C9A86C)
│   │   ├── app_theme.dart       ← ✅ Has lightTheme, darkTheme
│   │   └── app_typography.dart
│   └── utils/
├── data/
│   ├── api/api_service.dart
│   └── models/
│       ├── restaurant.dart       ← ✅ Has id, name, city, rating, pictureId
│       ├── restaurant_detail.dart
│       └── ...
├── providers/
│   ├── bookmark_provider.dart    ← ⚠️ IN-MEMORY Set (needs SQLite)
│   ├── navigation_provider.dart
│   ├── restaurant_list_provider.dart
│   ├── restaurant_detail_provider.dart
│   ├── restaurant_search_provider.dart
│   └── user_profile_provider.dart
├── screens/
│   ├── bookmark/bookmark_screen.dart  ← ⚠️ Filters from API state, not DB
│   ├── detail/
│   ├── home/
│   ├── main/
│   ├── profile/
│   ├── search/
│   └── splash/
├── states/
│   └── restaurant_list_state.dart  ← ✅ Sealed class pattern
├── widgets/
└── main.dart                       ← ⚠️ ThemeMode.system hardcoded
```

### What Needs to Change for Phase 2

| Component | Current State | Required Change |
|-----------|---------------|-----------------|
| `BookmarkProvider` | In-memory `Set<String>` | Replace with SQLite backed storage |
| `BookmarkScreen` | Filters from `RestaurantListProvider.state` | Read directly from `FavoritesProvider.favorites` |
| `main.dart` | `ThemeMode.system` hardcoded | Wire to `SettingsProvider.themeMode` |
| Settings | None | Create `SettingsScreen` with toggles |
| Notifications | None | Create `NotificationService` |

### What to Add (New Files)

| Path | Purpose |
|------|---------|
| `lib/core/database/favorites_database_service.dart` | SQLite CRUD operations |
| `lib/core/preferences/preferences_service.dart` | SharedPreferences wrapper |
| `lib/core/notifications/notification_service.dart` | Flutter Local Notifications |
| `lib/providers/favorites_provider.dart` | Replace BookmarkProvider |
| `lib/providers/settings_provider.dart` | Theme + reminder toggle |
| `lib/screens/settings/settings_screen.dart` | Settings UI |
| `test/providers/favorites_provider_test.dart` | Unit tests |
| `test/providers/settings_provider_test.dart` | Unit tests |

### What to Keep Unchanged

| Component | Why Keep |
|-----------|----------|
| `Restaurant` model | Already has correct fields (id, name, city, rating, pictureId) |
| `AppColors` | Already has gold, goldDark, semantic colors |
| `AppTheme` | Already has lightTheme, darkTheme |
| `RestaurantCard` widget | Reuse for favorites list |
| `DetailScreen` | Just add heart button overlay |
| Sealed state classes | Keep for API state management |

### Migration Strategy for BookmarkProvider → FavoritesProvider

```dart
// BEFORE (Phase 1) - BookmarkProvider uses memory
class BookmarkProvider extends ChangeNotifier {
  final Set<String> _bookmarkedIds = {};
  bool isBookmarked(String id) => _bookmarkedIds.contains(id);
  void toggleBookmark(String id) { /* ... */ }
}

// AFTER (Phase 2) - FavoritesProvider uses SQLite
class FavoritesProvider extends ChangeNotifier {
  final FavoritesDatabaseService _dbService;
  List<Restaurant> _favorites = [];
  
  Future<void> loadFavorites() async {
    _favorites = await _dbService.getAllFavorites();
    notifyListeners();
  }
  
  bool isFavorite(String id) => _favorites.any((r) => r.id == id);
  
  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (isFavorite(restaurant.id)) {
      await _dbService.delete(restaurant.id);
    } else {
      await _dbService.insert(restaurant);
    }
    await loadFavorites(); // Refresh from DB
  }
}
```

### Code Compatibility Notes

| Aspect | Compatibility |
|--------|--------------|
| `Consumer<BookmarkProvider>` | Replace with `Consumer<FavoritesProvider>` |
| `isBookmarked(id)` | Replace with `isFavorite(id)` |
| `toggleBookmark(id)` | Replace with `toggleFavorite(restaurant)` |
| `bookmarkedIds` | Replace with `favorites` (List<Restaurant>) |

---

## Lessons Learned from Use Cases

### 1. tourism_app — SQLite Favorites (Primary Reference)

**Folder:** `lib/local/local_database_service.dart` + `lib/bookmark/local_database_provider.dart`

| Pattern | Implementation |
|---------|----------------|
| **Service-Provider Separation** | `LocalDatabaseService` handles raw CRUD, `LocalDatabaseProvider` wraps with ChangeNotifier |
| **Lazy DB Initialization** | `_initializeDb()` opens DB on-demand, avoids global singleton issues |
| **Schema Creation** | Uses `onCreate` callback with raw SQL in `createTables()` |
| **Conflict Handling** | `ConflictAlgorithm.replace` for upsert behavior |
| **Async Error Handling** | Try-catch in provider methods with user-friendly `_message` state |

**Key Code Pattern:**
```dart
// Service (data layer)
class LocalDatabaseService {
  Future<int> insertItem(Favorite fav) async {
    final db = await _initializeDb();
    return db.insert(_tableName, fav.toJson(), 
      conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

// Provider (business layer)
class FavoriteProvider extends ChangeNotifier {
  final LocalDatabaseService _service;
  List<Favorite>? _favorites;
  
  Future<void> loadFavorites() async {
    try {
      _favorites = await _service.getAllItems();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
```

**Adopted for Kulinere:**
- Same service/provider split for `FavoritesDatabaseService` and `FavoritesProvider`
- Schema: `favorites(id TEXT PRIMARY KEY, name, city, rating REAL, pictureId)`

---

### 2. sqflite_exercise — Advanced Database Patterns

**Folder:** `lib/provider/local_database_provider.dart`

| Enhancement | Benefit |
|-------------|---------|
| Singleton database instance | Prevents multiple DB connections |
| `path` package usage | Cross-platform database path resolution |
| Migration support | `onUpgrade` callback for schema evolution |

**Adopted for Kulinere:**
- Use `path` package for `getDatabasesPath()`
- Prepare migration scaffold for future schema changes

---

### 3. shared_preferences — Settings Persistence

**Folder:** `lib/services/shared_preferences_service.dart`

| Pattern | Implementation |
|---------|----------------|
| **Injected SharedPreferences** | Constructor receives `SharedPreferences` instance (testable!) |
| **Typed Getters/Setters** | `getBool()`, `setInt()`, `getString()` with defaults |
| **Model-based Settings** | `Setting` class bundles multiple preferences |

**Key Code Pattern:**
```dart
class SharedPreferencesService {
  final SharedPreferences _preferences;
  
  SharedPreferencesService(this._preferences);
  
  static const String _keyTheme = "THEME_MODE";
  static const String _keyReminder = "DAILY_REMINDER";
  
  ThemeMode getThemeMode() {
    final value = _preferences.getString(_keyTheme) ?? 'system';
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setString(_keyTheme, mode.name);
  }
}
```

**Adopted for Kulinere:**
- `PreferencesService` for theme mode and reminder toggle
- Injected in `main.dart` after `SharedPreferences.getInstance()`

---

### 4. notification_app — Scheduled Notifications

**Folder:** `lib/services/local_notification_service.dart`

| Feature | Implementation |
|---------|----------------|
| **Timezone Configuration** | `flutter_timezone` + `timezone` package for accurate scheduling |
| **Permission Handling** | Separate methods for Android/iOS with fallback |
| **Scheduled Notifications** | `zonedSchedule()` with `DateTimeComponents.time` for daily repeat |
| **Stream-based Payload** | `StreamController` broadcasts notification taps |

**Key Code Pattern:**
```dart
Future<void> scheduleDailyNotification({required int id}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id: id,
    title: 'Waktunya makan siang!',
    body: 'Coba kunjungi restoran hari ini',
    scheduledDate: _nextInstanceOfElevenAM(),
    notificationDetails: notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // Daily repeat
  );
}

tz.TZDateTime _nextInstanceOfElevenAM() {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}
```

**Adopted for Kulinere:**
- `NotificationService` with timezone setup at app launch
- 11:00 AM daily schedule with random restaurant from API

---

### 5. firebase_exercise — Clean Architecture

| Takeaway | Application |
|----------|-------------|
| Model/Service/Provider structure | Consistent layer separation |
| Error handling in services | Throw exceptions, catch in providers |
| Provider initialization order | Critical services first in MultiProvider |

---

### 6. file_app — Platform-Specific Handling

| Takeaway | Application |
|----------|-------------|
| Permission handling | Graceful degradation if permission denied |
| Path resolution | Use `path_provider` for cross-platform paths |

---

### 7. calculator_app — Testing Patterns

| Takeaway | Application |
|----------|-------------|
| Service isolation | Pure functions in services enable easy unit testing |
| Provider testing | Mock services, verify state changes |

---

## Updated Requirements

### Feature Matrix

| Feature | Storage | Package | Priority |
|---------|---------|---------|----------|
| Favorites | SQLite | `sqflite`, `path` | P0 |
| Theme Persistence | SharedPreferences | `shared_preferences` | P0 |
| Reminder Toggle | SharedPreferences | `shared_preferences` | P0 |
| Daily Notification | Scheduled | `flutter_local_notifications`, `flutter_timezone`, `timezone` | P1 |
| Random Restaurant in Notification | API + Background | `workmanager`, `http` | P2 |
| Testing | Unit/Widget/Integration | `flutter_test`, `mocktail` | P0 |

### New Folder Structure

```
lib/
├── core/
│   ├── database/
│   │   └── favorites_database_service.dart   // NEW
│   ├── preferences/
│   │   └── preferences_service.dart          // NEW
│   ├── notifications/
│   │   └── notification_service.dart         // NEW
│   └── theme/
│       └── app_theme.dart                    // MODIFIED
├── providers/
│   ├── favorites_provider.dart               // NEW
│   ├── settings_provider.dart                // NEW (theme + reminder)
│   └── ... (existing providers)
├── screens/
│   ├── settings/
│   │   └── settings_screen.dart              // NEW
│   └── ... (existing screens)
└── main.dart                                 // MODIFIED
```

---

## Step-by-Step Implementation Plan

### Phase 2.1: SQLite Favorites (Days 1-2)

**Step 1: Add Dependencies**
```yaml
# pubspec.yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

**Step 2: Create Database Service**

```dart
// lib/core/database/favorites_database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoritesDatabaseService {
  static const String _databaseName = 'kulinere_favorites.db';
  static const String _tableName = 'favorites';
  static const int _version = 1;
  
  Database? _database;
  
  Future<Database> get database async {
    _database ??= await _initializeDb();
    return _database!;
  }
  
  Future<Database> _initializeDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    
    return openDatabase(
      path,
      version: _version,
      onCreate: _createTables,
    );
  }
  
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        city TEXT NOT NULL,
        rating REAL NOT NULL,
        pictureId TEXT NOT NULL
      )
    ''');
  }
  
  Future<int> insertFavorite(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert(_tableName, data, 
      conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await database;
    return db.query(_tableName);
  }
  
  Future<Map<String, dynamic>?> getFavoriteById(String id) async {
    final db = await database;
    final results = await db.query(
      _tableName, 
      where: 'id = ?', 
      whereArgs: [id], 
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }
  
  Future<int> deleteFavorite(String id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
```

**Step 3: Create Favorites Provider**

```dart
// lib/providers/favorites_provider.dart
import 'package:flutter/material.dart';
import 'package:kulinere/core/database/favorites_database_service.dart';
import 'package:kulinere/data/models/restaurant.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesDatabaseService _service;
  
  FavoritesProvider(this._service);
  
  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;
  
  String? _error;
  String? get error => _error;
  
  Future<void> loadFavorites() async {
    try {
      final data = await _service.getAllFavorites();
      _favorites = data.map((json) => Restaurant(
        id: json['id'] as String,
        name: json['name'] as String,
        city: json['city'] as String,
        rating: json['rating'] as double,
        pictureId: json['pictureId'] as String,
        description: '', // Not stored in favorites
      )).toList();
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat favorit';
    }
    notifyListeners();
  }
  
  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await _service.insertFavorite({
        'id': restaurant.id,
        'name': restaurant.name,
        'city': restaurant.city,
        'rating': restaurant.rating,
        'pictureId': restaurant.pictureId,
      });
      await loadFavorites();
    } catch (e) {
      _error = 'Gagal menyimpan favorit';
      notifyListeners();
    }
  }
  
  Future<void> removeFavorite(String id) async {
    try {
      await _service.deleteFavorite(id);
      await loadFavorites();
    } catch (e) {
      _error = 'Gagal menghapus favorit';
      notifyListeners();
    }
  }
  
  bool isFavorite(String id) {
    return _favorites.any((r) => r.id == id);
  }
}
```

**Step 4: Register in main.dart**

```dart
// main.dart additions
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => FavoritesDatabaseService()),
        ChangeNotifierProvider(
          create: (ctx) => FavoritesProvider(ctx.read<FavoritesDatabaseService>()),
        ),
        // ... other providers
      ],
      child: const KulinereApp(),
    ),
  );
}
```

**Step 5: Update Bookmark Screen**

Connect existing `BookmarkScreen` to `FavoritesProvider` instead of in-memory list.

---

### Phase 2.2: Theme & Reminder Persistence (Day 3)

**Step 1: Add Dependency**
```yaml
dependencies:
  shared_preferences: ^2.2.2
```

**Step 2: Create Preferences Service**

```dart
// lib/core/preferences/preferences_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;
  
  PreferencesService(this._prefs);
  
  static const String _keyTheme = 'theme_mode';
  static const String _keyReminder = 'daily_reminder';
  
  ThemeMode getThemeMode() {
    final value = _prefs.getString(_keyTheme);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_keyTheme, mode.name);
  }
  
  bool getDailyReminderEnabled() {
    return _prefs.getBool(_keyReminder) ?? false;
  }
  
  Future<void> setDailyReminderEnabled(bool enabled) async {
    await _prefs.setBool(_keyReminder, enabled);
  }
}
```

**Step 3: Create Settings Provider**

```dart
// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:kulinere/core/preferences/preferences_service.dart';

class SettingsProvider extends ChangeNotifier {
  final PreferencesService _service;
  
  SettingsProvider(this._service) {
    _themeMode = _service.getThemeMode();
    _dailyReminderEnabled = _service.getDailyReminderEnabled();
  }
  
  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  
  late bool _dailyReminderEnabled;
  bool get dailyReminderEnabled => _dailyReminderEnabled;
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _service.setThemeMode(mode);
    notifyListeners();
  }
  
  Future<void> setDailyReminderEnabled(bool enabled) async {
    _dailyReminderEnabled = enabled;
    await _service.setDailyReminderEnabled(enabled);
    notifyListeners();
  }
}
```

**Step 4: Update main.dart**

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => PreferencesService(prefs)),
        ChangeNotifierProvider(
          create: (ctx) => SettingsProvider(ctx.read<PreferencesService>()),
        ),
        // ... other providers
      ],
      child: const KulinereApp(),
    ),
  );
}

class KulinereApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) => MaterialApp(
        themeMode: settings.themeMode, // Dynamic theme mode!
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        // ...
      ),
    );
  }
}
```

---

### Phase 2.3: Daily Reminder Notifications (Days 4-5)

**Step 1: Add Dependencies**
```yaml
dependencies:
  flutter_local_notifications: ^17.2.1
  flutter_timezone: ^1.0.8
  timezone: ^0.9.2
  workmanager: ^0.5.2  # For background task (optional)
```

---

#### 🔧 CRITICAL: Android Platform Configuration

> [!CAUTION]
> **Without these configurations, scheduled notifications will NOT work on Android!**

**Step 1a: Enable Java 8+ Desugaring**

Edit `android/app/build.gradle.kts` (or `build.gradle`):

```kotlin
android {
    // ... existing config
    
    compileOptions {
        // Enable desugaring for Java 8+ features on older Android versions
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    // If using Kotlin:
    kotlinOptions {
        jvmTarget = "11"
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

> [!NOTE]
> **Why desugaring?** The `flutter_local_notifications` package uses Java 8+ time APIs. Desugaring converts these to code that runs on older Android versions (pre-API 26).

**Step 1b: Add Permissions to AndroidManifest.xml**

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Basic Notification Permissions -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.VIBRATE" />
    
    <!-- Scheduled Notification Permissions -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" 
                     android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    
    <application ...>
        <!-- ... existing application content -->
        
        <!-- Notification Receivers (required for scheduled notifications) -->
        <receiver 
            android:exported="false" 
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        
        <receiver 
            android:exported="false" 
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
        
    </application>
</manifest>
```

**Permission Breakdown:**

| Permission | Purpose |
|------------|---------|
| `POST_NOTIFICATIONS` | Required on Android 13+ to show notifications |
| `VIBRATE` | Allow device vibration for notifications |
| `RECEIVE_BOOT_COMPLETED` | Re-schedule notifications after device reboot |
| `SCHEDULE_EXACT_ALARM` | Exact alarms on Android 12 and below |
| `USE_EXACT_ALARM` | Exact alarms on Android 13+ |

**Step 1c: Add Notification Icon**

Create `android/app/src/main/res/drawable/app_icon.png` (24x24 or 48x48, white icon on transparent):
- This is the small icon shown in the status bar
- Use the Kulinere logo silhouette in white

---

**Step 2: Create Notification Service**

```dart
// lib/core/notifications/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('app_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
    
    await _configureTimezone();
  }
  
  Future<void> _configureTimezone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }
  
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final iOS = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      await android.requestExactAlarmsPermission();
      return granted ?? false;
    }
    if (iOS != null) {
      return await iOS.requestPermissions(
        alert: true, badge: true, sound: true,
      ) ?? false;
    }
    return false;
  }
  
  Future<void> scheduleDailyReminder({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder',
        'Daily Reminder',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    
    await _plugin.zonedSchedule(
      0,
      title,
      body,
      _nextElevenAM(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  tz.TZDateTime _nextElevenAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, 11, 0,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
  
  Future<void> cancelReminder() async {
    await _plugin.cancel(0);
  }
}
```

**Step 3: Wire to SettingsProvider**

```dart
// In SettingsProvider
final NotificationService _notificationService;

Future<void> setDailyReminderEnabled(bool enabled) async {
  if (enabled) {
    await _notificationService.requestPermission();
    await _notificationService.scheduleDailyReminder(
      title: 'Lunch time! 🍽️',
      body: 'Try visiting a new restaurant today',
    );
  } else {
    await _notificationService.cancelReminder();
  }
  _dailyReminderEnabled = enabled;
  await _service.setDailyReminderEnabled(enabled);
  notifyListeners();
}
```

---

### Phase 2.4: Random Restaurant in Notification (Bonus)

For enhanced notification with random restaurant from API:

```dart
Future<void> scheduleDailyReminderWithRandomRestaurant() async {
  // Fetch restaurants from API
  final restaurants = await _apiService.getRestaurantList();
  final random = restaurants[Random().nextInt(restaurants.length)];
  
  await scheduleDailyReminder(
    title: 'Waktunya makan siang! 🍽️',
    body: 'Coba kunjungi ${random.name} – Rating ${random.rating}',
  );
}
```

> **Note:** For true background execution, use `workmanager` to fetch fresh data.

---

### Phase 2.5: Testing (Day 6)

See [Testing Strategy](#testing-strategy) section below.

---

## Testing Strategy

### Required: 6+ Test Cases

> [!IMPORTANT]
> **Test names MUST be descriptive** and represent the feature being tested!  
> Bad example: `test('test 1', ...)` ❌  
> Good example: `test('should return empty list when no favorites saved', ...)` ✅

| # | Type | Test Case Description | File |
|---|------|----------------------|------|
| 1 | Unit | should return empty favorites list on initial state | `test/providers/favorites_provider_test.dart` |
| 2 | Unit | should add restaurant to favorites and update list | `test/providers/favorites_provider_test.dart` |
| 3 | Unit | should persist theme mode to SharedPreferences | `test/providers/settings_provider_test.dart` |
| 4 | Unit | should return error state when API call fails | `test/providers/restaurant_list_provider_test.dart` |
| 5 | Widget | should toggle bookmark icon when favorite button tapped | `test/widgets/bookmark_button_test.dart` |
| 6 | Widget | should update theme when toggle switch changed | `test/widgets/settings_screen_test.dart` |
| 7 | Integration | should navigate from list to detail and add to favorites | `integration_test/favorites_flow_test.dart` |

### Testing Best Practices

```
test/                              ← Parallel to lib/
├── providers/
│   ├── favorites_provider_test.dart
│   ├── settings_provider_test.dart
│   └── restaurant_list_provider_test.dart
├── widgets/
│   ├── bookmark_button_test.dart
│   └── settings_screen_test.dart
└── services/
    └── database_service_test.dart

integration_test/
└── favorites_flow_test.dart
```

> [!TIP]
> **For DataStore testing (API/Database), use MOCKING:**
> - Mock `FavoritesDatabaseService` for provider testing
> - Mock `ApiService` for testing without internet connection
> - Documentation: [Mock Dependencies using Mockito](https://docs.flutter.dev/cookbook/testing/unit/mocking)

### Sample Unit Test

```dart
// test/providers/favorites_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements FavoritesDatabaseService {}

void main() {
  late FavoritesProvider provider;
  late MockDatabaseService mockService;
  
  setUp(() {
    mockService = MockDatabaseService();
    provider = FavoritesProvider(mockService);
  });
  
  test('initial favorites list is empty', () {
    expect(provider.favorites, isEmpty);
  });
  
  test('loadFavorites populates list from database', () async {
    when(() => mockService.getAllFavorites()).thenAnswer(
      (_) async => [
        {'id': '1', 'name': 'Test', 'city': 'Jakarta', 'rating': 4.5, 'pictureId': 'abc'},
      ],
    );
    
    await provider.loadFavorites();
    
    expect(provider.favorites.length, 1);
    expect(provider.favorites.first.name, 'Test');
  });
  
  test('loadFavorites sets error on exception', () async {
    when(() => mockService.getAllFavorites()).thenThrow(Exception());
    
    await provider.loadFavorites();
    
    expect(provider.error, isNotNull);
  });
}
```

### Sample Widget Test

```dart
// test/widgets/bookmark_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  testWidgets('bookmark button toggles state', (tester) async {
    final mockProvider = MockFavoritesProvider();
    when(() => mockProvider.isFavorite('1')).thenReturn(false);
    
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<FavoritesProvider>.value(
          value: mockProvider,
          child: BookmarkButton(restaurantId: '1'),
        ),
      ),
    );
    
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    
    await tester.tap(find.byType(IconButton));
    verify(() => mockProvider.addFavorite(any())).called(1);
  });
}
```

---

## Potential Pitfalls & Solutions

| Pitfall | Solution |
|---------|----------|
| **Database not found on iOS** | Use `path` package with `getDatabasesPath()` |
| **Notification not showing on Android 13+** | Request `POST_NOTIFICATIONS` permission |
| **Timezone incorrect** | Initialize `flutter_timezone` before scheduling |
| **Duplicate favorites** | Use `ConflictAlgorithm.replace` in insert |
| **Theme not persisting after restart** | Load preferences in `main()` before `runApp()` |
| **Provider not updating UI** | Ensure `notifyListeners()` is called after state change |
| **Test fails with "Provider not found"** | Wrap widget in `ChangeNotifierProvider` in test setup |
| **Background task not running** | Use `workmanager` with `registerPeriodicTask` |
| **Memory leak in providers** | Dispose subscriptions in `dispose()` method |
| **iOS notification permission denied** | Request permission on first toggle, not on app launch |

---

## Appendix: Package Versions

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  http: ^1.1.0
  cached_network_image: ^3.3.0
  sqflite: ^2.3.0
  path: ^1.8.3
  shared_preferences: ^2.2.2
  flutter_local_notifications: ^17.2.1
  flutter_timezone: ^1.0.8
  timezone: ^0.9.2
  google_fonts: ^6.2.1
  workmanager: ^0.5.2  # For background notification with random restaurant

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.1
  integration_test:
    sdk: flutter
```

---

## Critical Analysis Summary

> [!NOTE]
> See **Phase 1 → Phase 2 Alignment Verification** section below for detailed multi-framework analysis.

| Framework | Key Insight |
|-----------|-------------|
| **Design Thinking** | All user journeys preserved + 3 new features |
| **First Principle** | Same patterns: Provider DI, sealed states, modular folders |
| **Second-Order** | 1 migration (BookmarkProvider → SQLite) + graceful fallbacks |
| **Probabilistic** | 95% compatible, 10% regression risk → mitigate with tests |

---

## Design System Alignment Checklist

| Component | Design System Reference | Implementation Status |
|-----------|------------------------|----------------------|
| **Colors** | Gold (#f3d396, #C9A86C) | ✅ AppColors class exists |
| **Typography** | Playfair Display + Inter | ✅ AppTheme configured |
| **Spacing** | 4dp base unit, 16dp screen padding | ✅ Follow existing patterns |
| **Cards** | 12dp radius, surface color | ✅ Existing RestaurantCard |
| **Settings Toggle** | Material SwitchListTile | ⚠️ Style with gold accent |
| **Favorite Icon** | Heart (♡/♥) in gold | ⚠️ Use AppColors.gold |
| **Empty State** | Centered text + icon | ⚠️ Add to FavoritesScreen |

---

## Phase 1 → Phase 2 Alignment Verification

> [!IMPORTANT]
> This section validates that Phase 2 changes integrate seamlessly with Phase 1 architecture.

### Multi-Framework Thinking Analysis

#### 1. Design Thinking: User Journey Alignment

| User Goal | Phase 1 Solution | Phase 2 Enhancement | Alignment Status |
|-----------|------------------|---------------------|------------------|
| Browse restaurants | `HomeScreen` + `RestaurantCard` | ✅ Keep unchanged | ✅ Compatible |
| View details | `DetailScreen` with Hero | Add heart button overlay | ✅ Compatible |
| Save favorites | `BookmarkProvider` (memory) | Replace with SQLite | ⚠️ **Refactor needed** |
| Search restaurants | `SearchScreen` with debounce | ✅ Keep unchanged | ✅ Compatible |
| Add reviews | `ReviewForm` + POST API | ✅ Keep unchanged | ✅ Compatible |
| Personalize theme | `ThemeMode.system` | Add `SettingsProvider` | ⚠️ **Wire needed** |
| Get reminders | None | Add `NotificationService` | ✅ **New feature** |

#### 2. First Principle Thinking: Core Architecture Compatibility

| Phase 1 Pattern | Phase 2 Requirement | Compatibility |
|-----------------|---------------------|---------------|
| Provider + ChangeNotifier | New providers for favorites/settings | ✅ Same pattern |
| Sealed classes for API states | Keep for existing, add for new | ✅ Extensible |
| ApiService DI injection | Add DatabaseService, PreferencesService | ✅ Same DI pattern |
| Modular folder structure | Add `core/database/`, `core/preferences/`, `core/notifications/` | ✅ Same structure |
| `/// ` docstring format | All new files must follow same style | ✅ Documented below |

#### 3. Second-Order Thinking: Impact Analysis

| Change | First-Order Impact | Second-Order Impact | Third-Order Impact |
|--------|-------------------|---------------------|-------------------|
| Replace BookmarkProvider | UI needs Consumer update | Existing bookmark logic changes | Test coverage needed |
| Add SettingsProvider to main.dart | MaterialApp wiring | Theme persists on restart | User satisfaction |
| Add SQLite dependency | App size +500KB | Offline favorites work | Data survives reinstall |
| Add notification permissions | User permission dialog | Some users deny | Graceful fallback needed |

#### 4. Probabilistic Thinking: Risk & Success Factors

| Factor | Probability | Risk Level | Mitigation |
|--------|-------------|------------|------------|
| Phase 1 features break after Phase 2 | 10% | HIGH | Run all Phase 1 tests after changes |
| Theme not persisting correctly | 15% | MEDIUM | Load preferences before `runApp()` |
| SQLite migration issues in future | 20% | LOW | Keep schema simple, version=1 |
| Notification permission denied | 30% | LOW | Don't break app if denied |
| Duplicate favorites | 5% | HIGH (rejection) | Use PRIMARY KEY + replace |
| UI overflow on new screens | 5% | HIGH (rejection) | Use Expanded, maxLines consistently |

### Alignment Summary

```
Phase 1 PRD Requirements              Phase 2 Additions               Alignment
═══════════════════════════════════════════════════════════════════════════════
✓ List screen (API)           ────→   Keep unchanged                  ✅ 100%
✓ Detail screen (API)         ────→   + Heart button overlay          ✅ 100%
✓ Search screen (debounce)    ────→   Keep unchanged                  ✅ 100%
✓ Review feature (POST)       ────→   Keep unchanged                  ✅ 100%
✓ Light/Dark theme           ────→   + Persist via SharedPrefs        ✅ 100%
✓ Provider state management   ────→   + FavoritesProvider, Settings   ✅ 100%
✓ Sealed classes             ────→   Keep for API states             ✅ 100%
✓ Loading indicators         ────→   Keep unchanged                  ✅ 100%
✓ Error handling             ────→   + Database error handling       ✅ 100%
✗ Bookmark (memory only)      ────→   REPLACE with SQLite             ⚠️ Migration
✗ No settings screen          ────→   + SettingsScreen                ✅ New
✗ No notifications            ────→   + NotificationService           ✅ New
═══════════════════════════════════════════════════════════════════════════════
OVERALL ALIGNMENT: 95% Compatible (1 migration, 2 new features)
```

---

## Code Style Consistency Guide

> [!CAUTION]
> All Phase 2 code **MUST** follow the existing Phase 1 comment style to maintain consistency.

### Existing Comment Pattern (Phase 1)

```dart
/// Brief description of the class/function.
///
/// Extended description or notes.
/// Features:
/// - Feature 1
/// - Feature 2
/// - Feature 3
class MyClass {
  /// Single line property/method description.
  final String property;
}
```

### Example: New FavoritesProvider (Phase 2)

```dart
// lib/providers/favorites_provider.dart

/// Manages user's favorite restaurants with SQLite persistence.
///
/// Features:
/// - SQLite backed storage (survives app restart)
/// - Real-time UI updates via notifyListeners()
/// - Duplicate prevention with ConflictAlgorithm.replace
class FavoritesProvider extends ChangeNotifier {
  final FavoritesDatabaseService _dbService;
  List<Restaurant> _favorites = [];

  /// Unmodifiable list of favorite restaurants.
  List<Restaurant> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider(this._dbService);

  /// Loads all favorites from SQLite database.
  Future<void> loadFavorites() async {
    _favorites = await _dbService.getAllFavorites();
    notifyListeners();
  }

  /// Checks if a restaurant is in favorites by ID.
  bool isFavorite(String id) => _favorites.any((r) => r.id == id);

  /// Adds or removes a restaurant from favorites.
  ///
  /// If already favorite, removes it. Otherwise, adds it.
  /// Automatically refreshes the list after operation.
  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (isFavorite(restaurant.id)) {
      await _dbService.delete(restaurant.id);
    } else {
      await _dbService.insert(restaurant);
    }
    await loadFavorites();
  }
}
```

### Example: New SettingsProvider (Phase 2)

```dart
// lib/providers/settings_provider.dart

/// Manages app settings with SharedPreferences persistence.
///
/// Features:
/// - Theme mode (light/dark/system) with persistence
/// - Daily reminder toggle with notification scheduling
/// - Loads settings before runApp() for immediate availability
class SettingsProvider extends ChangeNotifier {
  final PreferencesService _prefsService;
  final NotificationService _notificationService;

  ThemeMode _themeMode = ThemeMode.system;
  bool _dailyReminderEnabled = false;

  /// Current theme mode for MaterialApp.
  ThemeMode get themeMode => _themeMode;

  /// Whether daily reminder notification is enabled.
  bool get dailyReminderEnabled => _dailyReminderEnabled;

  SettingsProvider(this._prefsService, this._notificationService);

  /// Loads all settings from SharedPreferences.
  Future<void> loadSettings() async {
    _themeMode = await _prefsService.getThemeMode();
    _dailyReminderEnabled = await _prefsService.getDailyReminderEnabled();
    notifyListeners();
  }

  /// Sets theme mode and persists to SharedPreferences.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefsService.setThemeMode(mode);
    notifyListeners();
  }

  /// Enables/disables daily reminder notification.
  ///
  /// When enabled, schedules notification at 11:00 AM daily.
  /// When disabled, cancels all scheduled notifications.
  Future<void> setDailyReminderEnabled(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermission();
      if (!granted) return; // Don't enable if permission denied
      await _notificationService.scheduleDailyReminder(
        title: 'Lunch time! 🍽️',
        body: 'Try visiting a new restaurant today',
      );
    } else {
      await _notificationService.cancelReminder();
    }
    _dailyReminderEnabled = enabled;
    await _prefsService.setDailyReminderEnabled(enabled);
    notifyListeners();
  }
}
```

### Comment Style Checklist

| Element | Required Style | Example |
|---------|---------------|---------|
| Class docstring | `/// Brief.\n///\n/// Features:\n/// - ...` | See above |
| Method docstring | `/// Brief description.` | `/// Loads all favorites from SQLite database.` |
| Multi-line method | `/// Brief.\n///\n/// Extended explanation.` | See `toggleFavorite` |
| Property docstring | `/// Single line.` | `/// Current theme mode for MaterialApp.` |
| File header | Not required (use class docstring) | - |
| TODO comments | `// TODO: description` | `// TODO: Add migration support` |
| Inline explanation | `// lowercase description` | `// Don't enable if permission denied` |

---

**Document End**


