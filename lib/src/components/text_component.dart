import 'package:flutter/painting.dart';

import '../../components.dart';
import '../graphics/colors.dart';
import '../graphics/drawable_text.dart';

class TextComponent extends Component with Dirty {
  static const TextStyle defaultTextStyle = TextStyle(
    color: Colors.whiteColor,
    fontSize: 11,
  );
  final TextPainter _textPainter;
  final DrawableText _drawable;
  final TextStyle _textStyle;
  String _text;

  TextComponent(this._text, RenderComponent renderComponent, {TextStyle? style})
      : _textStyle = style ?? defaultTextStyle,
        _textPainter = TextPainter(textDirection: TextDirection.ltr),
        _drawable = DrawableText() {
    setPhase(ComponentPhases.preDraw);
    renderComponent.drawable = _drawable..textPainter = _textPainter;
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
    text = '';
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
        _textPainter.layout();
      }
    }
  }

  @override
  String toString() {
    return 'TextComponent{ text:$_text [$hashCode]}';
  }
}
