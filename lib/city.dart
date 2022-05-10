import 'dart:convert';

class City {
  String? name;
  double? lat;
  double? lon;

  City({
    this.name,
    this.lat,
    this.lon,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "lat": lat,
        "lon": lon,
      };
}

class CityList {
  final List<City>? cityList;

  CityList({
    this.cityList,
  });

  factory CityList.fromJson(List<dynamic> json) {
    List<City> cities = <City>[];
    cities = json.map((i) => City.fromJson(i)).toList();

    return CityList(cityList: cities);
  }
}
