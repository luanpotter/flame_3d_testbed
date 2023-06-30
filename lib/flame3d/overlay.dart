import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_3d_testbed/main.dart';
import 'package:flutter/rendering.dart';

final _text = TextPaint(
  style: TextStyle(
    fontSize: 32.0,
    color: BasicPalette.yellow.color,
  ),
);

const _lineHeight = 30.0;

final _logs = [
  ('Pitch: ', (MyGame game) => game.pitch),
  ('Yaw: ', (MyGame game) => game.yaw),
  ('Position: ', (MyGame game) => game.cameraPosition),
];

class Overlay extends Component with HasGameRef<MyGame> {
  @override
  void render(Canvas canvas) {
    String format(Object thing) {
      if (thing is double) {
        return thing.toStringAsFixed(2);
      } else if (thing is Vector3) {
        return '[${format(thing.x)}, ${format(thing.y)}, ${format(thing.z)}]';
      } else {
        return thing.toString();
      }
    }

    for (final (idx, (prefix, fn)) in _logs.indexed) {
      final text = '$prefix${format(fn(gameRef))}';
      _renderLine(canvas, text, idx * _lineHeight);
    }
  }

  void _renderLine(Canvas canvas, String text, double dy) {
    _text.render(
      canvas,
      text,
      Vector2(gameRef.size.x, dy),
      anchor: Anchor.topRight,
    );
  }
}
