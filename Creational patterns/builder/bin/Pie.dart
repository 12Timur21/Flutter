// ignore_for_file: file_names

import 'Products/FillingType.dart';
import 'Products/FlourType.dart';

class Pie {
  FlourType _flourType;
  int _eggCount;
  FillingType _fillingType;
  Duration _cookingDuration;
  int _pieSize = 0;

  Pie(this._flourType, this._eggCount, this._fillingType,
      this._cookingDuration);

  set pieSize(int size) {
    _pieSize = size;
  }

  FlourType get flourType => _flourType;
  int get eggCount => _eggCount;
  FillingType get fillingType => _fillingType;
  Duration get cookingDuration => _cookingDuration;
  int get pieSize => _pieSize;
}
