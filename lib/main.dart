import 'package:flutter/material.dart';
import 'package:weather_app/second_screen.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/weather.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<CurrentWeather> getHttp() async {
  var response = await Dio().get(
      "https://api.openweathermap.org/data/2.5/weather?lat=57.527770&lon=25.389595&appid=d339b378743357cd4befe21094335f5d&units=metric");
  return CurrentWeather.fromJson(response.data);
}

void main() {
  runApp(Phoenix(child: MyApp()));
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

  // void initState() {
  //   // TODO: implement initState
  //   futureWeatherData = getHttp();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureWeatherData = getHttp();
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
      body: Center(
        child: FutureBuilder<CurrentWeather>(
          future: futureWeatherData,
          builder: (context, snapshot) {
            print(snapshot.data?.iconList?.icons);
            ;
            CurrentWeather? weather = snapshot.data;
            if (snapshot.hasData) {
              return weatherData(weather!);
              //print(snapshot.data?. ?? 0.0);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _openWeeklyView() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SecondScreen()));
  }

  void _searchCity() {}

  void _reloadPage() {
    Phoenix.rebirth(context);
  }
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
