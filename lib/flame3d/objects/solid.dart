import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/atom.dart';
import 'package:flame_3d_testbed/flame3d/objects/surface.dart';

abstract class Solid {
  Matrix4 get transform;
  List<Surface> get surfaces;

  List<Atom> get atoms {
    return surfaces.expand((element) => element.atoms).toList();
  }
}
