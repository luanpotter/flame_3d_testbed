import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/camera/camera.dart';
import 'package:flame_3d_testbed/flame3d/camera/perspective_projection.dart';
import 'package:flame_3d_testbed/flame3d/camera/projections.dart';
import 'package:flame_3d_testbed/flame3d/objects/cuboid.dart';
import 'package:flame_3d_testbed/flame3d/objects/solid.dart';

class Scene {
  Projections projections;
  List<Solid> objects;

  Scene({
    required Vector2 screenSize,
  })  : projections = Projections(
          screenSize: screenSize,
          camera: Camera(
            position: Vector3.zero(),
            direction: Vector3(0, 0, -1),
            up: Vector3(0, -1, 0),
          ),
          projection: PerspectiveProjection(
            screenSize: screenSize,
          ),
        ),
        objects = [
          Cuboid(
            center: Vector3(0, 0, 20),
            dimensions: Vector3.all(4.0),
          ),
        ];

  void render(Canvas c) {
    for (final object in objects) {
      object.atoms.forEach((atom) => atom.render(c, projections));
    }
  }
}
