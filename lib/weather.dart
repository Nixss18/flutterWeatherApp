import 'package:dio/dio.dart';

class CurrentWeather {
  Main? main;
  Wind? wind;
  IconList? iconList;
  String? cityName;
  //Weather? weather;
  //Name? name;

  CurrentWeather({
    this.main,
    this.wind,
    this.iconList,
    this.cityName,
    //this.weather,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      main: Main.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
      iconList: IconList.fromJson(json['weather']),
      cityName: json['name'],
    );
  }
}

class Main {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp']?.toDouble(),
      feelsLike: json['feels_like']?.toDouble(),
      tempMin: json['temp_min']?.toDouble(),
      tempMax: json['temp_max']?.toDouble(),
    );
  }
}

class Wind {
  double? speed;
  int? deg;

  Wind({
    this.speed,
    this.deg,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed']?.toDouble(),
      deg: json['deg'],
    );
  }
}

class WeatherIcon {
  String? iconName;

  WeatherIcon({
    this.iconName,
  });

  factory WeatherIcon.fromJson(Map<String, dynamic> json) {
    return WeatherIcon(
      iconName: json['icon'],
    );
  }
}

class IconList {
  final List<WeatherIcon>? icons;

  IconList({
    this.icons,
  });

  factory IconList.fromJson(List<dynamic> json) {
    List<WeatherIcon>? icons = <WeatherIcon>[];
    icons = json.map((i) => WeatherIcon.fromJson(i)).toList();

    return IconList(icons: icons);
  }

  List<WeatherIcon>? getList() {
    return icons;
  }
}
