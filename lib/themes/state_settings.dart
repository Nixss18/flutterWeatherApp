import 'package:flutter/widgets.dart';
import 'package:weather_app/themes/prefs.dart';

class StateSettings with ChangeNotifier {
  bool isEnabled = Prefs.instance?.getBool("darkModeEnabled") ?? false;

  void toggleDarkMode() {
    isEnabled = !isEnabled;
    Prefs.instance?.setBool("darkModeEnabled", isEnabled);
    notifyListeners();
  }
}
