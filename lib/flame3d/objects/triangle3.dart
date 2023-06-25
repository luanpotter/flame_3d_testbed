import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flame_3d_testbed/flame3d/camera/camera.dart';
import 'package:flame_3d_testbed/flame3d/camera/projections.dart';
import 'package:flame_3d_testbed/flame3d/geom/plane3.dart';
import 'package:flame_3d_testbed/utils.dart';

final _zNearPlane = Plane3(
  point: Vector3.zero(),
  normal: Vector3(0, 0, 1),
);

class Triangle3 {
  Vector3 p0;
  Vector3 p1;
  Vector3 p2;

  Triangle3(this.p0, this.p1, this.p2);

  Triangle3.list(List<Vector3> list)
      : assert(list.length == 3),
        p0 = list[0],
        p1 = list[1],
        p2 = list[2];

  Vector3 get normal {
    final a = p1 - p0;
    final b = p2 - p0;
    return a.cross(b)..normalize();
  }

  bool isCulled(Camera camera) {
    final cameraLook = p0 - camera.position;
    return normal.dot(cameraLook) < 0;
  }

  Triangle3 transform(Projections p) {
    final m = p.matrix;
    return Triangle3(
      toScreen(transformVector(p0, m), p),
      toScreen(transformVector(p1, m), p),
      toScreen(transformVector(p2, m), p),
    );
  }

  void render(Canvas c, Projections p) {
    if (false && isCulled(p.camera)) {
      return;
    }

    final clipped = clipZ(p.camera);
    final screenTriangles = clipped.map((e) => e.transform(p));
    for (final t in screenTriangles) {
      for (final clipped in t.clipScreen(p.screenSize)) {
        clipped._render(c, p);
      }
    }
  }

  void _render(Canvas c, Projections p) {
    final points = [p0, p1, p2].map((e) => Offset(e.x, e.y)).toList();
    final path = Path()..addPolygon(points, true);

    // final luminance = (normal.dot(_light) + 1) / 2;
    // final fill = BasicPalette.white.paint()
    //   ..style = PaintingStyle.fill
    //   ..color.brighten(luminance);
    // c.drawPath(path, fill);

    final stroke = BasicPalette.white.paint()..style = PaintingStyle.stroke;
    c.drawPath(path, stroke);
  }

  Vector3 toScreen(Vector3 v, Projections p) {
    final size = p.screenSize;
    return Vector3(
      (v.x + 1) / 2 * size.x,
      (v.y + 1) / 2 * size.y,
      0.0,
    );
  }

  List<Triangle3> clipZ(Camera camera) {
    return _zNearPlane.clip(this);
  }

  List<Triangle3> clipScreen(Vector2 screenSize) {
    final q = [this];

    const vm = 20.0;
    final planes = [
      Plane3(
        point: Vector3(0, vm, 0),
        normal: Vector3(0, 1, 0),
      ),
      Plane3(
        point: Vector3(0, screenSize.y - vm, 0),
        normal: Vector3(0, -1, 0),
      ),
      Plane3(
        point: Vector3(vm, 0, 0),
        normal: Vector3(1, 0, 0),
      ),
      Plane3(
        point: Vector3(screenSize.x - vm, 0, 0),
        normal: Vector3(-1, 0, 0),
      ),
    ];

    for (final plane in planes) {
      var remaining = q.length;
      while (remaining > 0) {
        final test = q.removeAt(0);
        remaining--;

        q.addAll(plane.clip(test));
      }
    }

    return q;
  }
}
