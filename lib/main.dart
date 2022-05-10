import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/search_city.dart';
import 'package:weather_app/second_screen.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/weather.dart';
import 'package:weather_app/city.dart';

var options = BaseOptions(
  baseUrl: "https://api.openweathermap.org",
  connectTimeout: 5000,
  receiveTimeout: 3000,
  queryParameters: {
    'appid': 'd339b378743357cd4befe21094335f5d',
    'units': 'metric'
  },
);

var CityOptions = BaseOptions(
  baseUrl: "https://api.openweathermap.org",
  connectTimeout: 5000,
  receiveTimeout: 3000,
  queryParameters: {
    'limit': 5,
    'appid': 'd339b378743357cd4befe21094335f5d',
  },
);

Dio dio = Dio(options);
Dio dioCity = Dio(CityOptions);

Future<CurrentWeather> getHttp() async {
  final response = await dio.get("/data/2.5/weather",
      queryParameters: {'lat': 57.527770, 'lon': 25.389595});
  return CurrentWeather.fromJson(response.data);
}

// Future<List<City>> getHttpCity() async {
//   var response = await Dio().get(
//       "https://api.openweathermap.org/geo/1.0/direct?q=Limbazi&limit=5&appid=493c32b6d579efb49f3d9ead947c9dbb");
//   List rawList = response.data as List;
//   return rawList.map((e) => City.fromJson(e)).toList();
// }

Future<List<City>> getHttpCity() async {
  final response =
      await dioCity.get("/geo/1.0/direct", queryParameters: {'q': 'Limbazi'});
  List rawList = response.data as List;
  return rawList.map((e) => City.fromJson(e)).toList();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light()
          .copyWith(appBarTheme: AppBarTheme(foregroundColor: Colors.white)),
      title: "Weather App",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<CurrentWeather> futureWeatherData;
  late Future<List<City>> futureCityData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureWeatherData = getHttp();
    futureCityData = getHttpCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("weather app"),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchCity,
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: _openWeeklyView,
            ),
            IconButton(onPressed: _reloadPage, icon: Icon(Icons.replay))
          ],
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<List<City>>(
                future: futureCityData,
                builder: (context, snapshot) {
                  City? city = snapshot.data?.first;
                  if (snapshot.hasData) {
                    print("name ${snapshot.data?.first.name}");
                    return cityData(city!);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            Center(
              child: FutureBuilder<CurrentWeather>(
                future: futureWeatherData,
                builder: (context, snapshot) {
                  print(snapshot.data?.iconList?.icons);
                  CurrentWeather? weather = snapshot.data;
                  if (snapshot.hasData) {
                    return weatherData(weather!);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ));
  }

  void _openWeeklyView() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SecondScreen()));
  }

  void _searchCity() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SearchCity()));
  }

  void _reloadPage() {
    setState(() {
      futureWeatherData = getHttp();
    });
  }
}

Widget cityData(City _city) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   "${_city.localNames?.uk}, City name",
        //   style: const TextStyle(fontFamily: 'Schyler', fontSize: 24),
        // ),
      ],
    ),
  );
}

Widget weatherData(CurrentWeather _currentWeather) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   "${_currentWeather.name?.name}, name",
        //   style: const TextStyle(fontFamily: 'Schyler', fontSize: 24),
        // // ),
        if (_currentWeather.iconList?.icons?.isNotEmpty ?? false)
          Image.network(
              'http://openweathermap.org/img/wn/${_currentWeather.iconList!.icons!.first.iconName}@2x.png'),
        Text(
          "${_currentWeather.cityName}, City name",
          style: const TextStyle(fontFamily: 'Schyler', fontSize: 24),
        ),
        Text(
          "${_currentWeather.main?.temp}, temperature",
          style: const TextStyle(fontFamily: 'Schyler', fontSize: 24),
        ),

        Text(
          "${_currentWeather.main?.feelsLike}, feels like",
          style: const TextStyle(fontFamily: 'Koulen', fontSize: 24),
        ),
        Text("${_currentWeather.main?.tempMin}, minTemp",
            style: const TextStyle(fontFamily: 'Koulen', fontSize: 20)),
        Text("${_currentWeather.main?.tempMax}, maxTemp",
            style: const TextStyle(fontFamily: 'Koulen', fontSize: 20)),
      ],
    ),
  );
}
