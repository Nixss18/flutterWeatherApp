import 'package:dio/dio.dart';
import 'package:weather_app/city.dart';
import 'package:weather_app/weather.dart';
import 'package:weather_app/weekly_weather.dart';

class Api {
  Api._();
  static final Api client = Api._();

  final Dio openWeatherMap = Dio(
    BaseOptions(
      baseUrl: "https://api.openweathermap.org",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      queryParameters: {
        'appid': '493c32b6d579efb49f3d9ead947c9dbb',
        'units': 'metric'
      },
    ),
  );

  Future<CurrentWeather> getHttp(double? lat, double? lon) async {
    final response = await openWeatherMap
        .get("/data/2.5/weather", queryParameters: {'lat': lat, 'lon': lon});
    return CurrentWeather.fromJson(response.data);
  }

  Future<List<City>> getHttpCity(String userInput) async {
    final response = await openWeatherMap
        .get("/geo/1.0/direct", queryParameters: {'q': userInput, 'limit': 5});
    List rawList = response.data as List;
    return rawList.map((e) => City.fromJson(e)).toList();
  }

  Future<WeeklyWeather> getHttpWeekly(double? lat, double? lon) async {
    final response = await openWeatherMap.get("/data/2.5/onecall",
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'exclude': 'minutely,hourly,current'
        });
    return WeeklyWeather.fromJson(response.data);
  }
}
