import 'package:flame/extensions.dart';

class Camera {
  Vector3 position;
  Vector3 direction;
  Vector3 up;

  Camera({
    required this.position,
    required this.direction,
    required this.up,
  });

  Vector3 get _cameraRight {
    return (direction.cross(up))..normalize();
  }

  Vector3 get _cameraUp {
    return _cameraRight.cross(direction);
  }

  Matrix4 get _rotation {
    final R = _cameraRight;
    final U = _cameraUp;
    final F = direction;
    return Matrix4.columns(
      Vector4(R.x, U.x, F.x, 0),
      Vector4(R.y, U.y, F.y, 0),
      Vector4(R.z, U.z, F.z, 0),
      Vector4(0, 0, 0, 1),
    );
  }

  Matrix4 get _translation {
    final P = position;
    return Matrix4.columns(
      Vector4(1, 0, 0, P.x),
      Vector4(0, 1, 0, P.y),
      Vector4(0, 0, 1, P.z),
      Vector4(0, 0, 0, 1),
    );
  }

  Matrix4 get matrix {
    return Matrix4.identity();
    // return _translation.multiplied(_rotation)..invert();
  }
}
