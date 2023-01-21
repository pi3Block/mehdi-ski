import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:les_mehdi_font_du_ski/components/arbre.dart';
import 'package:les_mehdi_font_du_ski/components/drapeau.dart';
import 'package:les_mehdi_font_du_ski/components/explosion_component.dart';
import 'package:les_mehdi_font_du_ski/components/line_component.dart';
import 'package:les_mehdi_font_du_ski/components/map_component.dart';
import 'package:les_mehdi_font_du_ski/components/particel_generator.dart';
import 'package:les_mehdi_font_du_ski/game_state.dart';
import 'package:les_mehdi_font_du_ski/les_mehdi_font_du_ski.dart';

/// Describes the render state of the [MehdiComponent].
enum MehdiState {
  /// Rocket is idle.
  idle,

  ///Rocket thrust up or down.
  //upDown,

  /// Rocket is slightly to the left.
  left,

  /// Rocket is slightly to the right.
  right,

  /// Rocket is to the far left.

  //farLeft,

  /// Rocket is to the far right.
  //farRight,
}

/// Describe the heading of the [MehdiComponent].
enum MehdiBonnet {
  /// Rocket is heading to the left.
  left,

  /// Rocket is heading to the right.
  right,

  /// Rocket is idle.
  idle,
}

class MehdiSkiJoystickPlayer extends SpriteAnimationGroupComponent with HasGameRef<LesMehdiFontDuSkiGame>, CollisionCallbacks {
  MehdiSkiJoystickPlayer({
    required Vector2 position,
    required Vector2 size,
    required this.joystick,
  }) : super(anchor: Anchor.center, position: position, size: size, animations: {});

  /// Joystick that controls this rocket.
  final JoystickComponent joystick;

  var _heading = MehdiBonnet.idle;
  final _engineSoundCoolDown = 0.2;
  var _engineSoundCounter = 0.2;
  final _animationSpeed = .1;
  var _animationTime = 0.0;
  final _velocity = Vector2.zero();
  final _gravity = Vector2(0, 1);
  var _collisionActive = false;

  final _fuelUsageBySecond = 10;

  late final Vector2 _particelOffset;
  double _fuel = 100;

  ///Acceleration factor of the rocket
  final speed = 5;

  ///Fuel remaning
  double get fuel => _fuel;
  set fuel(double value) {
    _fuel = value;
  }

  ///Velocity of the rocket
  Vector2 get velocity => _velocity;

  double _flyingTime = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //Rocket sprite sheet with animation groups
    const stepTime = .7;
    const frameCount = 4;
    final image = await gameRef.images.load('skieur_400-495-reso100-150.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: frameCount,
      rows: MehdiState.values.length,
    );

    final idle = sheet.createAnimation(row: 0, stepTime: stepTime);
    final left = sheet.createAnimation(row: 2, stepTime: stepTime);
    final right = sheet.createAnimation(row: 1, stepTime: stepTime);
    //animations = {MehdiState.idle: idle, MehdiState.upDown: upDown, MehdiState.left: left, MehdiState.right: right, MehdiState.farLeft: farLeft, MehdiState.farRight: farRight};
    animations = {MehdiState.idle: idle, MehdiState.left: left, MehdiState.right: right};
    current = MehdiState.idle;
    await add(
      RectangleHitbox.relative(
        Vector2(0.95, 0.7),
        parentSize: size,
      ),
    );
    _particelOffset = Vector2(size.x * 0.1, size.y * -0.2);
  }

  bool get _isJoyStickIdle => joystick.direction == JoystickDirection.idle;

  // Place holder, later we need to animate based on speed in a given direction.
  void _setAnimationState() {
    switch (_heading) {
      case MehdiBonnet.idle:
        if (current != MehdiState.idle) {
          //current = _isJoyStickIdle ? MehdiState.idle : MehdiState.upDown;
          current = MehdiState.idle;
          angle = radians(0);
        } else {
          //current = _isJoyStickIdle ? MehdiState.idle : MehdiState.upDown;
          current = MehdiState.idle;
        }
        break;
      case MehdiBonnet.left:
        if (current == MehdiState.right) {
          //current = _isJoyStickIdle ? MehdiState.idle : MehdiState.upDown;
          current = MehdiState.idle;
          angle = radians(0);
        } else if (current == MehdiState.idle) {
          current = MehdiState.left;
          angle = radians(-7.5);
        }
        break;
      case MehdiBonnet.right:
        if (current == MehdiState.left) {
          //current = _isJoyStickIdle ? MehdiState.idle : MehdiState.upDown;
          current = MehdiState.idle;
          angle = radians(0);
        } else if (current == MehdiState.idle) {
          current = MehdiState.right;
          angle = radians(7.5);
        }

        break;
    }
  }

  void _createEngineParticels() {
    gameRef.add(
      ParticelGenerator.createEngineParticle(
        position: position.clone()..add(_particelOffset),
      ),
    );
  }

  void _updateVelocity(double dt) {
    //Get the direction of the vector2 and scale it with the speed and framerate
    _flyingTime += dt;
    if (!joystick.delta.isZero()) {
      final joyStickDelta = joystick.delta.clone();
      joyStickDelta.y = joyStickDelta.y.clamp(-1 * double.infinity, 0);
      _velocity.add(joyStickDelta.normalized() * (speed * dt));
      _fuel -= _fuelUsageBySecond * dt;
      if (_fuel < 0) {
        _loose();
      } else {
        _createEngineParticels();
        if (_engineSoundCounter >= _engineSoundCoolDown) {
          //gameRef.audioPlayer.playEngine();
          _engineSoundCounter = 0;
        } else {
          _engineSoundCounter += dt;
        }
      }
    }
    //Max speed is equal to two grid cells
    final maxSpeed = gameRef.size.clone()
      ..divide(MapComponent.grid)
      ..scale(2)
      ..divide(Vector2.all(speed.toDouble()));

    final gravityChange = _gravity.normalized() * (dt * 0.8);

    _velocity
      ..add(gravityChange)
      ..clamp(
        maxSpeed.scaled(-1),
        maxSpeed,
      );
  }

  @override
  void render(Canvas canvas) {
    ///If we lost we dont show the rocket anymore
    if (GameState.playState == PlayingState.lost) return;
    super.render(canvas);
    if (gameRef.debugMode) {
      debugTextPaint.render(canvas, 'Fuel:$fuel', Vector2(size.x, 0));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_collisionActive) return;
    if (joystick.direction == JoystickDirection.left && _heading != MehdiBonnet.left) {
      _heading = MehdiBonnet.left;

      _animationTime = 0;
    } else if (joystick.direction == JoystickDirection.right && _heading != MehdiBonnet.right) {
      _heading = MehdiBonnet.right;
      _animationTime = 0;
    } else if (joystick.direction == JoystickDirection.idle && _heading != MehdiBonnet.idle) {
      _heading = MehdiBonnet.idle;
      _animationTime = 0;
    }
    _updateVelocity(dt);

    final worldBounds = gameRef.camera.worldBounds!;
    final nextPosition = position + _velocity;

    // Check if the next position is within the world bounds on the X axis.
    // If it is we set the position to it, otherwise we set velocity to 0.
    if (worldBounds.left <= nextPosition.x && nextPosition.x + size.x <= worldBounds.right) {
      position.x = nextPosition.x;
    } else {
      _velocity.x = 0;
    }

    // Check if the next position is within the world bounds on the y axis.
    // If it is we set the position to it, otherwise we set velocity to 0.
    if (nextPosition.y + size.y <= worldBounds.bottom) {
      position.y = nextPosition.y;
    }

    _animationTime += dt;
    if (_animationTime >= _animationSpeed) {
      _setAnimationState();
      _animationTime = 0;
    }
  }

