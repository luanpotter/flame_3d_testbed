import 'package:flame/extensions.dart';
import 'package:flame_3d_testbed/utils.dart';

class Camera {
  Vector3 position;
  Vector3 initialDirection;
  Vector3 up;

  final Vector3 _currentDirection;

  Camera({
    required this.position,
    required this.initialDirection,
    required this.up,
  }) : _currentDirection = initialDirection.clone();

  void lookAt({required double yawn, required double pitch}) {
    _currentDirection.setFrom(initialDirection);
    trt(position, Matrix4.rotationY(yawn)).transform3(_currentDirection);
    trt(position, Matrix4.rotationX(pitch)).transform3(_currentDirection);
  }

  Vector3 get direction {
    return _currentDirection.clone()..normalize();
  }

  Vector3 get _cameraUp {
    return (up - (direction * up.dot(direction)))..normalize();
  }

  Vector3 get right {
    return _cameraUp.cross(direction);
  }

  Matrix4 get matrix {
    final R = right;
    final U = _cameraUp;
    final F = direction;
    final P = position;
    return Matrix4.columns(
      Vector4(R.x, R.y, R.z, 0),
      Vector4(U.x, U.y, U.z, 0),
      Vector4(F.x, F.y, F.z, 0),
      Vector4(P.x, P.y, P.z, 1),
    );
  }
}
