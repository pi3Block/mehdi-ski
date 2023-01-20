/* import 'package:LesMehdiFontDuSki/components/arbre.dart';
import 'package:LesMehdiFontDuSki/les_mehdis_font_du_ski.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class JoystickPlayer extends SpriteAnimationComponent with HasGameRef<LesMehdisFontDuSki>, CollisionCallbacks {
  /// Pixels/s
  final double maxSpeedVelocity = 30.0;
  final double accelVelocity = 3.0;
  double actualSpeedVelocity = 0;
  double graviteActuel = 0;

  late Vector2 velocity = Vector2.zero();

  bool hitByEnemy = false;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  final JoystickComponent joystick;

  final countdown = Timer(3);
  late Vector2 _ancientKnobAngle = Vector2(0, 0);

  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;

  JoystickPlayer(this.joystick) : super(size: Vector2.all(100.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    velocity = Vector2(0, 1);

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('sangoku-pixel.png'),
      srcSize: Vector2(120.0, 172.0),
    );
    this.animation = spriteSheet.createAnimation(row: 0, stepTime: 0.3, to: 3);
    //position = this.position;
    size = Vector2(30, 60);

    //sprite = await gameRef.loadSprite('player.png');
    position = Vector2(150, 150);
    //add(RectangleHitbox());
    final hitboxPaint = BasicPalette.white.paint()..style = PaintingStyle.stroke;
    add(
      PolygonHitbox.relative(
        [
          Vector2(0.0, -0.5),
          Vector2(-0.8, 0.3),
          Vector2(0.0, 1.0),
          Vector2(0.8, 0.3),
          Vector2(0.0, -0.1),
        ],
        parentSize: size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    );
  }

  @override
  void render(Canvas c) {
    super.render(c);
  }
/* 
  @override
  void update(double dt) {
    super.update(dt);
    countdown.update(dt);
    if (countdown.finished) {
      // Prefer the timer callback, but this is better in some cases
    }
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      //print('update coutdown ${countdown.progress}');
      //print('diffERENCE ${_ancientKnobAngle.angleToSigned(joystick.relativeDelta)}');
      print('SPEED : ${maxSpeed * (countdown.progress + 1)}');
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * (maxSpeed * (countdown.progress + 1)) * dt);

      //Todo: angle de mehdi
      //angle = joystick.delta.screenAngle();
      //Si angleprecedent to angle > 0.01 on reset acceleration = timer
      if (_ancientKnobAngle.angleToSigned(joystick.relativeDelta) > 0.005) {
        //print('reset coutdown joysticke angle');
        print(countdown.progress);
        countdown.start();
        //print('_ancientKnobAngle ${_ancientKnobAngle}');
        print('joystick.direction ${joystick.direction}');
        print('joystick. screen angle ${joystick.delta.screenAngle()}');
        //print('joystick delta ${joystick.delta}');

        //Pour sauter
        hasJumped = joystick.direction == (JoystickDirection.up);
        print('il saute ${joystick.direction == (JoystickDirection.up)}');
      }
    } else {
      //print('reset coutdown  ${countdown.progress}');
      countdown.start();
    }
    _ancientKnobAngle = joystick.relativeDelta;
  } */
/*   @override
  void update(double dt) {
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  } */

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Arbre) {
      print('colision !!!!');
      hit();
      final collisionPoint = intersectionPoints.first;

      // Left Side Collision
      if (collisionPoint.x == 0) {
        velocity.x = -velocity.x;
        velocity.y = velocity.y;
      }
      // Right Side Collision
      if (collisionPoint.x == gameRef.size.x) {
        velocity.x = -velocity.x;
        velocity.y = velocity.y;
      }
      // Top Side Collision
      if (collisionPoint.y == 0) {
        velocity.x = velocity.x;
        velocity.y = -velocity.y;
      }
      // Bottom Side Collision
      if (collisionPoint.y == gameRef.size.y) {
        velocity.x = velocity.x;
        velocity.y = -velocity.y;
      }

/*       if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        } else {
          hit();
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      } */
    }
  }

// This method runs an opacity effect on ember
// to make it blink.
  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.3,
          repeatCount: 2,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }

/*   @override
  void update(double dt) {
    countdown.update(dt);

    //si on sort ecran
    if (position.y > game.size.y + size.y) {
      game.win = true;
      position = Vector2(150, 150);
    }
    //Si plus de vie
    if (game.health <= 0) {
      removeFromParent();
    }
    graviteActuel = graviteActuel;
    velocity.y = graviteActuel * (countdown.progress + 1);

    //Apply accel Tempo jusqu'a max speed
    actualSpeedVelocity = (actualSpeedVelocity * (countdown.progress + 1)).clamp(1, maxSpeedVelocity);
    // Apply basic gravity
    velocity.y += graviteActuel;
    velocity.y = velocity.y.clamp(-graviteActuel, actualSpeedVelocity);

    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      graviteActuel = 1;
      //print('SPEED : ${maxSpeed * (countdown.progress + 1)}');
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      velocity.x = (joystick.relativeDelta.x) * (accelVelocity * (countdown.progress + 1));
      velocity.x = velocity.x.clamp(-maxSpeedVelocity, (countdown.progress + 1));

      //Todo: angle de mehdi
      //angle = joystick.delta.screenAngle();
      //Si angleprecedent to angle > 0.01 on reset acceleration = timer
      if (_ancientKnobAngle.angleToSigned(joystick.relativeDelta) > 0.005) {
        countdown.start();
        //Reduction accel x et y
        velocity.y = (joystick.relativeDelta.y) * (maxSpeedVelocity * (countdown.progress + 1));
        velocity.x = (joystick.relativeDelta.x) * (maxSpeedVelocity * (countdown.progress + 1));
        velocity.y = velocity.y.clamp(-graviteActuel, actualSpeedVelocity);
        velocity.x = velocity.x.clamp(-maxSpeedVelocity, actualSpeedVelocity);

        //Pour sauter
        //hasJumped = joystick.direction == (JoystickDirection.up);
      }
    } else if (joystick.delta.isZero() && activeCollisions.isEmpty) {
      velocity.x = 0;
    } else {
      position += velocity * dt;
      print('Pas pris en comptes');
    }
/*     print('Velocity Y : ${velocity.y}');
    print('Velocity X :  ${velocity.x}');
    print('countdown : ${countdown.current}'); */
    gameRef.speed = (actualSpeedVelocity * 100).toInt();

    position.add(velocity * (maxSpeedVelocity * (countdown.progress + 1)) * dt);
    _ancientKnobAngle = joystick.relativeDelta;
    super.update(dt);
  } */
  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  final Paint hitboxPaint = BasicPalette.green.paint()..style = PaintingStyle.stroke;
  final Paint dotPaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
}
 */