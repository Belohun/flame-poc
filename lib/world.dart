import 'package:flame/components.dart';
import 'package:pixelo_poc/components/background_component.dart';

import 'game.dart';

class MyWorld extends World with HasGameRef<PocGame> {
  @override
  Future<void> onLoad() async {


    final backgroundComponent = BackgroundComponent();



    add(backgroundComponent);
  }
}
