import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Weather"),
        backgroundColor: Colors.blue[300],
      ),
      body: Text("text"),
    );
  }
}
