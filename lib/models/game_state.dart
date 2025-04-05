import 'building.dart';

class GameState {
  int money;
  List<Building> buildings;

  GameState({required this.money, required this.buildings});

  Map<String, dynamic> toJson() {
    return {
      'money': money,
      'buildings': buildings.map((b) => b.toJson()).toList(),
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      money: json['money'] as int,
      buildings: (json['buildings'] as List<dynamic>)
          .map((b) => Building.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }
}
