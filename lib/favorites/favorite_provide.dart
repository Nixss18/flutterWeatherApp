import 'package:flutter/widgets.dart';
import 'package:weather_app/api/weather.dart';

class FavoriteCityProvider extends ChangeNotifier {
  final List<String?> _cities = [];

  List<String> get cities => cities;

  void addFavoriteCity(String? city) {
    _cities.add(city);
    for (String city in cities) {
      print(city);
    }
    notifyListeners();
  }
}
