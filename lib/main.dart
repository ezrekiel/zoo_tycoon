// main.dart (extrait)
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/zoo_tycoon_game.dart';

void main() {
  final game = ZooTycoonGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        'moneyButton': (BuildContext context, ZooTycoonGame game) {
          return Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                game.addMoney(10);
              },
              child: const Text('+10'),
            ),
          );
        },
        'resetButton': (BuildContext context, ZooTycoonGame game) {
          return Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                game.resetMoney();
              },
              child: const Text('Reset'),
            ),
          );
        },
        'constructionMenu': (BuildContext context, ZooTycoonGame game) {
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              color: Colors.black54, // Fond semi-transparent pour mettre en évidence le menu
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour construire sur l'emplacement sélectionné
                      game.buildOnSelectedSlot();
                      game.overlays.remove('constructionMenu');
                    },
                    child: const Text('Construire'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour afficher les infos de l'emplacement
                      game.showSlotInfo();
                      // Par exemple, afficher une autre overlay ou une popup
                    },
                    child: const Text('Infos'),
                  ),
                ],
              ),
            ),
          );
        },
      },
      initialActiveOverlays: const ['moneyButton', 'resetButton'],
    ),
  );
}
