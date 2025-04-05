import 'dart:async' as dart_async;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import 'game_board.dart';

// Packages flame
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class ZooTycoonGame extends FlameGame with WidgetsBindingObserver, PanDetector {
  late GameState gameState;
  late SpriteComponent background;
  late TextComponent moneyText;
  dart_async.Timer? _saveTimer;

  // Méthode appelée lorsque le joueur sélectionne un emplacement de construction.
  void selectBuildingSlot() {
    overlays.add('constructionMenu');
  }

  // Méthode appelée lorsque le bouton "Construire" est pressé dans le menu.
  void buildOnSelectedSlot() {
    print("Construction effectuée sur l'emplacement sélectionné.");
  }

  // Méthode appelée lorsque le bouton "Infos" est pressé dans le menu.
  void showSlotInfo() {
    print("Affichage des informations de l'emplacement sélectionné.");
  }

  @override
  Future<void> onLoad() async {
    // Initialisation de l'état par défaut.
    gameState = GameState(money: 0, buildings: []);
    
    // Chargement et ajout du background (ici, une image noire par exemple).
    final bgImage = await images.load('black_background.png');
    background = SpriteComponent(
      sprite: Sprite(bgImage),
      size: size,
    );
    add(background);

    // Création et ajout du plateau de jeu.
    // Ici, le plateau est 3 fois plus grand que l'écran dans chaque dimension.
    final board = GameBoard(
      rows: 10,
      columns: 10,
      position: Vector2.zero(),
      size: size * 3,
    );
    add(board);

    // Création et ajout d'un TextComponent pour afficher l'argent.
    moneyText = TextComponent(
      text: 'Money: ${gameState.money}',
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      position: Vector2(10, 10),
    );
    add(moneyText);

    // Observer le cycle de vie de l'application.
    WidgetsBinding.instance.addObserver(this);
    
    // Charger l'état sauvegardé (s'il existe).
    await loadGame();
    moneyText.text = 'Money: ${gameState.money}';
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  // Méthode pour ajouter de l'argent et planifier la sauvegarde.
  void addMoney(int amount) {
    gameState.money += amount;
    moneyText.text = 'Money: ${gameState.money}';
    _scheduleSave();
  }

  // Méthode pour réinitialiser l'argent et planifier la sauvegarde.
  void resetMoney() {
    gameState.money = 0;
    moneyText.text = 'Money: ${gameState.money}';
    _scheduleSave();
  }
  
  // Planifie la sauvegarde après 1 seconde d'inactivité.
  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = dart_async.Timer(const Duration(seconds: 1), () {
      saveGame();
    });
  }

  // Sauvegarde l'état du jeu en sérialisant l'objet GameState en JSON.
  Future<void> saveGame() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(gameState.toJson());
    await prefs.setString('game_state', jsonString);
  }

  // Charge l'état du jeu depuis SharedPreferences et désérialise l'objet JSON.
  Future<void> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('game_state');
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        gameState = GameState.fromJson(jsonData);
      } catch (e) {
        gameState = GameState(money: 0, buildings: []);
      }
    } else {
      gameState = GameState(money: 0, buildings: []);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveTimer?.cancel();
      saveGame();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onDetach() {
    _saveTimer?.cancel();
    saveGame();
    super.onDetach();
  }

  // Permet de faire glisser pour déplacer la caméra et explorer le plateau.
  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.moveBy(-info.delta);
  }
}
