import 'package:flutter/painting.dart';

import '../../components.dart';
import '../graphics/colors.dart';
import '../graphics/drawable_text.dart';

class TextComponent extends Component with Dirty {
  final RenderComponent renderComponent;
  final _textStyle;
  late final TextPainter _textPainter;
  String _text;
  final DrawableText _drawable;

  TextComponent(this._text, this.renderComponent, {TextStyle? style})
      : _textStyle = style ??
            TextStyle(
              color: Colors.whiteColor,
              fontSize: 11,
            ),
        _textPainter = TextPainter(textDirection: TextDirection.ltr),
        _drawable = DrawableText() {
    setPhase(ComponentPhases.preDraw);
    _drawable.textPainter = _textPainter;
    renderComponent.drawable = _drawable;
  }

  set text(String text) {
    if (_text != text) {
      dirty = true;
      _text = text;
    }
  }

  String get text => _text;

  @override
  void reset() {
    _text = '';
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    if (parent is SceneObject && parent.isVisible) {
      if (dirty) {
        dirty = false;
        _textPainter.text = TextSpan(
          text: text,
          style: _textStyle,
        );
        systems.debugSystem.startTextLayout();
        _textPainter.layout();
        systems.debugSystem.stopTextLayout();
      }
    }
  }

  @override
  String toString() {
    return 'TextComponent{ text:$_text [$hashCode]}';
  }
}
