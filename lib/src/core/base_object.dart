abstract class BaseObject {
  BaseObject();

  void reset();

  void update(double deltaTime, BaseObject parent) {
    // Base class does nothing.
  }
}
