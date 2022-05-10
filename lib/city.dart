import 'dart:convert';

class City {
  String? name;
  double? lat;
  double? lng;

  City({
    this.name,
    this.lat,
    this.lng,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "lat": lat,
        "lon": lng,
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
