import 'dart:ui';
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
          ..color = Colors.white.withAlpha(128)
          ..strokeWidth = 1.0,
        super(position: position ?? Vector2.zero(), size: size ?? Vector2.zero());

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Calculer la taille d'une cellule
    final cellWidth = size.x / columns;
    final cellHeight = size.y / rows;

    // Dessiner les lignes verticales
    for (int i = 0; i <= columns; i++) {
      final x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), gridPaint);
    }

    // Dessiner les lignes horizontales
    for (int j = 0; j <= rows; j++) {
      final y = j * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
    }
  }
}
