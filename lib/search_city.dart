import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/city.dart';
import 'package:weather_app/main.dart';

// Future<List<City>> getHttpCity() async {
//   // return Future.value(City());
//   var response = await Dio().get(
//       "https://api.openweathermap.org/geo/1.0/direct?q=Limbazi&limit=5&appid=493c32b6d579efb49f3d9ead947c9dbb");
//   List rawList = response.data as List;
//   return rawList.map((e) => City.fromJson(e)).toList();
//   // List<City> cityData =
//   //     List<City>.from(listToPass.map((i) => City.fromJson(i)));
//   // return City.fromJson(response.data);
// }

class SearchCity extends StatefulWidget {
  const SearchCity({Key? key}) : super(key: key);

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  Future<List<City>>? futureCityData;

  @override
  void initState() {
    super.initState();
    futureCityData = getHttpCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TextField(
            decoration: InputDecoration(
                hintText: 'Search', prefixIcon: Icon(Icons.search)),
            autofocus: true,
          ),
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<List<City>>(
                future: futureCityData,
                builder: (context, snapshot) {
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ));
  }
}
