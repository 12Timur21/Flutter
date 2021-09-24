import 'Products/FillingType.dart';
import 'Products/FlourType.dart';
// ignore_for_file: file_names
import 'PieBuilder.dart';

class Director {
  void constructApplePie(PieBuilder pieBuilder) {
    pieBuilder.eggCount = 4;
    pieBuilder.fillingType = FillingType.apple;
    pieBuilder.flourType = FlourType.corn;
    pieBuilder.cookingDuration = Duration(minutes: 30);
  }

  void constructMeatPie(PieBuilder pieBuilder) {
    pieBuilder.eggCount = 1;
    pieBuilder.fillingType = FillingType.meat;
    pieBuilder.flourType = FlourType.buckwheat;
    pieBuilder.cookingDuration = Duration(minutes: 50);
  }
}
