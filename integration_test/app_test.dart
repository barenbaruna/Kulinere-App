import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kulinere/main.dart' as app;
import 'package:kulinere/screens/home/widgets/restaurant_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify favorites persistence flow', (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      expect(find.text('Kulinere'), findsOneWidget);

      // Wait for data
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check if any restaurant is loaded
      final cardFinder = find.byType(RestaurantCard);
      expect(cardFinder, findsWidgets);

      // Tap first card
      await tester.tap(cardFinder.first);
      await tester.pumpAndSettle();

      // Verify detail screen (look for back button)
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Toggle favorite
      // Find the heart icon/button
      final heartFinder = find.byIcon(Icons.favorite_border);
      final filledHeartFinder = find.byIcon(Icons.favorite);

      if (heartFinder.evaluate().isNotEmpty) {
        await tester.tap(heartFinder);
        await tester.pumpAndSettle();
        expect(filledHeartFinder, findsOneWidget);

        // Tap again to revert (cleanup)
        await tester.tap(filledHeartFinder);
        await tester.pumpAndSettle();
        expect(heartFinder, findsOneWidget);
      } else if (filledHeartFinder.evaluate().isNotEmpty) {
        await tester.tap(filledHeartFinder);
        await tester.pumpAndSettle();
        expect(heartFinder, findsOneWidget);

        // Tap again to revert
        await tester.tap(heartFinder);
        await tester.pumpAndSettle();
        expect(filledHeartFinder, findsOneWidget);
      } else {
        fail('Favorite button not found');
      }

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Kulinere'), findsOneWidget);
    });
  });
}
