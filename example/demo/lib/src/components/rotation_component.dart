import 'package:composition_rendering/components.dart';
import 'package:composition_rendering/core.dart';

class RotationComponent extends Component {
  SpriteBody? sprite;
  double velocity;
  double angle;
  double angleOffset;

  RotationComponent(
      {this.sprite,
      this.velocity = 2,
      this.angle = 0,
      this.angleOffset = 0}) /*:spriteBody??_sprite=spriteBody;*/ {
    setPhase(ComponentPhases.think);
  }

  @override
  void reset() {}

  @override
  void spawn(BaseObject parent) {
    if (parent is SceneObject) {
      var sprite = parent.findByType<SpriteComponent>();
      if (sprite == null) {
        parent.destroy();
      } else {
        this.sprite = sprite;
      }
    }
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    if (parent is SceneObject && parent.isVisible) {
      angle = radRound(angle + velocity * deltaTime);
      sprite?.rotation = angle + angleOffset;
    }
  }
}
