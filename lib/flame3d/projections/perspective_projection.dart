import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/geom/plane3.dart';

class PerspectiveProjection {
  Vector2 screenSize;
  double fov;
  double zFar;
  double zNear;

  PerspectiveProjection({
    required this.screenSize,
    this.fov = pi / 4,
    this.zFar = 1000,
    this.zNear = 0.1,
  });

  Matrix4 get matrix {
    final a = screenSize.y / screenSize.x;
    final f = 1 / tan(fov / 2);
    final q = zFar / (zFar - zNear);
    return Matrix4.columns(
      Vector4(a * f, 0, 0, 0),
      Vector4(0, f, 0, 0),
      Vector4(0, 0, q, 1),
      Vector4(0, 0, -zNear * q, 0),
    );
  }

  Plane3 get zNearPlane => Plane3(
        point: Vector3(0, 0, zNear),
        normal: Vector3(0, 0, 1),
      );
}
