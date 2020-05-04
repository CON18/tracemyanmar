import 'dart:async';

import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class SingleMarker extends StatefulWidget {
  final String id;
  final String location;
  final String time;
  final String ride;

  SingleMarker(
      {Key key,
      @required this.id,
      @required this.location,
      @required this.time,
      @required this.ride})
      : super(key: key);

  @override
  _SingleMarkerState createState() => _SingleMarkerState();
}

class _SingleMarkerState extends State<SingleMarker> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  LatLng _mainLocation;
  // = const LatLng(22.9087267, 96.4237433);
  // LatLng _mainLocation = LatLng(22.908325, 96.4234917);

  var _start;
  Timer timer;
  var dbHelper;
  String checkfont = '';
  String lan = '';

  // final bitmapIcon = BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(size: Size(48, 48)), 'assets/marker.png');
  var bitmapImage;
  @override
  void initState() {
    super.initState();
    someMethod();
    var index = widget.location.toString().indexOf(',');
    var lat = widget.location.toString().substring(0, index);
    var long = widget.location.toString().substring(index + 1);
    _mainLocation = LatLng(double.parse(lat), double.parse(long));
    print("ML >> " + lat + "|" + long);
    // _createMarkerImageFromAsset("assets/marker.png");
    analyst();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'SingleMap_Request',
      parameters: <String, dynamic>{
        // 'string': myController.text,
      },
    );
  }

  Future someMethod() async {
    String deviceLanguage = await Devicelocale.currentLocale;
    checkfont = deviceLanguage.substring(3, 5);
    setState(() {
      if (checkfont == 'ZG') {
        print(checkfont);
        // print('lenght ---- ' + textMyan.length.toString());
        lan = "Zg";
        print(lan);
      } else {
        // print('lenght ---- ' + textMyan.length.toString());
        lan = "Uni";
        print(lan);
      }
      print('-->$deviceLanguage');
    });
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void dispose() {
    // timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

  // _createMarkerImageFromAsset("assets/locationMarker.png");

  // Future<BitmapDescriptor> _createMarkerImageFromAsset(String iconPath) async {
  //   ImageConfiguration configuration = ImageConfiguration(size: Size(48.0, 48.0));
  //   bitmapImage =
  //       await BitmapDescriptor.fromAssetImage(configuration, iconPath);
  //   return bitmapImage;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
            lan == "Zg" ? Rabbit.uni2zg('​မြေပုံ (Map)') : '​မြေပုံ (Map)',
            // '​မြေပုံ (Map)',
            style: TextStyle(
                fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                fontWeight: FontWeight.w300,
                fontSize: 18.0)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _mainLocation,
                zoom: 18.0,
              ),
              // markers: this.myMarker(),
              markers: {
                Marker(
                  markerId: MarkerId(widget.id.toString()),
                  position: _mainLocation,
                  infoWindow: InfoWindow(
                    // title: widget.time
                    title: widget.time.toString().replaceAll("T", " "),
                  ),
                  // icon: BitmapDescriptor.hueCyan,
                  // icon: getMarkerIcon("path/to/your/image.png", Size(150.0, 150.0))
                  // icon: bitmapImage,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                )
              },
              mapType: MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  myMapController = controller;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Marker singleMarker = Marker(
  //   markerId: MarkerId(widget.id.toString()),
  //   position: LatLng(22.9087267, 96.4237433),
  //   infoWindow: InfoWindow(title: 'Los Tacos'),
  //   icon: BitmapDescriptor.defaultMarkerWithHue(
  //     BitmapDescriptor.hueViolet,
  //   ),
  // );

  // Set<Marker> myMarker() {
  //   setState(() {
  //     _markers.add(Marker(
  //       // This marker id can be anything that uniquely identifies each marker.
  //       markerId: MarkerId(_mainLocation.toString()),
  //       // position: LatLng(double.parse(data[0]["latitude"].toString()),
  //       //     double.parse(data[0]["longitude"].toString())),
  //       position: _mainLocation,
  //       infoWindow: InfoWindow(
  //         title: "HELLO MAP",
  //         snippet: '5 Star Rating',
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));

  //     return _markers;
  //     // });
  //   });
  // }
}
