import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../localizations/loaclization.dart';
import '../themes/prefs.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({Key? key}) : super(key: key);

  @override
  State<NfcScreen> createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  bool nfcEnabled = false;
  ValueNotifier<dynamic> result = ValueNotifier(null);

  void _ndefWrite() {
    NfcManager.instance.stopSession();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = "Tag is not ndef writable";
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }
      NdefMessage message = NdefMessage([
        NdefRecord.createText('${Prefs.instance?.getString('asciiHex')}'),
        NdefRecord.createText('${Prefs.instance?.getString('binaryAscii')}'),
        // NdefRecord.createMime('TEST1', Uint8List.fromList('Test'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        result.value = "Written Succesfully";
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
      }
    });
  }

  void _tagRead() {
    NfcManager.instance.stopSession();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context).translate("nfcView")}"),
        // actions: [
        //   Switch(
        //     value: nfcEnabled,
        //     onChanged: enableNfc,
        //     activeColor: Colors.green,
        //     activeTrackColor: Colors.lightGreen,
        //   ),
        // ],
      ),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text("Nfcmanager.isAvailable(): ${ss.data}"))
              : Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(border: Border.all()),
                        child: SingleChildScrollView(
                          child: ValueListenableBuilder<dynamic>(
                            valueListenable: result,
                            builder: (context, value, _) =>
                                Text('${value ?? ''}'),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: GridView.count(
                        padding: EdgeInsets.all(4),
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: [
                          ElevatedButton(
                              child: Text('Tag Read'), onPressed: _tagRead),
                          ElevatedButton(
                              child: Text('Ndef Write'), onPressed: _ndefWrite),
                          // ElevatedButton(
                          //     child: Text('Ndef Write Lock'),
                          //     onPressed: _ndefWriteLock),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
