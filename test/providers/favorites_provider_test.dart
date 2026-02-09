import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kulinere/core/database/favorites_database_service.dart';
import 'package:kulinere/data/models/restaurant.dart';
import 'package:kulinere/providers/favorites_provider.dart';

/// Mock for FavoritesDatabaseService
class MockFavoritesDatabaseService extends Mock
    implements FavoritesDatabaseService {}

void main() {
  late FavoritesProvider provider;
  late MockFavoritesDatabaseService mockService;

  final testRestaurant = Restaurant(
    id: 'test-id-1',
    name: 'Test Restaurant',
    city: 'Test City',
    rating: 4.5,
    pictureId: 'test-picture',
    description: 'Test description',
  );

  setUp(() {
    mockService = MockFavoritesDatabaseService();
    provider = FavoritesProvider(mockService);
  });

  group('FavoritesProvider', () {
    test('should return empty list when no favorites', () async {
      // Arrange
      when(() => mockService.getAllFavorites()).thenAnswer((_) async => []);

      // Act
      await provider.loadFavorites();

      // Assert
      expect(provider.favorites, isEmpty);
      expect(provider.error, isNull);
      expect(provider.isLoading, isFalse);
    });

    test('should add restaurant to favorites', () async {
      // Arrange
      when(() => mockService.insertFavorite(any())).thenAnswer((_) async => 1);
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

      // Act
      await provider.toggleFavorite(testRestaurant);

      // Assert
      expect(provider.favorites.length, 1);
      expect(provider.favorites.first.id, testRestaurant.id);
      verify(() => mockService.insertFavorite(any())).called(1);
    });

    test('should remove restaurant from favorites', () async {
      // Arrange - first add a favorite
      when(() => mockService.insertFavorite(any())).thenAnswer((_) async => 1);
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
      await provider.toggleFavorite(testRestaurant);

      // Now set up for removal
      when(
        () => mockService.deleteFavorite(testRestaurant.id),
      ).thenAnswer((_) async => 1);
      when(() => mockService.getAllFavorites()).thenAnswer((_) async => []);

      // Act - toggle again to remove
      await provider.toggleFavorite(testRestaurant);

      // Assert
      expect(provider.favorites, isEmpty);
      verify(() => mockService.deleteFavorite(testRestaurant.id)).called(1);
    });

    test(
      'should return true for isFavorite when restaurant is in favorites',
      () async {
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

        // Act
        await provider.loadFavorites();

        // Assert
        expect(provider.isFavorite(testRestaurant.id), isTrue);
        expect(provider.isFavorite('non-existent-id'), isFalse);
      },
    );
  });
}
