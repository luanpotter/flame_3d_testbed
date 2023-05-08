import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_3d_testbed/flame3d/scene.dart';
import 'package:flame_3d_testbed/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

Matrix4 _cubeTransform(double angle) {
  final m1 = Matrix4.translation(-Vector3(0, 0, 20));
  final m2 = Matrix4.rotationX(angle);
  final m3 = Matrix4.rotationY(angle);
  final m4 = Matrix4.translation(Vector3(0, 0, 20));
  return m4.multiplied(m3).multiplied(m2).multiplied(m1);
}

class MyGame extends FlameGame with KeyboardEvents, TapCallbacks {
  static const cameraSpeed = 1000.0;
  static const rotSpeed = 0.1;

  late Scene scene;
  Vector2 move = Vector2.zero();
  double angle = 0;
  bool rotPaused = true;

  @override
  Future<void> onLoad() async {
    scene = Scene(screenSize: size);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    scene.projections.camera.position.x += move.x * dt * cameraSpeed;
    scene.projections.camera.position.y += move.y * dt * cameraSpeed;

    if (!rotPaused) {
      angle += rotSpeed * dt;
      while (angle >= tau) {
        angle -= tau;
      }
      scene.objects.first.transform.setFrom(_cubeTransform(angle));
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);
    scene.render(c);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    rotPaused = !rotPaused;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    readArrowLikeKeysIntoVector2(
      event,
      keysPressed,
      move,
      up: LogicalKeyboardKey.keyW,
      left: LogicalKeyboardKey.keyA,
      down: LogicalKeyboardKey.keyS,
      right: LogicalKeyboardKey.keyD,
    );
    return KeyEventResult.handled;
  }
}
