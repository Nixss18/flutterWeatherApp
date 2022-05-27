import 'package:flutter/widgets.dart';
import 'package:weather_app/themes/prefs.dart';

class StateSettings with ChangeNotifier {
  bool isEnabled = Prefs.instance?.getBool("darkModeEnabled") ?? false;
  bool isLanguageEnabled = Prefs.instance?.getBool("language") ?? false;

  void toggleDarkMode() {
    isEnabled = !isEnabled;
    Prefs.instance?.setBool("darkModeEnabled", isEnabled);
    notifyListeners();
  }

  void switchLanguage() {
    isLanguageEnabled = !isLanguageEnabled;
    Prefs.instance?.setBool("language", isLanguageEnabled);
  }
}
