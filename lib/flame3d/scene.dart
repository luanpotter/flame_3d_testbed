import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/camera/camera.dart';
import 'package:flame_3d_testbed/flame3d/camera/perspective_projection.dart';
import 'package:flame_3d_testbed/flame3d/camera/projections.dart';
import 'package:flame_3d_testbed/flame3d/objects/solid.dart';

class Scene {
  Projections projections;
  List<Solid> objects;

  Scene({
    required Vector2 screenSize,
    required this.objects,
  }) : projections = Projections(
          screenSize: screenSize,
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
          .forEach((t) => t.render(c, projections));
    }
  }
}
