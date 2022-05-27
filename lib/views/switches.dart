import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/localizations/loaclization.dart';

class SwitchesScreen extends StatefulWidget {
  const SwitchesScreen({Key? key}) : super(key: key);

  @override
  State<SwitchesScreen> createState() => _SwitchesScreenState();
}

class _SwitchesScreenState extends State<SwitchesScreen> {
  List<bool> switchValues = [
    true,
    false,
    false,
    true,
    false,
    false,
    true,
    false
  ];

  String asciiHex = "";
  String binaryAscii = "";

  void asiiString() async {
    final prefs = await SharedPreferences.getInstance();

    String asciiString = "";
    for (int i = 0; i < switchValues.length; i++) {
      asciiString += (switchValues[i] ? 1 : 0).toString();
    }
    print("ASCII STRING $asciiString");
    int asciiBinaryValue = int.parse(asciiString, radix: 2);
    asciiHex = asciiBinaryValue.toRadixString(16);
    print(asciiHex);

    int fromHexToBinary = int.parse(asciiHex, radix: 16);
    binaryAscii = fromHexToBinary.toRadixString(2).padLeft(8, '0');

    prefs.setString("asciiHex", asciiHex);
    prefs.setString("binaryAscii", binaryAscii);

    print(binaryAscii);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: asiiString),
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('switchesPageTitle')),
      ),
      body: Column(
        children: List.generate(
          switchValues.length,
          (index) {
            return Switch(
              value: switchValues[index],
              onChanged: (newValue) {
                setState(() {
                  switchValues[index] = newValue;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
