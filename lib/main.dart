import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game1/my_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final game = MyGame();
  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final MyGame game;
  const MyApp(this.game, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameWidget<MyGame>(game: game),
    );
  }
}
