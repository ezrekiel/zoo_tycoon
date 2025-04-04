import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: ZooTycoonGame()));
}

class ZooTycoonGame extends FlameGame {
  late SpriteComponent background;

  @override
  Future<void> onLoad() async {
    // Charger l'image de fond depuis le dossier assets
    final bgImage = await images.load('background.png');

    // Créer un composant sprite avec l'image chargée
    background = SpriteComponent(
      sprite: Sprite(bgImage),
      size: size, // 'size' correspond aux dimensions du jeu (souvent la taille de l'écran)
    );

    // Ajouter le composant à la scène du jeu
    add(background);
  }

  @override
  void update(double dt) {
    // Ici vous pouvez mettre à jour la logique du jeu
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // La méthode render est automatiquement gérée par Flame pour afficher vos composants
    super.render(canvas);
  }
}
