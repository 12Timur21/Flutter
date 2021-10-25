import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DarkModeModel extends ChangeNotifier {
  bool isDarkMode = false;

  void toogle() {
    isDarkMode = !isDarkMode;
    notifyListeners();
    print(isDarkMode);
  }
}
