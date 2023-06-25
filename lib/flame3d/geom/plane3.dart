import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/triangle3.dart';

class Plane3 {
  Vector3 normal;
  Vector3 point;

  Plane3({
    required this.point,
    required this.normal,
  });

  Vector3 intersect(Vector3 lineStart, Vector3 lineEnd) {
    final planeNormal = normal..normalize();
    final planeDirection = -planeNormal.dot(point);
    final ad = lineStart.dot(planeNormal);
    final bd = lineEnd.dot(planeNormal);
    final t = (-planeDirection - ad) / (bd - ad);

    final lineStartToEnd = lineEnd - lineStart;
    final lineToIntersect = lineStartToEnd * t;
    return lineStart + lineToIntersect;
  }

  List<Triangle3> clip(Triangle3 t) {
    final inside = <Vector3>[];
    final outside = <Vector3>[];

    final points = [t.p0, t.p1, t.p2];
    for (final point in points) {
      if (distance(point) < 0) {
        outside.add(point);
      } else {
        inside.add(point);
      }
    }

    switch (inside.length) {
      case 0:
        return [];
      case 1:
        final p0 = inside[0];
        final p1 = intersect(outside[0], inside[0]);
        final p2 = intersect(outside[1], inside[0]);

        return [
          Triangle3(p0, p1, p2),
        ];
      case 2:
        final p0 = inside[0];
        final p1 = inside[1];
        final p2 = intersect(outside[0], inside[0]);
        final p3 = intersect(outside[0], inside[1]);

        return [
          Triangle3(p0, p2, p3),
          Triangle3(p0, p3, p1),
        ];
      default: // case 3:
        return [t];
    }
  }

  double distance(Vector3 p) {
    final planeNormal = normal..normalize();
    return planeNormal.dot(p) - planeNormal.dot(point);
  }
}
