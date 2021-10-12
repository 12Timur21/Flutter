import 'Products/FillingType.dart';
import 'Products/FlourType.dart';

class Cake {
  FlourType _flourType;
  int _eggCount;
  FillingType _fillingType;
  Duration _cookingDuration;

  Cake(this._flourType, this._eggCount, this._fillingType,
      this._cookingDuration);

  FlourType get flourType => _flourType;
  int get eggCount => _eggCount;
  FillingType get fillingType => _fillingType;
  Duration get cookingDuration => _cookingDuration;
}
