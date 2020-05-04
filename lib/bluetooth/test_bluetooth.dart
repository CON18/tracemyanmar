// import 'package:TraceMyanmar/bluetooth/SelectBondedDevicePage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class TestBluetooth extends StatefulWidget {
  @override
  _TestBluetoothState createState() => _TestBluetoothState();
}

class _TestBluetoothState extends State<TestBluetooth> {
  // BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  var a = '';
  @override
  void initState() {
    super.initState();
  }

  startScan() async {
    // Start scanning
    // flutterBlue.startScan(
    //     scanMode: ScanMode.lowLatency, timeout: Duration(seconds: 4));
    // FlutterBlue.instance
    //                 .startScan(timeout: Duration(seconds: 4));

// // Listen to scan results
//     flutterBlue.scanResults.listen((results) {
//       // do something with scan results
//       for (ScanResult r in results) {
//         print('${r.device.name} found! rssi: ${r.rssi}');
//         setState(() {
//           a += '| ${r.device.name} found! rssi: ${r.rssi}';
//         });
//       }
//     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Bluetooth",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
            )),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Text("$a"),
          RaisedButton(
            child: const Text('Connect to paired device to chat'),
            onPressed: () async {
              startScan();
              // final BluetoothDevice selectedDevice =
              //     await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return SelectBondedDevicePage(checkAvailability: false);
              //     },
              //   ),
              // );
              // print("SDEVICE >> " + selectedDevice.toString());
              // // if (selectedDevice != null) {
              // //   print('Connect -> selected ' + selectedDevice.address);
              // //   _startChat(context, selectedDevice);
              // // } else {
              // //   print('Connect -> no device selected');
              // // }
            },
          ),
        ],
      ),
    );
  }
}
