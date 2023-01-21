import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:les_mehdi_font_du_ski/les_mehdi_font_du_ski.dart';

enum JointState {
  available,
  unavailable,
}

class JointHealthComponent extends SpriteAnimationGroupComponent<JointState> with HasGameRef<LesMehdiFontDuSkiGame> {
  final int jointNumber;

  JointHealthComponent({
    required this.jointNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  }) {
    positionType = PositionType.viewport;
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //Rocket sprite sheet with animation groups
    const stepTime = .3;
    const frameCount = 5;
    final image = await gameRef.images.load('joint_full_ani150.150.png');
    final imageUna = await gameRef.images.load('joint_aie_anim150.150.png');
    final sheet = SpriteSheet(
      image: image,
      srcSize: Vector2(150.0, 150.0),
    );
    final sheetUna = SpriteSheet(
      image: imageUna,
      srcSize: Vector2(150.0, 150.0),
    );

    final available = sheet.createAnimation(row: 0, stepTime: stepTime, to: frameCount);
    final unavailable = sheetUna.createAnimation(row: 0, stepTime: stepTime, to: frameCount);

    animations = {JointState.available: available, JointState.unavailable: unavailable};
    current = JointState.available;
  }

  @override
  void update(double dt) {
/*     if (game.health < jointNumber) {
      current = JointState.unavailable;
    } else {
      current = JointState.available;
    } */
    super.update(dt);
  }

  @override
  void render(Canvas c) {
    super.render(c);
  }
}
