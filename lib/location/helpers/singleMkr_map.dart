import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  LatLng _mainLocation;
  // = const LatLng(22.9087267, 96.4237433);
  // LatLng _mainLocation = LatLng(22.908325, 96.4234917);

  var _start;
  Timer timer;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    var index = widget.location.toString().indexOf(',');
    var lat = widget.location.toString().substring(0, index);
    var long = widget.location.toString().substring(index + 1);
    _mainLocation = LatLng(double.parse(lat), double.parse(long));
    print("ML >> " + lat + "|" + long);

    dbHelper = DBHelper();
    _checkAndstartTrack();
  }

  _checkAndstartTrack() async {
    final prefs = await SharedPreferences.getInstance();
    var chkT = prefs.getString("chk_tracking") ?? "0";
    if (chkT == "0") {
      //tracking off
    } else {
      //tracking on
      final prefs = await SharedPreferences.getInstance();
      int val = prefs.getInt("timer") ?? 0;

      if (val == 0) {
      } else {
        _start = val.toString();
        countDownSave();
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

  countDownSave() {
    print("START >> $_start");
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer t) => setState(
        () {
          if (_start == 0) {
            _getCurrentLocationForTrack();
            timer.cancel();
          } else {
            _start = int.parse(_start.toString()) - 1;
            saveTimer();
            // print("Sec>>" + _start.toString());
          }
          print("CD >> " + _start.toString());
        },
      ),
    );
  }

  saveTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("timer", _start);
  }

  _getCurrentLocationForTrack() async {
    //auto check in location

    // setState(() async {
    //tracking on
    try {
      // UserId
      final prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("UserId") ?? null;

      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      var location = "${position.latitude}, ${position.longitude}";
      print("location >>> $location");

      DateTime now = DateTime.now();
      var curDT = new DateFormat.yMd().add_jm().format(now);
      if (userId == null) {
        Employee e = Employee(null, location, curDT, "Checked In", "", "Auto");
        dbHelper.save(e);
      } else {
        Employee e =
            Employee(int.parse(userId), location, curDT, "Checked In", "", "Auto");
        dbHelper.save(e);
      }

      // final prefs = await SharedPreferences.getInstance();
      int c = prefs.getInt("saveCount") ?? 0;
      final prefs1 = await SharedPreferences.getInstance();
      int r = c + 1;
      prefs1.setInt("saveCount", r);
      // setState(() {
      //   refreshList();
      // });
      print("Save --->>>>");
      _start = startInterval;
      countDownSave();
    } on Exception catch (_) {
      print('never reached');
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('​မြေပုံ (Map)',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0)),
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
                  infoWindow: InfoWindow(title: widget.time),
                  icon: BitmapDescriptor.defaultMarker,
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
