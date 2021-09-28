import 'dart:typed_data';

class Float4Data {
  static const int bytesPerElement = 4;
  int _count = 0;
  int _max;
  Float32List data;

  Float4Data(this._max) : data = Float32List(_max * 4);

  int get lastIndex => _count * bytesPerElement;

  int get size => _count;

  void clear() {
    _count = 0;
  }

  void set(int index, double e0, double e1, double e2, double e3) {
    if (index >= 0 && index < _count) {
      final index0 = index * bytesPerElement;
      data[index0] = e0;
      data[index0 + 1] = e1;
      data[index0 + 2] = e2;
      data[index0 + 3] = e3;
    }
  }

  void copy(int toIndex, int fromIndex) {
    var index0 = toIndex * bytesPerElement;
    var fromIndex0 = fromIndex * bytesPerElement - bytesPerElement;
    data[index0] = data[fromIndex0];
    data[index0 + 1] = data[fromIndex0 + 1];
    data[index0 + 2] = data[fromIndex0 + 2];
    data[index0 + 3] = data[fromIndex0 + 3];
  }

  void add(double e0, double e1, double e2, double e3) {
    if (lastIndex < data.length) {
      var index0 = lastIndex + 1;
      set(index0, e0, e1, e2, e3);
      _count++;
    }
  }

  void removeLast() {
    if (_count > 0) {
      _count--;
    }
  }
}

class Float4DataPool extends Float4Data {
  Float4DataPool(int size) : super(size);

  int allocate() {
    if (lastIndex >= data.length) {
      Float32List newData = Float32List(data.length * 2);
      newData.setAll(0, data);
      data = newData;
    }
    _count++;
    return _count - 1;
  }

  void release(int index) {
    if (index >= 0 && index < _count) {
      copy(index, _count - 1);
      _count--;
    }
  }
}
