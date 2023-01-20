import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:les_mehdi_font_du_ski/components/arbre.dart';
import 'package:les_mehdi_font_du_ski/components/drapeau.dart';

import 'components/line_component.dart';

/// Terrain generator.
///
/// Based on: https://gamedev.stackexchange.com/a/93531
class TerrainGenerator {
  /// Terrain generator.
  TerrainGenerator({
    this.maxEcartWidth = 4,
    this.ecartWidth = 1,
    this.largeurMontagne = 5.0,
    required this.size,
    this.seed,
    required this.amountOfLandingSpots,
    required this.amountOfDrapeauSpot,
    required this.amountOfPowerups,
    required this.amountOfTree,
    required this.minEntreWidthMontagneX,
    required this.minEntreHeightDrapeauxY,
    required this.maxEntreWidthMontagneX,
  }) {
    _random = Random(seed);
    assert(size.x > maxEntreWidthMontagneX, 'MaxPowerupHeight must be above size.x');
  }

  /// Determines the max step.
  final double maxEcartWidth;

  /// The amount a step can change.
  final double ecartWidth;

  /// The amount a step can change.
  final double largeurMontagne;

  /// Amount of landing spots the terrain will generate.
  final int amountOfLandingSpots;

  /// Amount of landing spots the terrain will generate.
  final int amountOfDrapeauSpot;

  ///Amount of powerups
  final int amountOfPowerups;

  ///Amount of powerups
  final int amountOfTree;

  ///Minimum entre chaque montagne
  final double minEntreWidthMontagneX;

  ///Minimum entre chaque montagne
  final double maxEntreWidthMontagneX;

  ///Minimum hauteur entre chaque Drapeaux
  final double minEntreHeightDrapeauxY;

  /// Size of the terrain.
  final Vector2 size;

  /// Seed used for the [Random]ness.
  final int? seed;

  late final Random _random;

