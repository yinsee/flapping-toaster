import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:game1/background/night.dart';
import 'package:game1/characters/bread.dart';
import 'package:game1/characters/toaster.dart';
import 'package:game1/enemy_manager.dart';

class MyGame extends FlameGame with TapDetector, HasCollidables {
  int score = 0;
  final toaster = Toaster();
  final enemies = BreadManager();
  final bg = NightBackground();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    add(bg);
    add(enemies);
    add(toaster);
  }

  TextPainter tp = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    tp.text = TextSpan(
      text: score.toString(),
      style: const TextStyle(
        color: Color(0xffffffff),
        fontSize: 15,
        fontFamily: 'PressStart2P',
      ),
    );
    tp.layout();
    tp.paint(canvas, Offset(size.x / 2, 10));
  }

  @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    toaster.jump();
    return true;
  }
}
