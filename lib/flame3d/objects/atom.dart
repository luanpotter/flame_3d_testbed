import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flame_3d_testbed/flame3d/camera/camera.dart';
import 'package:flame_3d_testbed/flame3d/camera/projections.dart';
import 'package:flame_3d_testbed/utils.dart';

final _light = Vector3(0, 0, -1)..normalize();

class Atom {
  Vector3 p0;
  Vector3 p1;
  Vector3 p2;

  Atom(this.p0, this.p1, this.p2);

  Atom.list(List<Vector3> list)
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

  Atom transform(Matrix4 m) {
    return Atom(
      transformVector(p0, m),
      transformVector(p1, m),
      transformVector(p2, m),
    );
  }

  void render(Canvas c, Projections p) {
    if (false && isCulled(p.camera)) {
      return;
    }

    final screenAtom = transform(p.matrix);
    final points = [
      screenAtom.p0,
      screenAtom.p1,
      screenAtom.p2,
    ].map((e) => toScreen(e, p)).map((e) => Offset(e.x, e.y)).toList();
    final path = Path()..addPolygon(points, true);

    // final luminance = (normal.dot(_light) + 1) / 2;
    // final fill = BasicPalette.white.paint()
    //   ..style = PaintingStyle.fill
    //   ..color.brighten(luminance);
    // c.drawPath(path, fill);

    final stroke = BasicPalette.white.paint()..style = PaintingStyle.stroke;
    c.drawPath(path, stroke);
  }

  Vector2 toScreen(Vector3 v, Projections p) {
    final size = p.screenSize;
    return Vector2(
      (v.x + 1) / 2 * size.x,
      (v.y + 1) / 2 * size.y,
    );
  }

  List<Atom> clip(Camera camera) {
    final q = [this];
    // TODO(luan): implement camera clipping
    return q;
  }
}
