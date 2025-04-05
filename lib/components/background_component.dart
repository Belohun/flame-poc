import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:pixelo_poc/game.dart';

class BackgroundComponent extends SpriteComponent with HasGameRef<PocGame> {
  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load('background.png');
    gameRef.camera.viewport.size = background.size;

    final cameraBounds = Rectangle.fromLTRB(0, 0, background.size.x, background.size.y);
    game.camera.setBounds(cameraBounds);
    sprite = Sprite(background);
  }
}
