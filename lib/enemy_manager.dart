import 'package:flame/components.dart';
import 'package:game1/characters/bread.dart';
import 'package:game1/my_game.dart';

class BreadManager extends Component with HasGameRef<MyGame> {
  late Timer _timer;

  BreadManager() : super() {
    _timer = Timer(1, callback: _spawn, repeat: true);
  }

  _spawn() {
    gameRef.add(Bread.random(gameRef.size));
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }
}
