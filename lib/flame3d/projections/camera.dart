import 'package:flame/extensions.dart';

class Camera {
  Vector3 position;

  final Vector3 up;

  final Vector3 initialDirection;
  final Vector3 currentDirection;

  Camera({
    required this.position,
    required this.initialDirection,
    required this.up,
  }) : currentDirection = initialDirection.clone();

  void lookAt({required double yaw, required double pitch}) {
    currentDirection.setFrom(initialDirection);

    final rotation = Matrix4.rotationY(yaw);
    rotation.rotate(right, pitch);
    rotation.transform3(currentDirection);
  }

  Vector3 get direction {
    return currentDirection.clone()..normalize();
  }

  Vector3 get cameraUp {
    return (up - (direction * up.dot(direction)))..normalize();
  }

  Vector3 get right {
    return cameraUp.cross(direction);
  }

  Matrix4 get pointAt {
    final R = right;
    final U = cameraUp;
    final F = direction;
    final P = position;
    return Matrix4.columns(
      Vector4(R.x, R.y, R.z, 0),
      Vector4(U.x, U.y, U.z, 0),
      Vector4(F.x, F.y, F.z, 0),
      Vector4(P.x, P.y, P.z, 1),
    );
  }

  Matrix4 get matrix {
    return pointAt.clone()..invert();
  }
}
