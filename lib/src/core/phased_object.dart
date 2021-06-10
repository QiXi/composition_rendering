import 'base_object.dart';

abstract class PhasedObject extends BaseObject {
  int phase;

  PhasedObject({this.phase = 0});
}
