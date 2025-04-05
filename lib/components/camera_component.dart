import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixelo_poc/game.dart';

class MoveCameraComponent extends PositionComponent with HasGameRef<PocGame>, DragCallbacks {
   MoveCameraComponent({super.size});

  Vector2? lastDragPosition;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    lastDragPosition = event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (lastDragPosition != null) {
      final delta = event.localEndPosition - lastDragPosition!;
      gameRef.camera.moveBy(-delta);
      lastDragPosition = event.localEndPosition;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    lastDragPosition = null;
  }
}
