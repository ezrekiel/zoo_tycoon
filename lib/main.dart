import 'dart:async' as dart_async;
import 'dart:convert'; // Pour l'encodage/décodage JSON
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

/// Classe représentant l'état complet du jeu
class GameState {
  int money;
  List<Building> buildings;

  GameState({required this.money, required this.buildings});

  /// Convertit l'état du jeu en Map pour le sérialiser en JSON
  Map<String, dynamic> toJson() {
    return {
      'money': money,
      'buildings': buildings.map((b) => b.toJson()).toList(),
    };
  }

  /// Construit un GameState à partir d'une Map JSON
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      money: json['money'] as int,
      buildings: (json['buildings'] as List<dynamic>)
          .map((b) => Building.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Classe simplifiée pour représenter un bâtiment dans le jeu
class Building {
  String id;
  String type;
  Vector2 position;
  int level;

  Building({
    required this.id,
    required this.type,
    required this.position,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'position': {'x': position.x, 'y': position.y},
      'level': level,
    };
  }

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as String,
      type: json['type'] as String,
      position: Vector2(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      level: json['level'] as int,
    );
  }
}

class ZooTycoonGame extends FlameGame with WidgetsBindingObserver {
  late GameState gameState;
  late SpriteComponent background;
  late TextComponent moneyText;
  dart_async.Timer? _saveTimer;

  @override
  Future<void> onLoad() async {
    // Initialisation de l'état par défaut
    gameState = GameState(money: 0, buildings: []);
    
    // Chargement et ajout du background (assurez-vous que le chemin est correct)
    final bgImage = await images.load('background.png');
    background = SpriteComponent(
      sprite: Sprite(bgImage),
      size: size,
    );
    add(background);

    // Création et ajout d'un TextComponent pour afficher l'argent
    moneyText = TextComponent(
      text: 'Money: ${gameState.money}',
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      position: Vector2(10, 10),
    );
    add(moneyText);

    // Observer le cycle de vie de l'application
    WidgetsBinding.instance.addObserver(this);
    
    // Charger l'état sauvegardé (s'il existe)
    await loadGame();
    moneyText.text = 'Money: ${gameState.money}';
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  // Méthode pour ajouter de l'argent et planifier la sauvegarde
  void addMoney(int amount) {
    gameState.money += amount;
    moneyText.text = 'Money: ${gameState.money}';
    _scheduleSave();
  }

  // Méthode pour réinitialiser l'argent (pour les tests) et planifier la sauvegarde
  void resetMoney() {
    gameState.money = 0;
    moneyText.text = 'Money: ${gameState.money}';
    _scheduleSave();
  }
  
  // Planifie la sauvegarde après 1 seconde d'inactivité
  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = dart_async.Timer(const Duration(seconds: 1), () {
      saveGame();
    });
  }

  // Sauvegarde l'état du jeu en sérialisant l'objet GameState en JSON
  Future<void> saveGame() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(gameState.toJson());
    await prefs.setString('game_state', jsonString);
  }

  // Charge l'état du jeu depuis SharedPreferences et désérialise l'objet JSON
  Future<void> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('game_state');
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        gameState = GameState.fromJson(jsonData);
      } catch (e) {
        // En cas d'erreur lors du décodage, on réinitialise l'état par défaut
        gameState = GameState(money: 0, buildings: []);
      }
    } else {
      gameState = GameState(money: 0, buildings: []);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sauvegarder immédiatement lorsque l'application passe en arrière-plan
    if (state == AppLifecycleState.paused) {
      _saveTimer?.cancel();
      saveGame();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onDetach() {
    // Sauvegarder lors de la fermeture de l'application
    _saveTimer?.cancel();
    saveGame();
    super.onDetach();
  }
}
