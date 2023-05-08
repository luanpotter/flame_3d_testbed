import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/camera/camera.dart';
import 'package:flame_3d_testbed/flame3d/camera/perspective_projection.dart';

class Projections {
  Vector2 screenSize;
  Camera camera;
  PerspectiveProjection projection;

  Projections({
    required this.screenSize,
    required this.camera,
    required this.projection,
  });

  Matrix4 get matrix {
    return projection.matrix.multiplied(camera.matrix);
  }
}
