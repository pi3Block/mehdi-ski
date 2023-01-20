import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:les_mehdi_font_du_ski/les_mehdi_font_du_ski.dart';

class Arbre extends SpriteAnimationComponent with HasGameRef<LesMehdiFontDuSkiGame> {
  /// Indicates if this line is the end goal or not.
  /// //Tdo a retirer et mettre dans flag
  final bool isGoal = false;

  Arbre({
    required Vector2 position,
  }) : super(position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('TreeSpriteSheet4.png'),
      srcSize: Vector2(164.0, 306.0),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.3, to: 6);
    position = position;
    size = Vector2(16, 30);
    final hitboxPaint = BasicPalette.white.paint()..style = PaintingStyle.stroke;
    add(
      PolygonHitbox.relative(
        [
          Vector2(0.0, -0.8),
          Vector2(-0.8, 0.1),
          Vector2(-0.5, 0.3),
          Vector2(0.0, 1.0),
          Vector2(0.8, 0.1),
        ],
        parentSize: size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    );
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
}
