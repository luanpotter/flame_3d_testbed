import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/atom.dart';
import 'package:flame_3d_testbed/utils.dart';

class Surface {
  List<Vector3> points;
  Matrix4 transform;

  Surface({
    required this.points,
    required this.transform,
  });

  Vector3 _transform(Vector3 v) {
    return transformVector(v, transform);
  }

  List<Atom> get atoms {
    final p0 = _transform(points[0]);
    final p1 = _transform(points[1]);
    final p2 = _transform(points[2]);
    final p3 = _transform(points[3]);
    return [
      Atom(p0, p1, p2),
      Atom(p2, p3, p0),
    ];
  }
}
