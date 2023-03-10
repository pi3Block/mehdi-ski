import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:les_mehdi_font_du_ski/components/drapeau.dart';
import 'package:les_mehdi_font_du_ski/components/line_component.dart';
import 'package:les_mehdi_font_du_ski/components/powerup_component.dart';
import 'package:les_mehdi_font_du_ski/les_mehdi_font_du_ski.dart';
import 'package:les_mehdi_font_du_ski/terrain_generator.dart';

/// Map rendering component.
class MehdiMapComponent extends Component with HasGameRef<LesMehdiFontDuSkiGame> {
  /// Map rendering component.
  MehdiMapComponent({
    this.heightOfMap = 200,
    this.mapSeed,
  });

  /// The seed used for terrain generation.
  final int? mapSeed;

  /// Length of the map in grid units.
  final double heightOfMap;

  /// Length of the map in grid units.
  late final double mehdiStartPos;

  /// The workable grid sizes.
  static final grid = Vector2(40, 30);

  Vector2 positionMehdi = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    children.register<PowerupComponent>();
    children.register<Drapeau>();
    // Size of a single item in the grid.
    final itemSize = gameRef.size.clone()..divide(MehdiMapComponent.grid);
    final amountOfDrapeauSpot = 5;

    List<PositionComponent> monTerrain = TerrainGenerator(
      size: Vector2(grid.x, heightOfMap),
      //amountOfLandingSpots: 10,
      amountOfPowerups: 20,
      amountOfDrapeauSpot: amountOfDrapeauSpot,
      amountOfTree: 20,
      minEntreWidthMontagneX: (((grid.x).toInt()) / 6),
      maxEntreWidthMontagneX: ((grid.x).toInt() / 3),
      minEntreHeightDrapeauxY: heightOfMap / amountOfDrapeauSpot,
      seed: mapSeed,
    ).generate(itemSize, Vector2(gameRef.size.x, gameRef.size.y * heightOfMap));

    //List<PositionComponent> monTerrain pour trouver le départ et placer mehdi
    chercheMehdi(monTerrain);
    gameRef.mehdiStartPosition = Vector2(positionMehdi.x * itemSize.x, positionMehdi.y * itemSize.y);

    unawaited(
      addAll(monTerrain),
    );

    // Set the world bounds to the max size of the map.
    gameRef.camera.worldBounds = Rect.fromLTWH(
      0,
      0,
      grid.x * itemSize.x,
      heightOfMap * itemSize.y,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    drawGrid(canvas);
  }

//On cherhce le depart de mehdi
  void chercheMehdi(List<PositionComponent> monTerrain) {
    double positionMontagneGauche = 2;
    double positionMontagneDropite = 0;
    for (var ligne in monTerrain) {
      if (ligne is LineComponent) {
        if (ligne.isGoal) {
          if (positionMontagneGauche == 2) {
            positionMontagneGauche = ligne.startPos.x;
          } else if (positionMontagneDropite == 0 && positionMontagneGauche != 2) {
            positionMontagneDropite = ligne.startPos.x;
          }
          if (positionMontagneDropite > positionMontagneGauche) {
            //Todo 5 a remplacer par depart index
            positionMehdi = Vector2((positionMontagneGauche + ((positionMontagneDropite - positionMontagneGauche) / 2)), 5);
          }
        }
      }
    }
  }

  ///Reset all powerups of the current map
  void resetPowerups() {
    if (hasChildren) {
      children.query<PowerupComponent>().forEach((element) {
        element.used = false;
      });
      children.query<Drapeau>().forEach((element) {
        element.current = DrapeauState.notPassed;
      });
      //mehdiStartPos = children.query<PowerupComponent>;
    }
  }

  ///Retrouve la bonne position pour  le joueur
/*   void mehdiPositionStart() {
    gameRef._mehdiStartPosition = ;
  } */

  /// If in debug mode draws the grid.
  void drawGrid(Canvas canvas) {
    if (!gameRef.debugMode) {
      return;
    }
    // Size of a single item in the grid.
    final itemSize = gameRef.size.clone()..divide(grid);

    for (var y = 0; y < heightOfMap; y++) {
      for (var x = 0; x < grid.x; x++) {
        canvas.drawRect(
          Rect.fromLTWH(x * itemSize.x, y * itemSize.y, itemSize.x, itemSize.y),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.pink
            ..strokeWidth = .1,
        );
      }
    }
  }
}
