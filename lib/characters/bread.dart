import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';

class Bread extends SpriteAnimationComponent with Hitbox, Collidable {
  num velocity = -10;
  Bread.random(size) {
    final r = Random();
    x = size.x + 100;
    y = r.nextDouble() * size.y;
    velocity = r.nextDouble() * -200 - 10;
  }

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.center;
    animation = await SpriteAnimation.load(
      'bread.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.1,
        textureSize: Vector2.all(100),
      ),
    );
    size = Vector2.all(100);

    collidableType = CollidableType.passive;
    final shape = HitboxPolygon([
      Vector2(0, 0.5),
      Vector2(0.5, 0),
      Vector2(0, -0.5),
      Vector2(-0.5, 0),
    ]);
    addHitbox(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    x += velocity * dt;
    if (x < -size.x) {
      shouldRemove = true;
    }
  }
}
