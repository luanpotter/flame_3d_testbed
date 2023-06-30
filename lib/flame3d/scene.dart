import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/solid.dart';
import 'package:flame_3d_testbed/flame3d/projections/camera.dart';
import 'package:flame_3d_testbed/flame3d/projections/perspective_projection.dart';
import 'package:flame_3d_testbed/flame3d/projections/projections.dart';

class Scene {
  Projections projections;
  List<Solid> objects;

  Scene({
    required Vector2 screenSize,
    required this.objects,
  }) : projections = Projections(
          camera: Camera(
            position: Vector3.zero(),
            initialDirection: Vector3(0, 0, 1),
            up: Vector3(0, 1, 0),
          ),
          projection: PerspectiveProjection(
            screenSize: screenSize,
          ),
        );

  void render(Canvas c) {
    for (final object in objects) {
      object.triangles
          .map((e) => e.transform(object.transform))
          .expand((t) => t.project(projections))
          .forEach((t) => t.render(c));
    }
  }

  Vector2 get screenSize => projections.projection.screenSize;
  set screenSize(Vector2 value) {
    projections.projection.screenSize = value;
  }
}
