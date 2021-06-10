import 'draw_offset.dart';

mixin DrawableBody implements DrawOffset {
  double rotation = 0.0;
  double scale = 1.0;
  double opacity = 1.0;
  bool dirty = true;
}
