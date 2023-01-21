import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:les_mehdi_font_du_ski/les_mehdi_font_du_ski.dart';

class Hud extends PositionComponent with HasGameRef<LesMehdiFontDuSkiGame> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  }) {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;
  late TextComponent _accelTextComponent;

  @override
  Future<void>? onLoad() async {
    _scoreTextComponent = TextComponent(
      text: 'speed : ',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromARGB(255, 241, 5, 5),
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(200, 20),
    );

    _accelTextComponent = TextComponent(
      text: 'accel : ',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromARGB(255, 241, 5, 5),
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(200, 60),
    );

    add(_accelTextComponent);
    add(_scoreTextComponent);

/*     for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      await add(
        JointHealthComponent(
          jointNumber: i,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }

    return super.onLoad();
  } */

/*   @override
  void update(double dt) {
    _scoreTextComponent.text = 'speed : ${game.speed}';
    _accelTextComponent.text = 'accel : ${game.speed}';
    super.update(dt);
  } */
  }
}