/*   @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Arbre) {
      if (gameRef.health < 0) {
        _loose();
      } else {
        gameRef.health--;
      }
    }
    super.onCollisionEnd(other);
  } */

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (_collisionActive) {
      return;
    }
    var crashed = true;
    if (other is LineComponent) {
      final hitBox = children.first as RectangleHitbox;
      for (final point in intersectionPoints) {
        // Calculate which side of the hitbox had the collision
        final vectorUp = Vector2(0, -1)
          ..rotate(hitBox.angle)
          ..normalize();
        final relativeIntersectionPoint = (point - hitBox.position).normalized();
        final angle = vectorUp.angleToSigned(relativeIntersectionPoint);
        var angleDeg = degrees(angle);
        debugPrint(other.isGoal ? 'Hit goal' : 'Hit no goal');
        final verticalSpeed = _velocity.y.abs() * speed;
        debugPrint('Vertical on hit: $verticalSpeed');
        // Fix for the angleToSigned method returning values form -180 to 180
        if (angleDeg < 0) angleDeg = 360 + angleDeg;

        // Print side depending on angle (from 0 to 360)

        if (angleDeg >= (360 - 45) || angleDeg <= 45) {
          debugPrint('Hit top $angleDeg');
        }
        if (angleDeg >= 45 && angleDeg < 125) {
          debugPrint('Hit right $angleDeg');
        }
        if (angleDeg >= 125 && angleDeg <= 235) {
          debugPrint('Hit bottom $angleDeg');
          if (other.isGoal && verticalSpeed <= 6) {
            crashed = false;
          }
        }
        if (angleDeg > 235 && angleDeg <= 315) {
          debugPrint('Hit left $angleDeg');
        }
      }
      if (crashed) {
        _loose();
      }
    } else if (other is Drapeau) {
      if (other.isWin) {
        _win(other);
      }
    } else if (other is Arbre) {
      gameRef.health--;
      if (gameRef.health == 0 || gameRef.health < 0) {
        _loose();
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  void _win(Drapeau drapeau) {
    _calculateScore(drapeau);
    _velocity.scale(0);
    _collisionActive = true;
    current = MehdiState.idle;
    GameState.playState = PlayingState.won;
    gameRef.overlays.add('pause');
    _updateScores();
  }

  void _updateScores() {
    if (GameState.currentLevel != null) {
      GameState.database.updateScoreForLevel(GameState.lastScore, GameState.currentLevel!.id);
    }
    GameState.database.createNewHighScoreEntry(GameState.seed, GameState.lastScore);
  }

  void _calculateScore(Drapeau drapeau) {
    //Todo ajouter score de drapeaux
    //final drapeau = drapeau.score;

    //GameState.lastScore = (_flyingTime * (_velocity.y.abs() * speed) * landingSpotScore) ~/ fuel;

    GameState.lastScore = 1000 * fuel.toInt();
  }

  void _loose() {
    _velocity.scale(0); // Stop any movement
    _collisionActive = true;
    current = MehdiState.idle;
    // For now you can only lose
    GameState.playState = PlayingState.lost;
    gameRef.add(
      ExplosionComponent(
        position.clone()
          ..add(
            Vector2(size.x / 2, 0),
          ),
        angle: -angle,
      ),
    );
  }

  /// Restart the rocket.
  void reset() {
    position = gameRef.mehdiStartPosition;
    _collisionActive = false;
    _velocity.scale(0);
    current = MehdiState.idle;
    angle = 0;
    _fuel = 100;
    _flyingTime = 0;
  }
}
