import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../game/zoo_tycoon_game.dart'; // Vérifiez que le chemin est correct

class BuildingSlot extends PositionComponent with TapCallbacks, HasGameRef<ZooTycoonGame> {
  final String allowedType;
  bool isOccupied;

  BuildingSlot({
    required this.allowedType,
    this.isOccupied = false,
    Vector2? position,
    Vector2? size,
  }) : super(position: position ?? Vector2.zero(), size: size ?? Vector2.zero());

  @override
  void render(Canvas canvas) {
    // Utilisation de withAlpha comme alternative à withOpacity (si nécessaire)
    final fillPaint = Paint()
      ..color = Colors.blue.withAlpha((0.3 * 255).round())
      ..style = PaintingStyle.fill;
    canvas.drawRect(size.toRect(), fillPaint);

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(size.toRect(), borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: allowedType,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(2, 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.selectBuildingSlot();
  }
}
