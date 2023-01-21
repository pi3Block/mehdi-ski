import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:les_mehdi_font_du_ski/components/mehdi_ski_joystick_player.dart';
import 'package:les_mehdi_font_du_ski/les_mehdi_font_du_ski.dart';

enum DrapeauState {
  notPassed,
  Passed,
}

class Drapeau extends SpriteAnimationGroupComponent<DrapeauState> with HasGameRef<LesMehdiFontDuSkiGame>, CollisionCallbacks {
  /// Indicates if this line is the end goal or not.
  /// //Tdo a retirer et mettre dans flag
  late bool isGoal = false;

  final _collisionStartColor = Colors.red;
  final _defaultColor = Colors.cyan;
  late ShapeHitbox hitbox;

  Drapeau({required Vector2 position})
      : super(
          position: position,
          size: Vector2(160, 60),
          anchor: Anchor.center,
        );

/*   Drapeau({
    required Vector2 position,
  }) : super(position: position); */

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //Tuto dev
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('drapeau_double.png'),
      srcSize: Vector2(400.0, 150.0),
    );
/*     animation = spriteSheet.createAnimation(row: 0, stepTime: 0.7, to: 4);
    position = this.position;
    size = Vector2(160, 60); */
    final spriteSheetGreen = SpriteSheet(
      image: await gameRef.images.load('drapeau_double_green.png'),
      srcSize: Vector2(400.0, 150.0),
    );
/*     animation = spriteSheetGreen.createAnimation(row: 0, stepTime: 0.7, to: 4);
    position = this.position;
    size = Vector2(160, 60); */

    final notPassed = spriteSheet.createAnimation(row: 0, stepTime: 0.7, to: 4);
    final Passed = spriteSheetGreen.createAnimation(row: 0, stepTime: 0.7, to: 4);

    animations = {DrapeauState.notPassed: notPassed, DrapeauState.Passed: Passed};
    current = DrapeauState.notPassed;
  }

  @override
  void update(double dt) {
/*     if (game.health <= 0) {
      removeFromParent();
    } */
    super.update(dt);
  }

  @override
  void render(Canvas c) {
    super.render(c);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionStartColor;
    if (other is MehdiSkiJoystickPlayer) {
      current = DrapeauState.Passed;
      if (isGoal) {
        gameRef.win = true;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitbox.paint.color = _defaultColor;
    }
  }
}
