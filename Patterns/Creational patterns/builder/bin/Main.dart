import 'Builders/CakeBuilder.dart';
import 'Cake.dart';
import 'Director.dart';
import 'Pie.dart';
import 'Builders/PieBuilder.dart';

main() {
  Director director = new Director();
  CakeBuilder builder = new CakeBuilder();

  director.constructChickenPie(builder);

  Cake apppleCake = builder.getResult();
  print('Торт из ${apppleCake.flourType} и ${apppleCake.fillingType}');
}
