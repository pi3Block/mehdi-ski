import 'dart:async';

import '/widgets/enter_seed.dart';
import '/widgets/highscore.dart';
import '/widgets/levels.dart';
import '/widgets/pause_menu.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'database/native.dart';
import 'game_state.dart';
import 'les_mehdi_font_du_ski.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  GameState.database = constructDb();
  GameState.seed = 'FlameRocks';
  final game = LesMehdiFontDuSkiGame();
  if (!kIsWeb) {
    //await MobileAds.instance.initialize();
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        ///From here https://www.dafont.com/de/aldo-the-apache.font
        fontFamily: 'AldotheApache',
      ),
      home: GameWidget(
        game: game,
        //Work in progress loading screen on game start
        loadingBuilder: (context) => const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        //Work in progress error handling
        errorBuilder: (context, ex) {
          //Print the error in th dev console
          debugPrint(ex.toString());
          return const Material(
            child: Center(
              child: Text('Sorry, something went wrong. Reload me'),
            ),
          );
        },
        overlayBuilderMap: {
          'pause': (context, LesMehdiFontDuSkiGame game) => PauseMenu(game: game),
          'levelSelection': (context, LesMehdiFontDuSkiGame game) => LevelSelection(
                game,
              ),
          'highscore': (context, LesMehdiFontDuSkiGame game) => HighscoreOverview(game),
          'enterSeed': (context, LesMehdiFontDuSkiGame game) => EnterSeed(game),
        },
      ),
    ),
  );
}
