import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flame_3d_testbed/flame3d/camera/camera.dart';
import 'package:flame_3d_testbed/flame3d/camera/perspective_projection.dart';
import 'package:flame_3d_testbed/flame3d/camera/projections.dart';
import 'package:flame_3d_testbed/flame3d/geom/plane3.dart';
import 'package:flame_3d_testbed/utils.dart';

final _stroke = BasicPalette.white.paint()..style = PaintingStyle.stroke;

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

  Vector3 get normal => normal0;

  Vector3 get normal0 {
    final a = p1 - p0;
    final b = p2 - p0;
    return a.cross(b)..normalize();
  }

  Triangle3 transformProjection(Projections p) {
    final m = p.projection.matrix;
    return Triangle3(
      transformVector(p0, m),
      transformVector(p1, m),
      transformVector(p2, m),
    );
  }

  Triangle3 transformCamera(Projections p) {
    final m = p.camera.matrix;
    return Triangle3(
      transformVector(p0, m),
      transformVector(p1, m),
      transformVector(p2, m),
    );
  }

  Triangle3 mapToScreen(Projections p) {
    return Triangle3(
      toScreen(p0, p),
      toScreen(p1, p),
      toScreen(p2, p),
    );
  }

  void render(Canvas c, Projections p) {
    transformCamera(p)
        .clipZNear(p.projection)
        .map((t) => t.transformProjection(p))
        .map((t) => t.mapToScreen(p))
        .expand((t) => t.clipScreen(p.screenSize))
        .forEach((t) => t._render(c));
  }

  void _render(Canvas c) {
    final points =
        [p0, p1, p2].map((e) => Offset(e.x, e.y)).toList(growable: false);
    final path = Path()..addPolygon(points, true);

    c.drawPath(path, _stroke);
  }

  Vector3 toScreen(Vector3 v, Projections p) {
    final size = p.screenSize;
    return Vector3(
      (v.x + 1) / 2 * size.x,
      (v.y + 1) / 2 * size.y,
      0.0,
    );
  }

  List<Triangle3> clipZNear(PerspectiveProjection projection) {
    return projection.zNearPlane.clip(this);
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
