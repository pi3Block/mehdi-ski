/* import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:les_mehdi_font_du_ski/components/arbre.dart';
import 'package:les_mehdi_font_du_ski/components/drapeau.dart';

import 'components/powerup_fuel_component.dart';
import 'components/line_component.dart';

/// Terrain generator.
///
/// Based on: https://gamedev.stackexchange.com/a/93531
class TerrainGenerator {
  /// Terrain generator.
  TerrainGenerator({
    this.maxStep = 1.5,
    this.stepChange = 0.5,
    this.largeurMontagne = 5.0,
    required this.size,
    this.seed,
    required this.amountOfLandingSpots,
    required this.amountOfDrapeauSpot,
    required this.amountOfPowerups,
    required this.amountOfTree,
    required this.maxPowerupWidth,
  }) {
    _random = Random(seed);
    assert(size.x < maxPowerupWidth, 'MaxPowerupHeight must be above size.y');
  }

  /// Determines the max step.
  final double maxStep;

  /// The amount a step can change.
  final double stepChange;

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

  ///Maximum powerup height
  final int maxPowerupWidth;

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
    var montagneGaucheX = _random.nextDouble() * (size.x / 6);
    var montagneMaxGaucheX = size.x / (3);
    var montagneMinDroiteX = montagneMaxGaucheX + largeurMontagne;
    var montagneDroiteX = size.x - (_random.nextDouble() * ((size.x / 6)));
    if (montagneGaucheX > montagneMaxGaucheX) {
      montagneGaucheX = montagneMaxGaucheX;
    } else if (montagneMinDroiteX > montagneDroiteX) {
      montagneDroiteX = montagneMinDroiteX;
    }
    //Keep the slope in the range of -maxStep to maxStep
    var slopeGauche = lerpDouble(-maxStep, maxStep, _random.nextDouble())!;
    var slopeDroite = lerpDouble(-maxStep, maxStep, _random.nextDouble())!;

    final pointsGauche = <Vector2>[];

    final pointsDroite = <Vector2>[];

    final pointsDrapeaux = <Vector2>[];

//Landing spot
    final landingSpots = <int>[];
    while (landingSpots.length < amountOfLandingSpots) {
      final index = _random.nextInt(size.y.toInt());
      if (!landingSpots.contains(index)) {
        landingSpots.add(index);
      }
    }

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
    drapeauSpots.last.isGoal = true;

    //PowerUp
    final powerUps = <PositionComponent>[];
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
    }
    //Arbre
    final arbres = <PositionComponent>[];
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
    for (var y = 0.0; y <= size.y; y++) {
      if (landingSpots.contains(y)) {
        pointsGauche.add(Vector2(montagneGaucheX, y));
        pointsDroite.add(Vector2(montagneDroiteX, y));
        continue;
      }
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
      slopeGauche += lerpDouble(-stepChange, stepChange, _random.nextDouble())!;
      slopeDroite += lerpDouble(-stepChange, stepChange, _random.nextDouble())!;

      // Clamp the slope to the max step.
      slopeGauche = slopeGauche.clamp(-maxStep, maxStep);
      slopeDroite = slopeDroite.clamp(-maxStep, maxStep);

      // If the height is bigger than the size height, clip it and
      // reverse the slope.
      if (montagneGaucheX > size.x || montagneGaucheX > montagneMaxGaucheX) {
        montagneGaucheX = montagneMaxGaucheX;
        slopeGauche *= -1;
      } else if (montagneDroiteX > size.x || montagneMinDroiteX > montagneDroiteX) {
        montagneDroiteX = montagneMinDroiteX;
        slopeDroite *= 1;
      }
      // If the height is smaller than zero, clip it and reverse the slope.
      if (montagneGaucheX < 0) {
        montagneGaucheX = 0;
        slopeGauche *= 1;
      } else if (montagneDroiteX > size.x) {
        montagneDroiteX = size.x;
        slopeDroite *= -1;
      }

      if (montagneGaucheX > montagneMaxGaucheX) {
        montagneGaucheX = montagneMaxGaucheX;
        slopeGauche *= 1;
        montagneGaucheX += slopeGauche;
      } else if (montagneMinDroiteX > montagneDroiteX) {
        montagneDroiteX = montagneMinDroiteX;
      }
      pointsGauche.add(Vector2(montagneGaucheX, y));
      pointsDroite.add(Vector2(montagneDroiteX, y));
    }

    return [
      for (var i = 1; i < pointsGauche.length; i++)
        LineComponent(
          pointsGauche[i - 1],
          pointsGauche[i],
          isGoal: landingSpots.contains(i),
        ),
      for (var i = 1; i < pointsDroite.length; i++)
        LineComponent(
          pointsDroite[i - 1],
          pointsDroite[i],
          isGoal: landingSpots.contains(i),
        ),
      ...powerUps,
      ...arbres,
      ...drapeauSpots,
    ];
  }

  int _nextBetween(int min, int max) => min + _random.nextInt(max - min);
}
 */