import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cinescope/main.dart';
import 'package:cinescope/providers/favorites_provider.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    // Instantiate the required provider
    final favProvider = FavoritesProvider();

    // Build our app and trigger a frame.
    await tester.pumpWidget(CineScopeApp(favoritesProvider: favProvider));

    // Verify that the app renders successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
