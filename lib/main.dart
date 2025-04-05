import 'dart:async' as dart_async; // Import du Timer de dart:async
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      },
      initialActiveOverlays: const ['moneyButton'],
    ),
  );
}

class ZooTycoonGame extends FlameGame with WidgetsBindingObserver {
  int money = 0;
  late SpriteComponent background;
  late TextComponent moneyText;
  
  dart_async.Timer? _saveTimer; // Utilise le Timer de dart:async

  @override
  Future<void> onLoad() async {
    // Charger et ajouter le background
    final bgImage = await images.load('assets/background.png');
    background = SpriteComponent(
      sprite: Sprite(bgImage),
      size: size,
    );
    add(background);

    // Créer et ajouter un TextComponent pour afficher l'argent
    moneyText = TextComponent(
      text: 'Argent: $money',
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      position: Vector2(10, 10),
    );
    add(moneyText);

    // Observer le cycle de vie de l'application
    WidgetsBinding.instance.addObserver(this);
    // Charger la progression sauvegardée
    await loadGame();
    moneyText.text = 'Argent: $money';
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  // Méthode pour ajouter de l'argent et planifier une sauvegarde différée
  void addMoney(int amount) {
    money += amount;
    moneyText.text = 'Argent: $money';
    _scheduleSave();
  }
  
  // Planifie la sauvegarde après 1 seconde d'inactivité
  void _scheduleSave() {
    _saveTimer?.cancel(); // Annule un timer existant
    _saveTimer = dart_async.Timer(const Duration(seconds: 1), () {
      saveGame();
    });
  }

  // Méthode pour sauvegarder la progression
  Future<void> saveGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('money', money);
  }

  // Méthode pour charger la progression
  Future<void> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    money = prefs.getInt('money') ?? 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sauvegarder lorsque l'application passe en arrière-plan
    if (state == AppLifecycleState.paused) {
      _saveTimer?.cancel();
      saveGame();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onDetach() {
    // Sauvegarder lors de la fermeture et annuler le timer
    _saveTimer?.cancel();
    saveGame();
    super.onDetach();
  }
}
