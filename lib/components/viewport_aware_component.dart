import 'package:flame/components.dart';
import 'package:pixelo_poc/game.dart';

class ViewportAwareComponent extends PositionComponent with HasGameRef<PocGame> {
  ViewportAwareComponent({required this.child, super.key});

  final PositionComponent child;
  late final childRect = child.toRect();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(child);
  }

  @override
  void update(double dt) {
    final visibleRect = gameRef.camera.visibleWorldRect;

    final childVisible = visibleRect.overlaps(childRect);
    if (childVisible && !child.isMounted) {
      final world = gameRef.camera.world;
      world?.add(child);
    } else if (!childVisible && child.isMounted) {
      child.removeFromParent();
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    child.removeFromParent();
  }
}
