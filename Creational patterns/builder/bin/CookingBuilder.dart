// ignore_for_file: file_names
import 'Products/FillingType.dart';
import 'Products/FlourType.dart';

abstract class CookingBuilder {
  set flourType(FlourType type);
  set eggCount(int count);
  set fillingType(FillingType type);
  set cookingDuration(Duration duration);
}
