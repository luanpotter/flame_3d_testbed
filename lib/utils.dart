import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';

const tau = 2 * pi;

Vector3 transformVector(Vector3 i, Matrix4 m) {
  final w = i.x * m.m14 + i.y * m.m24 + i.z * m.m34 + m.m44;
  final d = w == 0 ? 1 : w;
  return Vector3(
    (i.x * m.m11 + i.y * m.m21 + i.z * m.m31 + m.m41) / d,
    (i.x * m.m12 + i.y * m.m22 + i.z * m.m32 + m.m42) / d,
    (i.x * m.m13 + i.y * m.m23 + i.z * m.m33 + m.m43) / d,
  );
}

Matrix4 trt(Vector3 p, Matrix4 r) {
  final t1 = Matrix4.translation(-p);
  final t2 = Matrix4.translation(p);
  return t2.multiplied(r).multiplied(t1);
}

void readArrowLikeKeysIntoVector2(
  RawKeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
  Vector2 vector, {
  required LogicalKeyboardKey up,
  required LogicalKeyboardKey down,
  required LogicalKeyboardKey left,
  required LogicalKeyboardKey right,
}) {
  final isDown = event is RawKeyDownEvent;
  if (event.logicalKey == up) {
    if (isDown) {
      vector.y = -1;
    } else if (keysPressed.contains(down)) {
      vector.y = 1;
    } else {
      vector.y = 0;
    }
  } else if (event.logicalKey == down) {
    if (isDown) {
      vector.y = 1;
    } else if (keysPressed.contains(up)) {
      vector.y = -1;
    } else {
      vector.y = 0;
    }
  } else if (event.logicalKey == left) {
    if (isDown) {
      vector.x = -1;
    } else if (keysPressed.contains(right)) {
      vector.x = 1;
    } else {
      vector.x = 0;
    }
  } else if (event.logicalKey == right) {
    if (isDown) {
      vector.x = 1;
    } else if (keysPressed.contains(left)) {
      vector.x = -1;
    } else {
      vector.x = 0;
    }
  }
}
