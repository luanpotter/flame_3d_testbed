import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Crosshair extends PositionComponent {
  static const double s = 4.0;
  static const Offset _p1 = Offset(-s, 0);
  static const Offset _p2 = Offset(s, 0);
  static const Offset _p3 = Offset(0, -s);
  static const Offset _p4 = Offset(0, s);

  static final Paint _paint = BasicPalette.red.paint();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawLine(_p1, _p2, _paint);
    canvas.drawLine(_p3, _p4, _paint);
  }
}
