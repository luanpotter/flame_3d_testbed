import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/atom.dart';

abstract class Solid {
  Matrix4 get transform;
  List<Atom> get atoms;
}
