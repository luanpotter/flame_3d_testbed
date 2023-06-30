import 'package:flame_3d_testbed/flame3d/projections/camera.dart';
import 'package:flame_3d_testbed/flame3d/projections/perspective_projection.dart';

class Projections {
  Camera camera;
  PerspectiveProjection projection;

  Projections({
    required this.camera,
    required this.projection,
  });
}
