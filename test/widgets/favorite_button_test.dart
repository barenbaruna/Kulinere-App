import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kulinere/core/database/favorites_database_service.dart';
import 'package:kulinere/data/models/restaurant.dart';
import 'package:kulinere/providers/favorites_provider.dart';

/// Mock for FavoritesDatabaseService
class MockFavoritesDatabaseService extends Mock
    implements FavoritesDatabaseService {}

void main() {
  late MockFavoritesDatabaseService mockService;
  late FavoritesProvider provider;

  final testRestaurant = Restaurant(
    id: 'test-id',
    name: 'Test Restaurant',
    city: 'Test City',
    rating: 4.5,
    pictureId: 'test-pic',
    description: 'Test desc',
  );

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockService = MockFavoritesDatabaseService();
    provider = FavoritesProvider(mockService);
  });

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  group('Favorite Button Widget Tests', () {
    testWidgets('should show empty heart icon when not favorited', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockService.getAllFavorites()).thenAnswer((_) async => []);
      await provider.loadFavorites();

      // Act
      await tester.pumpWidget(
        createTestWidget(
          child: Consumer<FavoritesProvider>(
            builder: (context, favProvider, _) {
              final isFavorite = favProvider.isFavorite(testRestaurant.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                ),
                onPressed: () => favProvider.toggleFavorite(testRestaurant),
              );
            },
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should show filled heart icon when favorited', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockService.getAllFavorites()).thenAnswer(
        (_) async => [
          {
            'id': testRestaurant.id,
            'name': testRestaurant.name,
            'city': testRestaurant.city,
            'rating': testRestaurant.rating,
            'pictureId': testRestaurant.pictureId,
          },
        ],
      );
      await provider.loadFavorites();

      // Act
      await tester.pumpWidget(
        createTestWidget(
          child: Consumer<FavoritesProvider>(
            builder: (context, favProvider, _) {
              final isFavorite = favProvider.isFavorite(testRestaurant.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                ),
                onPressed: () => favProvider.toggleFavorite(testRestaurant),
              );
            },
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should toggle favorite state when button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockService.getAllFavorites()).thenAnswer((_) async => []);
      when(() => mockService.insertFavorite(any())).thenAnswer((_) async => 1);
      await provider.loadFavorites();

      await tester.pumpWidget(
        createTestWidget(
          child: Consumer<FavoritesProvider>(
            builder: (context, favProvider, _) {
              final isFavorite = favProvider.isFavorite(testRestaurant.id);
              return IconButton(
                key: const Key('favorite_button'),
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () => favProvider.toggleFavorite(testRestaurant),
              );
            },
          ),
        ),
      );

      // Initially not favorite
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // Mock the response after adding
      when(() => mockService.getAllFavorites()).thenAnswer(
        (_) async => [
          {
            'id': testRestaurant.id,
            'name': testRestaurant.name,
            'city': testRestaurant.city,
            'rating': testRestaurant.rating,
            'pictureId': testRestaurant.pictureId,
          },
        ],
      );

      // Act - tap the button
      await tester.tap(find.byKey(const Key('favorite_button')));
      await tester.pumpAndSettle();

      // Assert - should now be favorited
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
