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
      },
      initialActiveOverlays: const ['moneyButton', 'resetButton'],
    ),
  );
}
