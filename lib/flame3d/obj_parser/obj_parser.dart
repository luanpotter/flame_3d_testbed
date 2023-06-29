import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_3d_testbed/flame3d/geom/triangle3.dart';
import 'package:flame_3d_testbed/flame3d/obj_parser/obj.dart';

class ObjParser {
  ObjParser._();

  static Future<Obj> parse({
    required String fileName,
    required Matrix4 transform,
  }) async {
    final file = await Flame.assets.readFile(fileName);
    final lines = file.split('\n');
    final vertices = <Vector3>[];
    final triangles = <Triangle3>[];
    for (final line in lines) {
      final bits = line.split(' ');
      final head = bits.removeAt(0).trim();
      if (head == 'v') {
        vertices.add(_parseVertex(bits));
      } else if (head == 'f') {
        triangles.add(_parseTriangle(bits, vertices));
      }
    }
    return Obj(
      fileName: fileName,
      triangles: triangles,
      transform: transform,
    );
  }

  static Vector3 _parseVertex(List<String> bits) {
    final coords = bits.map(double.parse).toList();
    return Vector3.array(coords);
  }

  static Triangle3 _parseTriangle(List<String> bits, List<Vector3> vertices) {
    final coords = bits.map((e) => vertices[int.parse(e) - 1]).toList();
    return Triangle3.list(coords);
  }
}
