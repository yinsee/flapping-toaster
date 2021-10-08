import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:game1/my_game.dart';

class NightBackground extends ParallaxComponent<MyGame> {
  @override
  Future<void>? onLoad() async {
    parallax = await Parallax.load(
      [
        ParallaxImageData('bg0.png'),
        ParallaxImageData('bg1.png'),
      ],
      baseVelocity: Vector2(5, 0),
      velocityMultiplierDelta: Vector2(3.0, 0.0),
    );
  }
}
