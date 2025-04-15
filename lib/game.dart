import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:pixelo_poc/components/camera_component.dart';
import 'package:pixelo_poc/world.dart';

import 'components/viewport_aware_component.dart';

const iterationComponentsCount = 5;

class PocGame extends FlameGame<MyWorld> {
  PocGame() : super(world: MyWorld());

  final StreamController<double> fpsStream = StreamController<double>.broadcast();
  final StreamController<int> objectCountStream = StreamController<int>.broadcast();

  final riveComponentsList = <PositionComponent>[];

  final spriteComponentsList = <PositionComponent>[];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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

    final componentsAdditionIteration = ((riveComponentsList.length + spriteComponentsList.length) / 4) - 1;

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
      final bombOptimised = ViewportAwareComponent(child: bombComponent);
      world.add(bombOptimised);
      riveComponentsList.add(bombOptimised);

      coinsComponent.position = Vector2(100 + k * 50, 200);
      final coinsOptimised = ViewportAwareComponent(child: coinsComponent);
      world.add(coinsOptimised);
      riveComponentsList.add(coinsOptimised);

      magnifierComponent.position = Vector2(100 + k * 50, 300);
      final magnifierOptimised = ViewportAwareComponent(child: magnifierComponent);
      world.add(magnifierOptimised);
      riveComponentsList.add(magnifierOptimised);

      widgetAllComponent.position = Vector2(100 + k * 50, 400);
      final widgetAllOptimised = ViewportAwareComponent(child: widgetAllComponent);
      world.add(widgetAllOptimised);
      riveComponentsList.add(widgetAllOptimised);
    }
    _updateObjectCount();
  }

  Future<void> spawnSpriteComponents() async {
    final barrelAnimationData = SpriteAnimationData.sequenced(amount: 4, amountPerRow: 4, stepTime: 0.15, textureSize: Vector2(50, 50));
    final archerAnimationData = SpriteAnimationData.sequenced(amount: 4, amountPerRow: 4, stepTime: 0.15, textureSize: Vector2(50, 50));
    final lightingAnimationData = SpriteAnimationData.sequenced(amount: 10, amountPerRow: 10, stepTime: 0.15, textureSize: Vector2(50, 50));
    final wallAnimationData = SpriteAnimationData.sequenced(amount: 6, amountPerRow: 6, stepTime: 0.15, textureSize: Vector2(50, 50));

    final barrelImage = await images.load('sprite_sheet/barrel.png');
    final archerImage = await images.load('sprite_sheet/archer.png');
    final lightingImage = await images.load('sprite_sheet/lighting.png');
    final wallImage = await images.load('sprite_sheet/wall.png');

    final componentsAdditionIteration = ((riveComponentsList.length + spriteComponentsList.length) / 4) - 1;

    for (int i = 0; i < iterationComponentsCount; i++) {
      final k = componentsAdditionIteration + i;

      final barrelComponent = SpriteAnimationComponent.fromFrameData(
        barrelImage,
        barrelAnimationData,
        size: Vector2(50, 50),
        key: ComponentKey.unique(),
      );

      barrelComponent.position = Vector2(100 + k * 50, 100);
      final barrelOptimised = ViewportAwareComponent(child: barrelComponent);

      world.add(barrelOptimised);
      spriteComponentsList.add(barrelOptimised);

      final archerComponent = SpriteAnimationComponent.fromFrameData(
        archerImage,
        archerAnimationData,
        size: Vector2(50, 50),
        key: ComponentKey.unique(),
      );

      archerComponent.position = Vector2(100 + k * 50, 200);
      final archerOptimised = ViewportAwareComponent(child: archerComponent);

      world.add(archerOptimised);
      spriteComponentsList.add(archerOptimised);

      final lightingComponent = SpriteAnimationComponent.fromFrameData(
        lightingImage,
        lightingAnimationData,
        size: Vector2(50, 50),
        key: ComponentKey.unique(),
      );

      lightingComponent.position = Vector2(100 + k * 50, 300);
      final lightingOptimised = ViewportAwareComponent(child: lightingComponent);

      world.add(lightingOptimised);
      spriteComponentsList.add(lightingOptimised);

      final wallComponent = SpriteAnimationComponent.fromFrameData(wallImage, wallAnimationData, size: Vector2(50, 50), key: ComponentKey.unique());

      wallComponent.position = Vector2(100 + k * 50, 400);
      final wallOptimised = ViewportAwareComponent(child: wallComponent);

      world.add(wallOptimised);
      spriteComponentsList.add(wallOptimised);
    }
    _updateObjectCount();
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

    _updateObjectCount();
  }

  Future<void> despawnSpriteComponents() async {
    if (spriteComponentsList.isEmpty) return;

    final length = spriteComponentsList.length;

    for (int i = 0; i < 20; i++) {
      final k = length - 1 - i;

      final component = spriteComponentsList[k];

      if (component.isMounted) {
        spriteComponentsList.remove(component);
        component.removeFromParent();
      }
    }

    _updateObjectCount();
  }

  void _updateObjectCount() {
    final objectsCount = (riveComponentsList.length + spriteComponentsList.length);

    objectCountStream.add(objectsCount);
  }
}