  /// Generate list of points that represent the terrain.
  List<PositionComponent> generate(
    Vector2 itemSize,
    Vector2 gamzeSize,
  ) {
    // The initial starting values.
    var milieu = size.x / 2;
    var max = size.x;
    // Montagne gauche entre 0 et size.x/2
    //var montagneGaucheX = _random.nextDouble() * milieu;
    var montagneGaucheX = max / 4;

//Montagne droite entre montagneGauche + min / montagneGauche + max
    var premierDeltaMontagne = milieu;
    var DeltaMontagne = (_random.nextDouble() * montagneGaucheX).clamp(minEntreWidthMontagneX, maxEntreWidthMontagneX);
    var montagneDroiteX = max - montagneGaucheX;

    // Montagne droite entre  size.x/2 et size.x
/*     var montagneDroiteX = milieu - (_random.nextDouble() * (milieu)); */
    //Si montagne droite - montagne gauche > min
//montagne droite = montagne gauche
    //Si montagne droite - montagne gauche < maxi

/*     var montagneMinDroiteX = montagneMaxGaucheX + largeurMontagne;

    if (montagneGaucheX > montagneMaxGaucheX) {
      montagneGaucheX = montagneMaxGaucheX;
    } else if (montagneMinDroiteX > montagneDroiteX) {
      montagneDroiteX = montagneMinDroiteX;
    } */
    //Keep the slope in the range of -maxStep to maxStep
    var slopeGauche = lerpDouble(-maxEcartWidth, maxEcartWidth, _random.nextDouble())!;
    var slopeDroite = lerpDouble(-maxEcartWidth, maxEcartWidth, _random.nextDouble())!;

    final pointsGauche = <Vector2>[];

    final pointsDroite = <Vector2>[];

/* //Landing spot
    final landingSpots = <int>[];
    while (landingSpots.length < amountOfLandingSpots) {
      final index = _random.nextInt(size.y.toInt());
      if (!landingSpots.contains(index)) {
        landingSpots.add(index);
      }
    } */

//Drapeau
    final drapeauSpots = <Drapeau>[];
    while (drapeauSpots.length < amountOfDrapeauSpot) {
      final xDrapeau = _random.nextInt(size.x.toInt());
      final yDrapeau = _random.nextInt(size.y.toInt());
      if (!drapeauSpots.any((element) => element.position.y == yDrapeau.toDouble() / itemSize.y)) {
        drapeauSpots.add(
          Drapeau(
            position: Vector2(
              xDrapeau.toDouble() * itemSize.x,
              yDrapeau.toDouble() * itemSize.y,
            ),
          ),
        );
      }
    }
    //Dernier drapeaux est arrivée
    drapeauSpots.first.isGoal = true;

    //PowerUp
/*     final powerUps = <PositionComponent>[];
    while (powerUps.length < amountOfPowerups) {
      final x = _random.nextInt(size.x.toInt());
      final y = _random.nextInt(size.y.toInt());
      if (!powerUps.any((element) => element.position.y == y.toDouble() / itemSize.y)) {
        powerUps.add(
          PowerupFuelComponent(
            position: Vector2(
              x.toDouble() * itemSize.x,
              y.toDouble() * itemSize.y,
            ),
          ),
        );
      }
    } */
    //Arbre
    final arbres = <Arbre>[];
    while (arbres.length < amountOfTree) {
      final x = _random.nextInt(size.x.toInt());
      final y = _random.nextInt(size.y.toInt());
      if (!arbres.any((element) => element.position.y == y.toDouble() / itemSize.y)) {
        arbres.add(
          Arbre(
            position: Vector2(
              x.toDouble() * itemSize.x,
              y.toDouble() * itemSize.y,
            ),
          ),
        );
      }
    }
//On parcours le block ligne a horizontal
//On applique la ligne atterissage  à la ligne gauche et droite
    for (var ligne = 0.0; ligne <= size.y; ligne++) {
/*       if (landingSpots.contains(y)) {
        pointsGauche.add(Vector2(montagneGaucheX, y));
        pointsDroite.add(Vector2(montagneDroiteX, y));
        continue;
      } */
      //On applique la ligne drapeaux à la ligne gauche ou droite
/*       if (drapeauSpots.contains(y)) {
        pointsDrapeaux.add(Vector2(montagneGaucheX, y));
        continue;
      } */

      // Update the height by adding the previous slope.
      montagneGaucheX += slopeGauche;
      // Update the height by adding the previous slope.
      montagneDroiteX += slopeDroite;

      // Update the slope by a random step change.
      //slopeGauche += lerpDouble(-stepChange, stepChange, _random.nextDouble())!;

      slopeGauche = lerpDouble(-ecartWidth, ecartWidth, _random.nextDouble())!;
      slopeDroite = lerpDouble(-ecartWidth, ecartWidth, _random.nextDouble())!;

      // Clamp the slope to the max step.
      slopeGauche = slopeGauche.clamp(-maxEcartWidth, maxEcartWidth);
      slopeDroite = slopeDroite.clamp(-maxEcartWidth, maxEcartWidth);

      // Si montagne gauche < 0 on inverse le slope
      if (montagneGaucheX < 0) {
        montagneGaucheX = 0;
        slopeGauche *= -1;
      } else if (montagneDroiteX > max) {
        // Si montagne droite > size.x on inverse le slope
        montagneDroiteX = max;
        slopeDroite *= -1;
      } else if (montagneGaucheX > max / 2) {
        // Si montagne droite > size.x on inverse le slope
        slopeGauche *= -1;
        montagneGaucheX += slopeGauche;
      }
      // Si montagne droite - montagne gauche < minEcart
      if (montagneDroiteX - montagneGaucheX < minEntreWidthMontagneX) {
        montagneDroiteX = _nextDoubleBetween(montagneGaucheX + minEntreWidthMontagneX, montagneGaucheX + maxEntreWidthMontagneX);
      } else if (montagneDroiteX - montagneGaucheX > maxEntreWidthMontagneX) {
        // Si montagne droite - montagne gauche > maxEcart
        // montagneDroiteX = montagneGaucheX + maxEntreWidthMontagneX;
        montagneDroiteX = _nextDoubleBetween(montagneGaucheX + minEntreWidthMontagneX, montagneGaucheX + maxEntreWidthMontagneX);
      }
      pointsGauche.add(Vector2(montagneGaucheX, ligne));
      pointsDroite.add(Vector2(montagneDroiteX, ligne));
    }

    return [
      for (var i = 1; i < pointsGauche.length; i++)
        LineComponent(
          pointsGauche[i - 1],
          pointsGauche[i],
          //isGoal: landingSpots.contains(i),
        ),
      for (var i = 1; i < pointsDroite.length; i++)
        LineComponent(
          pointsDroite[i - 1],
          pointsDroite[i],
          //isGoal: landingSpots.contains(i),
        ),
      //...powerUps,
      ...arbres,
      ...drapeauSpots,
    ];
  }

  int _nextBetween(int min, int max) => min + _random.nextInt(max - min);
  double _nextDoubleBetween(double min, double max) => min + (_random.nextDouble() * (max - min));
}
