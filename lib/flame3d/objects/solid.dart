import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/triangle3.dart';

abstract class Solid {
  Matrix4 get transform;
  List<Triangle3> get triangles;
}
