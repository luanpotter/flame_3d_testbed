import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/flame3d/objects/solid.dart';
import 'package:flame_3d_testbed/flame3d/objects/surface.dart';
import 'package:flame_3d_testbed/flame3d/objects/triangle3.dart';

class Cuboid extends Solid {
  Vector3 center;
  Vector3 dimensions;

  @override
  Matrix4 transform;

  Cuboid({
    required this.center,
    required this.dimensions,
    Matrix4? transform,
  }) : transform = transform ?? Matrix4.identity();

  @override
  List<Triangle3> get triangles {
    return surfaces.expand((element) => element.triangles).toList();
  }

  List<Surface> get surfaces {
    final width = Vector3(dimensions.x, 0, 0);
    final height = Vector3(0, dimensions.y, 0);
    final depth = Vector3(0, 0, dimensions.z);

    final bottomLeftFront = center - dimensions / 2;
    final bottomRightFront = bottomLeftFront + width;
    final topLeftFront = bottomLeftFront + height;
    final topRightFront = topLeftFront + width;

    final bottomLeftBack = bottomLeftFront + depth;
    final bottomRightBack = bottomRightFront + depth;
    final topLeftBack = topLeftFront + depth;
    final topRightBack = topRightFront + depth;

    return [
      Surface(
        points: [
          bottomLeftFront,
          bottomRightFront,
          topRightFront,
          topLeftFront,
        ],
        transform: transform,
      ),
      Surface(
        points: [
          bottomLeftFront,
          topLeftFront,
          topLeftBack,
          bottomLeftBack,
        ],
        transform: transform,
      ),
      Surface(
        points: [
          bottomRightBack,
          topRightBack,
          topRightFront,
          bottomRightFront,
        ],
        transform: transform,
      ),
      Surface(
        points: [
          topLeftBack,
          topRightBack,
          bottomRightBack,
          bottomLeftBack,
        ],
        transform: transform,
      ),
      Surface(
        points: [
          topLeftFront,
          topRightFront,
          topRightBack,
          topLeftBack,
        ],
        transform: transform,
      ),
      Surface(
        points: [
          bottomLeftBack,
          bottomRightBack,
          bottomRightFront,
          bottomLeftFront,
        ],
        transform: transform,
      ),
    ];
  }
}
