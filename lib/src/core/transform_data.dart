import 'float4data.dart';

const int iscos = 0;
const int issin = 1;
const int itx = 2;
const int ity = 3;

class TransformData {
  // [scos, ssin, tx, ty, ...]
  static final Float4DataPool _pool = Float4DataPool(128);
  final int index;
  late final int scosIndex;
  late final int ssinIndex;
  late final int txIndex;
  late final int tyIndex;

  final Float4DataPool elements;

  TransformData.allocate()
      : index = _pool.allocate(),
        elements = _pool {
    var index0 = index * Float4Data.bytesPerElement;
    scosIndex = index0 + iscos;
    ssinIndex = index0 + issin;
    txIndex = index0 + itx;
    tyIndex = index0 + ity;
  }

  void release() {
    elements.release(index);
  }

  double get scos => elements.data[scosIndex];

  double get ssin => elements.data[ssinIndex];

  double get tx => elements.data[txIndex];

  double get ty => elements.data[tyIndex];

  void set(double scos, double ssin, double tx, double ty) {
    elements.set(index, scos, ssin, tx, ty);
  }

  @override
  String toString() {
    return 'TransformData{ index:$index [$scos, $ssin, $tx, $ty] [$hashCode]}}';
  }
}
