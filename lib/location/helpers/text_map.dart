// import 'package:TraceMyanmar/db_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:TraceMyanmar/Drawer/drawer.dart';
import 'package:TraceMyanmar/location/helpers/map_helper.dart';
import 'package:TraceMyanmar/location/helpers/map_marker.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:TraceMyanmar/db_helper.dart';

class TestMap extends StatefulWidget {
  @override
  _TestMapState createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {  

  LatLng target;

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    // final googleOffices = await locations.getGoogleOffices();
    var dbHelper = DBHelper();
    final setList = await dbHelper.getEmployees();
    setState(() {
      _markers.clear();
      for (final list in setList) {
        var index = list.location.toString().indexOf(',');
        var lat = list.location.toString().substring(0, index);
        var long = list.location.toString().substring(index + 1);
        // print("Lth >> "+list.length.toString())
        print("ML >> " + lat + "|" + long);
        final marker = Marker(
          markerId: MarkerId(list.id.toString()),
          position: LatLng(double.parse(lat), double.parse(long)),
          infoWindow: InfoWindow(
            title: list.time,
            // snippet: office.address,
          ),
        );
        _markers[list.id.toString()] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          drawer: Drawerr(),
          appBar: AppBar(
            title: Text('Trace Map',
                style: TextStyle(fontWeight: FontWeight.w300)),
            centerTitle: true,
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: const LatLng(22.908325, 96.4234917),
              zoom: 10,
            ),
            markers: _markers.values.toSet(),
            mapType: MapType.normal,
            // tiltGesturesEnabled: true,
            // compassEnabled: true,
            // rotateGesturesEnabled: true,
            // myLocationEnabled: true,
          ),
        ),
        // theme: ThemeData(
        //   fontFamily: 'Raleway',
        //   textTheme: Theme.of(context).textTheme.apply(
        //         bodyColor: Colors.black,
        //         displayColor: Colors.grey[600],
        //       ),
        //   // This colors the [InputOutlineBorder] when it is selected
        //   primaryColor: Colors.grey[500],
        //   textSelectionHandleColor: Colors.blue[500],
        // ),
      );

  // Future<void> _onMapCCreated(GoogleMapController controller) async {
  //   // final googleOffices = await locations.getGoogleOffices();
  //   final setList = await dbHelper.getEmployees();
  //   setState(() {
  //     _markers11.clear();
  //     for (final list in setList) {
  //       var index = list.location.toString().indexOf(',');
  //       var lat = list.location.toString().substring(0, index);
  //       var long = list.location.toString().substring(index + 1);
  //       // print("Lth >> "+list.length.toString())
  //       print("ML >> " + lat + "|" + long);
  //       final marker = Marker(
  //         markerId: MarkerId(list.id.toString()),
  //         position: LatLng(double.parse(lat), double.parse(long)),
  //         infoWindow: InfoWindow(
  //           title: list.time,
  //         ),
  //       );
  //       _markers11[list.id.toString()] = marker;
  //     }
  //   });
  // }

}
