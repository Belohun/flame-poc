import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:pixelo_poc/components/camera_component.dart';
import 'package:pixelo_poc/world.dart';

const iterationComponentsCount = 5;

class PocGame extends FlameGame<MyWorld> {
  PocGame() : super(world: MyWorld());

  final StreamController<double> fpsStream = StreamController<double>.broadcast();
  final StreamController<int> objectCountStream = StreamController<int>.broadcast();

  final riveComponentsList = <RiveComponent>[];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport.anchor = Anchor.center;
    add(MoveCameraComponent(size: size));
    overlays.add("fpsCounter");
    overlays.add("spawnMenu");
    overlays.add("objectsCounter");
  }

  @override
  void update(double dt) {
    super.update(dt);

    final fpsCount = 1 / dt;
    fpsStream.add(fpsCount);
  }

  Future<void> spawnRiveComponents() async {
    final bomb = await loadArtboard(RiveFile.asset('assets/rive/Bomb.riv'));
    final coins = await loadArtboard(RiveFile.asset('assets/rive/Coins.riv'));
    final magnifier = await loadArtboard(RiveFile.asset('assets/rive/Magnifier.riv'));
    final widgetAll = await loadArtboard(RiveFile.asset('assets/rive/Widget_All.riv'));

    final componentsAdditionIteration = (riveComponentsList.length / 4) - 1;

    for (int i = 0; i < iterationComponentsCount; i++) {
      final coinsComponent = RiveComponent(artboard: coins, key: ComponentKey.unique(), size: Vector2(50, 50));
      final magnifierComponent = RiveComponent(artboard: magnifier, key: ComponentKey.unique(), size: Vector2(50, 50));
      final widgetAllComponent = RiveComponent(artboard: widgetAll, key: ComponentKey.unique(), size: Vector2(50, 50));
      final bombComponent = RiveComponent(artboard: bomb, key: ComponentKey.unique(), size: Vector2(50, 50));

      final coinsController = SimpleAnimation(coins.name);
      final magnifierController = SimpleAnimation(magnifier.name);
      final widgetAllController = SimpleAnimation(widgetAll.name);
      final bombController = SimpleAnimation(bomb.name);

      coins.addController(coinsController);
      magnifier.addController(magnifierController);
      widgetAll.addController(widgetAllController);
      bomb.addController(bombController);

      final k = componentsAdditionIteration + i;

      bombComponent.position = Vector2(100 + k * 50, 100);
      world.add(bombComponent);
      riveComponentsList.add(bombComponent);

      coinsComponent.position = Vector2(100 + k * 50, 200);
      world.add(coinsComponent);
      riveComponentsList.add(coinsComponent);

      magnifierComponent.position = Vector2(100 + k * 50, 300);
      world.add(magnifierComponent);
      riveComponentsList.add(magnifierComponent);

      widgetAllComponent.position = Vector2(100 + k * 50, 400);
      world.add(widgetAllComponent);
      riveComponentsList.add(widgetAllComponent);
    }

    objectCountStream.add(riveComponentsList.length);
  }

  Future<void> despawnRiveComponents() async {
    if (riveComponentsList.isEmpty) return;

    final length = riveComponentsList.length;

    for (int i = 0; i < 20; i++) {
      final k = length - 1 - i;

      final component = riveComponentsList[k];

      if (component.isMounted) {
        riveComponentsList.remove(component);
        component.removeFromParent();
      }
    }

    objectCountStream.add(riveComponentsList.length);
  }
}
