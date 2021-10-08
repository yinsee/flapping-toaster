import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:game1/characters/bread.dart';
import 'package:game1/my_game.dart';

enum ToasterState { run, attack }

class Toaster extends SpriteAnimationComponent
    with Hitbox, Collidable, HasGameRef<MyGame> {
  num velocity = 0;
  final num jumpvelocity = 200;
  final num gravity = 200;
  double bottom = 0;

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gravity * dt;
    y += velocity * dt;
    angle = velocity * 0.001;
    if (y >= bottom) {
      // hit the ground, stop acceleration
      y = bottom;
      velocity = -gravity * 0.5;
    }
  }

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    animation = await SpriteAnimation.load(
      'sprite.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(100),
      ),
    );

    flipHorizontally();
    size = Vector2.all(100);

    //
    collidableType = CollidableType.active;
    addHitbox(HitboxCircle(definition: 0.5));
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    position = gameSize / 2;
    bottom = gameSize.y * 0.95;
  }

  jump() {
    if (y > size.y) velocity = -jumpvelocity;
  }

  @override
  void onCollision(_, Collidable other) {
    if (other is Bread) {
      gameRef.score++;
      other.collidableType = CollidableType.inactive;
      other.shouldRemove = true;

      gameRef.add(
        ParticleComponent(
          TranslatedParticle(
            offset: other.position,
            child: fireworkParticle(),
          ),
        ),
      );
    }
  }

// particles
  Random rnd = Random();
  Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 200;

  Color randomMaterialColor() {
    return Colors.primaries[rnd.nextInt(Colors.primaries.length)];
  }

  Vector2 get cellSize => size;
  Vector2 get halfCellSize => cellSize / 2;
  Vector2 randomCellVector2() {
    return (Vector2.random() - Vector2.random())..multiply(cellSize);
  }

  Particle fireworkParticle() {
    // A pallete to paint over the "sky"
    final paints = [
      Colors.amber,
      Colors.amberAccent,
      Colors.red,
      Colors.redAccent,
      Colors.yellow,
      Colors.yellowAccent,
      // Adds a nice "lense" tint
      // to overall effect
      Colors.blue,
    ].map((color) => Paint()..color = color).toList();
    T randomElement<T>(List<T> list) {
      return list[rnd.nextInt(list.length)];
    }

    return Particle.generate(
      generator: (i) {
        final initialSpeed = randomCellVector2();
        final deceleration = initialSpeed * -1;
        final gravity = Vector2(0, this.gravity.toDouble());

        return AcceleratedParticle(
          speed: initialSpeed,
          acceleration: deceleration + gravity,
          child: ComputedParticle(renderer: (canvas, particle) {
            final paint = randomElement(paints);
            // Override the color to dynamically update opacity
            paint.color = paint.color.withOpacity(1 - particle.progress);

            canvas.drawCircle(
              Offset.zero,
              // Closer to the end of lifespan particles
              // will turn into larger glaring circles
              rnd.nextDouble() * particle.progress > .6
                  ? rnd.nextDouble() * (50 * particle.progress)
                  : 2 + (3 * particle.progress),
              paint,
            );
          }),
        );
      },
    );
  }
}
