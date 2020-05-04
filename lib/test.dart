import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:latlong/latlong.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // double calculateDistance(lat1, lon1, lat2, lon2) {
  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 -
  //       c((lat2 - lat1) * p) / 2 +
  //       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  //   return 12742 * asin(sqrt(a));
  // }

  double calDisc(lat1, lon1, lat2, lon2) {
    final Distance distance = new Distance();
    var meter = distance(new LatLng(double.parse(lat1), double.parse(lon1)),
        new LatLng(double.parse(lat2), double.parse(lon2)));
    return meter;
  }

  double lat1 = 22.901933;
  double long1 = 96.420853;
  double lat2 = 22.901394;
  double long2 = 96.420691;

  var syncData = '';

  var distanceRes;
  var curfirstlat;
  var curfirstlong;
  var curseclat;
  var curseclong;

  var lastLat;
  var lastLong;
  var syncDataWithDis = "";
  var loc = '';

  @override
  void initState() {
    super.initState();
    // _calLoc();
    // _onClickGetCurrentPosition();

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
    });

// Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange] - $event');
    });
    bg.BackgroundGeolocation.onLocation(_onLocation);
    // bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    // bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    // bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
    bg.BackgroundGeolocation.ready(bg.Config(

            // desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            // distanceFilter: 10.0,
            // // stopOnTerminate: false,
            // // startOnBoot: true,
            // // debug: true,
            // autoSync: true,
            // logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            // // reset: true,
            // // enableTimestampMeta: true,
            // notificationTitle: "TraceMM",
            // notificationText: "location"
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: true,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            reset: true))
        .then((bg.State state) {
      // setState(() {
      bg.BackgroundGeolocation.start();
      // // // bg.BackgroundGeolocation.start().then((bg.State state) {
      print('[start] success >> ' + state.enabled.toString());
      // //   // final prefs = await SharedPreferences.getInstance();
      // //   // var cp = prefs.getString("changePace") ?? "false";
      // //   // if (cp == "false") {
      bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
        print('[changePace] success $isMoving');
        // prefs.setString("changePace", "true");
      // _syncList();
      }).catchError((e) {
        print('[changePace] ERROR: ' + e.code.toString());
      });
      // //   // } else {
      // //   //   _syncList();
      // //   // }
      // // }).catchError((e) {
      // //   print('[start] ERROR: ' + e.code.toString());
      // //   bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
      // //     print('[changePace] success $isMoving');
      // //     _syncList();
      // //   }).catchError((e) {
      // //     print('[changePace] ERROR1: ' + e.code.toString());
      // //   });
      // // });

      // trackingCheck = state.enabled;
      // _isMoving = state.isMoving;
      // });
    });
  }

  void _onLocation(bg.Location location) async {
    // locCount = locCount + 1;
    print('[location] >>>> ' + location.toString());
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    // print('PRO CHG EVE >>> $event');
    setState(() {
      // _content = encoder.convert(event.toMap());
      // trackingArray.add(_content);
    });
  }

  syncList() {
    bg.BackgroundGeolocation.sync().then((List records) {
      print('[sync] success >> ' + records.toString());
      setState(() {
        var count = 0;
        for (var i = 0; i < records.length; i++) {
          var lat = records[i]["coords"]["latitude"].toString();
          var long = records[i]["coords"]["longitude"].toString();
          loc += "{" + lat + ", " + long + "}";
          // loc += "AAA";
          syncData += loc.toString();

        //   if (lastLat == '' ||
        //       lastLat == null ||
        //       lastLong == "" ||
        //       lastLong == null) {
        //     count += 1;
        //     syncDataWithDis += "$count" + "{" + lat + ", " + long + "}";
        //     lastLat = lat;
        //     lastLong = long;
        //   } else {
        //     double di = calDisc(lastLat, lastLong, lat, long);
        //     if (di > 20) {
        //       count += 1;
        //       syncDataWithDis += "$count" + "{" + lat + ", " + long + "}";
        //       lastLat = lat;
        //       lastLong = long;
        //     }
        //   }
        }
      });
    });
  }

  calDistance() async {
    final Distance distance = new Distance();

    // km = 423
    // var km = distance.as(
    //     LengthUnit.Kilometer, new LatLng(lat1, long1), new LatLng(lat2, long2));
    // print("D-KM >> " + km.toString());
    // meter = 422591.551
    var meter = distance(
        new LatLng(double.parse(curfirstlat), double.parse(curfirstlong)),
        new LatLng(double.parse(curseclat), double.parse(curseclong)));
    print("D-MT >> " + meter.toString());
    setState(() {
      distanceRes = meter.toString();
    });
  }

// Manually fetch the current position.
  void curfirstLoc() {
    print("CLLL");
    bg.BackgroundGeolocation.getCurrentPosition(
            // persist: false, // <-- do not persist this location
            // desiredAccuracy: 0, // <-- desire best possible accuracy
            // timeout: 30000, // <-- wait 30s before giving up.
            // samples: 3 // <-- sample 3 location before selecting best.
            )
        .then((bg.Location location) {
      // print('[getCurrentPosition] - $location');
      print("CUR LOC >> " + location.coords.latitude.toString());
      setState(() {
        curfirstlat = location.coords.latitude.toString();
        curfirstlong = location.coords.longitude.toString();
      });
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  void cursecLoc() {
    print("CLLL");
    bg.BackgroundGeolocation.getCurrentPosition(
            // persist: false, // <-- do not persist this location
            // desiredAccuracy: 0, // <-- desire best possible accuracy
            // timeout: 30000, // <-- wait 30s before giving up.
            // samples: 3 // <-- sample 3 location before selecting best.
            )
        .then((bg.Location location) {
      // print('[getCurrentPosition] - $location');
      print("CUR LOC >> " + location.coords.latitude.toString());
      setState(() {
        curseclat = location.coords.latitude.toString();
        curseclong = location.coords.longitude.toString();
      });
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Testing",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: Builder(builder: (BuildContext context) {
          return new GestureDetector(
            onTap: () {
              print("BACK");
              // update();
              // var tt = "Refresh";
              // Navigator.pop(context, tt);
            },
            child: new Container(
              child: IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  syncList();
                },
                child: Text("SYNC LIST"),
              ),
              RaisedButton(
                onPressed: () {
                  curfirstLoc();
                },
                child: Text("FIRST LOC"),
              ),
              RaisedButton(
                onPressed: () {
                  cursecLoc();
                },
                child: Text("SEC LOC"),
              ),
              RaisedButton(
                onPressed: () {
                  calDistance();
                },
                child: Text("CALCULATE DIS"),
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    curfirstlat = "";
                    curfirstlong = "";
                    curseclat = "";
                    curseclong = "";
                    distanceRes = "";
                    syncData = "";
                  });
                },
                child: Text("CLEAR LOC"),
              ),
              Text("Firstloc: $curfirstlat, $curfirstlong"),
              Text("Secloc: $curseclat, $curseclong"),
              Text("Distance: $distanceRes"),
              Text("Sync Data : $syncData"),
              Text("Sync Data With Distance : $syncDataWithDis"),
            ],
          ),
        ),
      ),
    );
  }
}
