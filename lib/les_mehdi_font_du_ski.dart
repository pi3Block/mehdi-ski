import 'dart:math';

import 'package:flame/input.dart';
import 'package:les_mehdi_font_du_ski/components/audio_player.dart';
import 'package:les_mehdi_font_du_ski/components/mehdiSki_info.dart';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:les_mehdi_font_du_ski/components/mehdi_map_component.dart';
import 'package:les_mehdi_font_du_ski/components/mehdi_ski_joystick_player.dart';
import 'package:les_mehdi_font_du_ski/components/pause_component.dart';
import 'package:les_mehdi_font_du_ski/game_state.dart';
import 'package:les_mehdi_font_du_ski/overlays/joint.dart';

class LesMehdiFontDuSkiGame extends FlameGame with HasCollisionDetection, HasTappables, HasKeyboardHandlerComponents, HasDraggables {
  Vector2 _mehdiStartPosition = Vector2(0, 0);
  Vector2 get mehdiStartPosition => _mehdiStartPosition;
  int health = 1;
  int speed = 10;
  int tempo = 0;
  bool win = false;

  ///Interface to play audio
  late final MehdiSkiGameAudioPlayer audioPlayer;
  late final MehdiSkiJoystickPlayer _player;
  late final JoystickComponent joystick;

  late final TextPaint textPaint = TextPaint(
    style: TextStyle(
      fontSize: 48.0,
      fontFamily: 'Awesome Font',
    ),
  );

  ///The rocket component currnetly in the game
  MehdiSkiJoystickPlayer get player => _player;
  final pauseOverlayIdentifier = 'Pause';

  @override
  bool get debugMode => GameState.showDebugInfo;

  @override
  Future<void> onLoad() async {
    //await super.onLoad();
    //On charge les assets dans le cache
    await images.load('joystick.png');
    //camera.viewport = FixedHorizontalResolutionViewport(1200);
    //camera.viewport = FixedVerticalResolutionViewport(800);
    camera.viewport = FixedResolutionViewport(Vector2(800, 1200));
    //Init and load the audio assets
    audioPlayer = MehdiSkiGameAudioPlayer();
    await audioPlayer.loadAssets();

    initializeGame(true);
    return super.onLoad();
  }

  void initializeGame(bool loadHud) async {
    win = false;
/*     var myArbreList = new List<Arbre>.generate(100, (i) {
      return Arbre(position: Vector2(rnd.nextDouble() * 1000, rnd.nextDouble() * 1000));
    }); */

    final sheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('joystick.png'),
      columns: 6,
      rows: 1,
    );

    children.register<MehdiMapComponent>();
    await add(MehdiMapComponent(mapSeed: GameState.seed.hashCode));

    ///Ensure our joystick knob is between 50 and 100 based on view height
    ///Important its based on device size not viewport size
    ///8.2 is the "magic" hud joystick factor... ;)
    final knobSize = min(max(50, size.y / 8.2), 100).toDouble();

    final joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(knobSize),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(knobSize * 1.5),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    await add(
      PauseComponent(
        margin: const EdgeInsets.only(
          top: 10,
          left: 5,
        ),
        sprite: await Sprite.load('PauseButton.png'),
        spritePressed: await Sprite.load('PauseButtonInvert.png'),
        onPressed: () {
          if (overlays.isActive('levelSelection')) {
            return;
          }
          if (overlays.isActive('pause')) {
            overlays.remove('pause');
            if (GameState.playState == PlayingState.paused) {
              GameState.playState = PlayingState.playing;
            }
          } else {
            if (GameState.playState == PlayingState.playing) {
              GameState.playState = PlayingState.paused;
            }

            overlays.add('pause');
          }
        },
      ),
    );
    //overlays.addListener(onOverlayChanged);

    for (var i = 1; i <= health; i++) {
      final positionX = (size.x - 20) - (70 * i);
      await add(
        JointHealthComponent(
          jointNumber: i,
          position: Vector2(positionX.toDouble(), 10),
          size: Vector2(60, 70),
        ),
      );
    }

    _player = MehdiSkiJoystickPlayer(
      position: _mehdiStartPosition,
      size: Vector2(32, 52),
      joystick: joystick,
    );
/*     add(JointHealthComponent(
      jointNumber: 3,
      position: Vector2((size.x - ((size.x) / 10)), (size.y - ((size.y) / 10))),
      size: Vector2(32, 48),
    )); */
/*     if (loadHud) {
      add(Hud());
    }
 */
    camera.followComponent(_player, relativeOffset: Anchor(0.5, 0.2));
    await add(_player);
    await add(joystick);

    await add(MehdiSkiInfo(_player));

    add(TimerComponent(
      period: 10,
      repeat: true,
      onTick: () => print('10 seconds elapsed'),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (win) {
      //overlays.add('Win');
      GameState.playState = PlayingState.won;
      win = false;
      overlays.add('pause');
    }
  }

  void reset() {
    health = 1;
    win = false;
    initializeGame(false);
  }

  ///Load the level based on the given seed
  Future<void> loadLevel(String seed) async {
    restart();
    GameState.seed = seed;
    removeAll(children.query<MehdiMapComponent>());
    await add(MehdiMapComponent(mapSeed: seed.hashCode));
    overlays.clear();
  }

  /// Restart the current level.
  void restart() {
    GameState.playState = PlayingState.playing;
    (children.firstWhere((child) => child is MehdiSkiJoystickPlayer) as MehdiSkiJoystickPlayer).reset();
    children.query<MehdiMapComponent>().first.resetPowerups();
  }

  void onTap() {
    if (overlays.isActive('Pause')) {
      overlays.remove('Pause');
      GameState.playState = PlayingState.playing;
      resumeEngine();
    } else {
      overlays.add('Pause');

      GameState.playState = PlayingState.paused;
      pauseEngine();
    }
  }

  void set mehdiStartPosition(Vector2 mehdiStartPosition) {
    _mehdiStartPosition = mehdiStartPosition;
  }
}
