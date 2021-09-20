// ignore_for_file: file_names
import 'Director.dart';
import 'Pie.dart';
import 'PieBuilder.dart';

main() {
  Director director = new Director();
  PieBuilder builder = new PieBuilder();

  director.constructApplePie(builder);

  Pie pie = builder.getResult();
  print('${pie.flourType}, ${pie.eggCount}');
}
