import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/city.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/weather.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({Key? key}) : super(key: key);

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  Future<List<City>>? futureCityData;
  Timer? _timer;
  final textFieldValue = TextEditingController();

  Future<List<City>> getHttpCity(String userInput) async {
    final response =
        await dioCity.get("/geo/1.0/direct", queryParameters: {'q': userInput});
    List rawList = response.data as List;
    return rawList.map((e) => City.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textFieldValue,
          decoration: InputDecoration(hintText: 'Search'),
          autofocus: true,
          onChanged: (String value) {
            if (value.isEmpty) {
              return;
            }
            // print("userInput ${userInput}");
            _timer?.cancel(); //atcel pieprasijumu
            _timer = Timer(const Duration(seconds: 1), () {
              setState(() {
                futureCityData =
                    getHttpCity(value); //pec sekundes izsauc pieprasijumu
              });
            });
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<List<City>>(
          future: futureCityData,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // return Text(snapshot.data?[index].name ?? "No search");
                  return ListTile(
                    title: Text(snapshot.data?[index].name ?? "No values"),
                    onTap: () {
                      // selectedLat = snapshot.data?[index].lat;
                      // selectedLng = snapshot.data?[index].lon;

                      double? lat = snapshot.data?[index].lat;
                      double? lon = snapshot.data?[index].lon;

                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const HomePage()));
                      Navigator.of(context).pop(SelectedCity(lat, lon));
                    },
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class SelectedCity {
  final double? lat;
  final double? lon;

  const SelectedCity(this.lat, this.lon);
}
