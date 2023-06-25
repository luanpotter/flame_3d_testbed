import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/solid.dart';
import 'package:flame_3d_testbed/flame3d/objects/triangle3.dart';

class Obj extends Solid {
  String fileName;

  @override
  List<Triangle3> triangles;

  @override
  Matrix4 transform;

  Obj({
    required this.fileName,
    required this.triangles,
    Matrix4? transform,
  }) : transform = transform ?? Matrix4.identity();
}
