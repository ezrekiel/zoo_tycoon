import 'package:flame/components.dart';

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
