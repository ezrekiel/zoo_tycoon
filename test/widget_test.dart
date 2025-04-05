import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoo_tycoon/game/zoo_tycoon_game.dart'; // Import corrigé

void main() {
  testWidgets('Test de présence du GameWidget', (WidgetTester tester) async {
    await tester.pumpWidget(GameWidget(game: ZooTycoonGame()));

    // Vérifier qu'un GameWidget est présent dans l'arbre de widgets
    expect(find.byType(GameWidget), findsOneWidget);
  });
}
