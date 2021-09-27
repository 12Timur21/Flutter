import '../Cake.dart';
import '../CookingBuilder.dart';
import '../Products/FillingType.dart';
import '../Products/FlourType.dart';

class CakeBuilder implements CookingBuilder {
  FlourType _flourType = FlourType.wheat;
  int _eggCount = 0;
  FillingType _fillingType = FillingType.apple;
  Duration _cookingDuration = Duration(seconds: 0);

  @override
  set cookingDuration(Duration duration) {
    _cookingDuration = duration;
  }

  @override
  set eggCount(int count) {
    _eggCount = count;
  }

  @override
  set fillingType(FillingType type) {
    _fillingType = type;
  }

  @override
  set flourType(FlourType type) {
    _flourType = type;
  }

  Cake getResult() {
    return Cake(_flourType, _eggCount, _fillingType, _cookingDuration);
  }
}
