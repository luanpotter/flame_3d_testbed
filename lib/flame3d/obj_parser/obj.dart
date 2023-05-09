import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/atom.dart';
import 'package:flame_3d_testbed/flame3d/objects/solid.dart';

class Obj extends Solid {
  String fileName;

  @override
  List<Atom> atoms;

  @override
  Matrix4 transform;

  Obj({
    required this.fileName,
    required this.atoms,
    Matrix4? transform,
  }) : transform = transform ?? Matrix4.identity();
}
