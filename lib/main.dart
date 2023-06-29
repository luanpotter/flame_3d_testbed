import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_3d_testbed/flame3d/crosshair.dart';
import 'package:flame_3d_testbed/flame3d/objects/cuboid.dart';
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

class MyGame extends FlameGame
    with
        KeyboardEvents,
        TapDetector,
        SecondaryTapDetector,
        MouseMovementDetector {
  static const cameraMoveSpeed = 10.0;
  static const cameraLookSpeed = 0.8;
  static const rotSpeed = 0.1;

  late Scene scene;
  Vector2 move = Vector2.zero();
  Vector2 look = Vector2.zero();

  bool mouseMoveEnabled = false;
  Vector2? previousMousePos;
  double yawn = 0;
  double pitch = 0;

  double rotAngle = 0;
  bool rotPaused = false;

  @override
  Future<void> onLoad() async {
    scene = Scene(
      screenSize: size,
      objects: [
        Cuboid(
          center: Vector3(0, 0, 20),
          dimensions: Vector3.all(4.0),
        ),
        // await ObjParser.parse(
        //   fileName: 'objs/teapot.obj',
        //   transform: Matrix4.translation(Vector3(30, 0, 20)),
        // ),
      ],
    );
    add(Crosshair());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final camera = scene.projections.camera;
    camera.position -= camera.direction * move.y * cameraMoveSpeed * dt;
    camera.position += camera.right * move.x * cameraMoveSpeed * dt;

    yawn += look.x * cameraLookSpeed * dt;
    pitch -= look.y * cameraLookSpeed * dt;
    yawn %= tau;
    pitch %= tau;
    camera.lookAt(yawn: yawn, pitch: pitch);

    if (!rotPaused) {
      rotAngle += rotSpeed * dt;
      while (rotAngle >= tau) {
        rotAngle -= tau;
      }
      scene.objects.first.transform.setFrom(_cubeTransform(rotAngle));
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);
    scene.render(c);
  }

  @override
  void onTapDown(TapDownInfo event) {
    super.onTapDown(event);
    rotPaused = !rotPaused;
  }

  @override
  void onSecondaryTapDown(TapDownInfo info) {
    super.onSecondaryTapDown(info);
    final camera = scene.projections.camera;
    camera.position = Vector3.zero();
    pitch = 0;
    yawn = 0;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    super.onMouseMove(info);
    final position = info.eventPosition.game;
    final previous = previousMousePos;
    if (previous != null && mouseMoveEnabled) {
      final delta = position - previous;
      final halfScreen = canvasSize / 2;
      pitch += delta.y / halfScreen.y * pi / 2;
      yawn -= delta.x / halfScreen.x * pi / 20;
    }
    previousMousePos = position;
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
    readArrowLikeKeysIntoVector2(
      event,
      keysPressed,
      look,
      up: LogicalKeyboardKey.keyI,
      left: LogicalKeyboardKey.keyJ,
      down: LogicalKeyboardKey.keyK,
      right: LogicalKeyboardKey.keyL,
    );
    return KeyEventResult.handled;
  }

  double moveTowards(
    double current,
    double target,
    double maxDelta,
  ) {
    final diff = target - current;
    if (diff == 0) {
      return current;
    } else if (diff > 0) {
      final step = target - current;
      return current + step.clamp(0, maxDelta);
    } else {
      final step = current - target;
      return current - step.clamp(0, maxDelta);
    }
  }
}
