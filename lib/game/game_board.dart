import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameBoard extends PositionComponent {
  final int rows;
  final int columns;
  final Paint gridPaint;

  GameBoard({
    required this.rows,
    required this.columns,
    Vector2? position,
    Vector2? size,
  })  : gridPaint = Paint()
          // On remplace withOpacity par withAlpha pour éviter l'avertissement
          ..color = Colors.white.withAlpha(128)
          ..strokeWidth = 1.0,
        super(position: position ?? Vector2.zero(), size: size ?? Vector2.zero());

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Calculer la taille d'une cellule carrée
    final double cellSize = math.min(size.x / columns, size.y / rows);
    
    // Calculer la taille totale de la grille
    final double gridWidth = cellSize * columns;
    final double gridHeight = cellSize * rows;
    
    // Calculer l'offset pour centrer la grille dans le composant
    final double offsetX = (size.x - gridWidth) / 2;
    final double offsetY = (size.y - gridHeight) / 2;
    
    // Dessiner les lignes verticales
    for (int i = 0; i <= columns; i++) {
      final double x = offsetX + i * cellSize;
      canvas.drawLine(Offset(x, offsetY), Offset(x, offsetY + gridHeight), gridPaint);
    }
    
    // Dessiner les lignes horizontales
    for (int j = 0; j <= rows; j++) {
      final double y = offsetY + j * cellSize;
      canvas.drawLine(Offset(offsetX, y), Offset(offsetX + gridWidth, y), gridPaint);
    }
  }
}
