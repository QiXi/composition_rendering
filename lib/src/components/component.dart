import '../core/base_object.dart';
import '../core/phased_object.dart';
import '../system/registry.dart';

abstract class Component extends PhasedObject with Registry {
  /// Unique name for the search
  String? componentName;

  Component({this.componentName, ComponentPhases phase = ComponentPhases.phase0})
      : super(phase: phase.index);

  void setPhase(ComponentPhases value) {
    phase = value.index;
  }

  void spawn(BaseObject parent) {}
}

enum ComponentPhases {
  phase0, // default
  think, // decisions are made
  physics, // impulse velocities are summed
  postPhysics, // inertia, friction, and bounce
  movement, // position is updated
  collisionDetection, // intersections are detected
  collisionResponse, // intersections are resolved
  postCollision, // position is now final for the frame
  animation, // animations are selected
  preDraw, // drawing state is initialized
  draw, // drawing commands are scheduled.
  frameEnd, // final cleanup before the next update
}
