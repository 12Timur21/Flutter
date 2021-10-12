import 'CookingBuilder.dart';
import 'Products/FillingType.dart';
import 'Products/FlourType.dart';

class Director {
  void constructChickenPie(CookingBuilder builder) {
    builder
      ..eggCount = 4
      ..fillingType = FillingType.apple
      ..flourType = FlourType.corn
      ..cookingDuration = Duration(minutes: 30);
  }

  void constructAppleCake(CookingBuilder builder) {
    builder.fillingType = FillingType.chicken;
    builder.flourType = FlourType.buckwheat;
    builder.cookingDuration = Duration(minutes: 50);
  }
}
