import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:TraceMyanmar/location/helpers/map_helper.dart';
import 'package:TraceMyanmar/location/helpers/map_marker.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  // //---->
  // GoogleMapController myMapController;
  // final Set<Marker> _markers1 = new Set();
  // static const LatLng _mainLocation = const LatLng(22.9087267, 96.4237433);
  // //---->

  var dbHelper;
  var data = [];
  var test;
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final Completer<GoogleMapController> _mapController = Completer();
  final Map<String, Marker> _new_markers = {};

  /// Set of displayed markers and cluster markers on the map
  // final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;
  String checklang = '';
  List textMyan = ["​မြေပုံ"];
  List textEng = ["Map"];
  String checkfont = '';
  String lan = '';

  LatLng _targetLatLong;

  var _start;
  Timer timer;

  var setmrkList = [];
  var setqcmrkList = [];

  checkLanguage() async {
    // final prefs = await SharedPreferences.getInstance();
    // checklang = prefs.getString("Lang");
    // if (checklang == "" || checklang == null || checklang.length == 0) {
    //   checklang = "Eng";
    // } else {
    //   checklang = checklang;
    // }
    checklang = "Myanmar";
    setState(() {});
  }
  // Example marker coordinates
  // final List<LatLng> _markerLocations = [];
  // final List<LatLng> _markerLocations = [
  //   LatLng(16.8822700, 96.121611),
  //   LatLng(16.8822782, 96.121694),
  //   LatLng(16.8822600, 96.121530),
  //   LatLng(16.8822720, 96.121870),
  //   LatLng(16.8822400, 96.121370),
  // ];

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
  testing() async {
    var setList = [];
    var sl = [];
    setList = await dbHelper.getEmployees();
    // sl = await dbHelper.getEmployees();
    setState(() {
      // List<Marker> markers = data.map((n) {
      //   LatLng point = LatLng(n.latitude, n.longitude);
      // }).toList();
      // print(markers);

      //Get Today

      for (var j = 0; j < setList.length; j++) {
        // for (var i = 0; i < cl; i++) {
        if (setList[j].location.toString() == "null" ||
            setList[j].location == "") {
        } else {
          var time = setList[j].time.toString().substring(0, 10);
          var nowTime = convertDateTime();

          if (time == nowTime) {
            // sl.add({
            //   "id": setList[j].id.toString(),
            //   "location": setList[j].location,
            //   "time": setList[j].time
            // });
            sl.add(setList[j]);
          }
        }
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        print("NEW LENGTH >>>> " + sl.length.toString());
        // var convGetToMin = 0;
        for (var i = 0; i < sl.length; i++) {
          print("NEW LOC >>> " + sl[i].time.toString());
          if (sl[i].location.toString() == "null" || sl[i].location == "") {
          } else {
            // var index = setList[i].location.toString().indexOf(',');
            // print("LOC >>>>> " + setList[i].location.toString());
            // data.add({
            //   "latitude": setList[i].location.toString().substring(0, index),
            //   "longitude": setList[i].location.toString().substring(index + 1),
            // });
            // var getDate = sl[i].time.toString().substring(0, 10);
            // var setDate = sl[i + 1].time.toString().substring(0, 10);
            // time for first
            var timestamp1 = sl[i].time.toString();
            var index1 = timestamp1.toString().indexOf('T');
            var hr1 = timestamp1.toString().substring(index1 + 1, index1 + 3);
            var mi1 = timestamp1.toString().substring(index1 + 4, index1 + 6);
            TimeOfDay testDate1 =
                TimeOfDay(hour: int.parse(hr1), minute: int.parse(mi1));
            int firstTime = testDate1.hour * 60 + testDate1.minute;
            // snackbarmethod1("S $i");
            int secondTime = 0;
            if (sl.length >= 2) {
              // time for second
              var timestamp2 = sl[i + 1].time.toString();
              var index2 = timestamp2.toString().indexOf('T');
              var hr2 = timestamp2.toString().substring(index2 + 1, index2 + 3);
              var mi2 = timestamp2.toString().substring(index2 + 4, index2 + 6);
              TimeOfDay testDate2 =
                  TimeOfDay(hour: int.parse(hr2), minute: int.parse(mi2));
              secondTime = testDate2.hour * 60 + testDate2.minute;
            }
            // if (sl.length == 1) {
            //   setmrkList.add({
            //     "id": sl[i].id.toString(),
            //     "location": sl[i].location,
            //     "time": sl[i].time,
            //     "color": "blue"
            //   });
            // }
            if (i == 0) {
              // convGetToMin = firstTime;
              // setmrkList.add({
              //   "id": sl[i].id.toString(),
              //   "location": sl[i].location,
              //   "time": sl[i].time,
              //   "color": "blue"
              // });
            } else {
              int res = (secondTime - firstTime);
              print("TD >> " + res.toString() + "|" + sl[i].time.toString());
              if (res > 5) {
                setState(() {
                  setmrkList.add({
                    "id": sl[i].id.toString(),
                    "location": sl[i].location,
                    "time": sl[i].time,
                    "color": "blue"
                  });
                });
              } else {}
            }

            // else if (firstTime > (convGetToMin + 5)) {
            //   convGetToMin = firstTime;
            //   setmrkList.add({
            //     "id": sl[i].id.toString(),
            //     "location": sl[i].location,
            //     "time": sl[i].time,
            //     "color": "blue"
            //   });
            // }

            // // time for second
            // var timestamp2 = sl[i + 1].time.toString();
            // var index2 = timestamp2.toString().indexOf('T');
            // var hr2 = timestamp2.toString().substring(index2 + 1, index2 + 3);
            // var mi2 = timestamp2.toString().substring(index2 + 4, index2 + 6);
            // TimeOfDay testDate2 =
            //     TimeOfDay(hour: int.parse(hr2), minute: int.parse(mi2));
            // int secondTime = testDate2.hour * 60 + testDate2.minute;

            // int tt = secondTime - firstTime;
            // print("TIME DIS >>> " + tt.toString());
            // if (i == 0) {
            //   setmrkList.add({
            //     "id": sl[i].id.toString(),
            //     "location": sl[i].location,
            //     "time": sl[i].time,
            //     "color": "blue"
            //   });
            //   // addData(setList[i].id.toString(), setList[i].location,
            //   //     setList[i].time, "blue");
            // }
            //  else if (i == (sl.length - 1)) {
            //   // addData(setList[i].id.toString(), setList[i].location,
            //   //     setList[i].time, "blue");
            //   setmrkList.add({
            //     "id": sl[i].id.toString(),
            //     "location": sl[i].location,
            //     "time": sl[i].time,
            //     "color": "blue"
            //   });
            // }
            // else if (getDate != setDate) {
            //   // addData(setList[i + 1].id.toString(), setList[i + 1].location,
            //   //     setList[i + 1].time, "green");
            //   setmrkList.add({
            //     "id": sl[i + 1].id.toString(),
            //     "location": sl[i + 1].location,
            //     "time": sl[i + 1].time,
            //     // "color": "green"
            //     "color": "blue"
            //   });
            // }
            // else
            //  else if (tt > 5) {
            //   // addData(setList[i + 1].id.toString(), setList[i + 1].location,
            //   //     setList[i + 1].time, "green");
            //   setmrkList.add({
            //     "id": sl[i + 1].id.toString(),
            //     "location": sl[i + 1].location,
            //     "time": sl[i + 1].time,
            //     // "color": "green"
            //     "color": "blue"
            //   });
            // }
            // else {
            //   // addData(setList[i].id.toString(), setList[i].location, setList[i].time,
            //   //     "brown");
            //   // setmrkList.add({
            //   //   "id": setList[i].id.toString(),
            //   //   "location": setList[i].location,
            //   //   "time": setList[i].time,
            //   //   "color": "brown"
            //   // });
            // }
            // setmrkList.add({
            //     "id": sl[i].id.toString(),
            //     "location": sl[i].location,
            //     "time": sl[i].time,
            //     "color": "blue"
            //   });
          }
        }
      });

      // print("LAT/LONG >> $_markerLocations");
    });
  }

// if (sl[i]["location"].toString() == "null" ||
  //     sl[i]["location"] == "") {
  // } else {
  //   var index = setList[i].location.toString().indexOf(',');
  //   print("LOC >>>>> " + setList[i].location.toString());
  //   data.add({
  //     "latitude": setList[i].location.toString().substring(0, index),
  //     "longitude": setList[i].location.toString().substring(index + 1),
  //   });
  //   var getDate = sl[i]["time"].toString().substring(0, 10);
  //   var setDate = sl[i + 1]["time"].toString().substring(0, 10);
  //   // time for first
  //   var timestamp1 = sl[i]["time"].toString();
  //   var index1 = timestamp1.toString().indexOf('T');
  //   var hr1 = timestamp1.toString().substring(index1 + 1, index1 + 3);
  //   var mi1 = timestamp1.toString().substring(index1 + 4, index1 + 6);
  //   TimeOfDay testDate1 =
  //       TimeOfDay(hour: int.parse(hr1), minute: int.parse(mi1));
  //   int firstTime = testDate1.hour * 60 + testDate1.minute;
  //   // time for second
  //   var timestamp2 = sl[i + 1]["time"].toString();
  //   var index2 = timestamp2.toString().indexOf('T');
  //   var hr2 = timestamp2.toString().substring(index2 + 1, index2 + 3);
  //   var mi2 = timestamp2.toString().substring(index2 + 4, index2 + 6);
  //   TimeOfDay testDate2 =
  //       TimeOfDay(hour: int.parse(hr2), minute: int.parse(mi2));
  //   int secondTime = testDate2.hour * 60 + testDate2.minute;

  //   int tt = secondTime - firstTime;
  //     // print("TIME DIS >>> " + tt.toString());
  //     if (i == 0) {
  //       setmrkList.add({
  //         "id": sl[i]["id"].toString(),
  //         "location": sl[i]["location"],
  //         "time": sl[i]["time"],
  //         "color": "blue"
  //       });
  //       // addData(setList[i].id.toString(), setList[i].location,
  //       //     setList[i].time, "blue");
  //     } else if (i == (sl.length - 2)) {
  //       // addData(setList[i].id.toString(), setList[i].location,
  //       //     setList[i].time, "blue");
  //       setmrkList.add({
  //         "id": sl[i]["id"].toString(),
  //         "location": sl[i]["location"],
  //         "time": sl[i]["time"],
  //         "color": "blue"
  //       });
  //     } else if (getDate != setDate) {
  //       // addData(setList[i + 1].id.toString(), setList[i + 1].location,
  //       //     setList[i + 1].time, "green");
  //       setmrkList.add({
  //         "id": sl[i + 1]["id"].toString(),
  //         "location": sl[i + 1]["location"],
  //         "time": sl[i + 1]["time"],
  //         // "color": "green"
  //         "color": "blue"
  //       });
  //     } else if (tt > 10) {
  //       // addData(setList[i + 1].id.toString(), setList[i + 1].location,
  //       //     setList[i + 1].time, "green");
  //       setmrkList.add({
  //         "id": sl[i + 1]["id"].toString(),
  //         "location": sl[i + 1]["location"],
  //         "time": sl[i + 1]["time"],
  //         // "color": "green"
  //         "color": "blue"
  //       });
  //     } else {
  //       // addData(setList[i].id.toString(), setList[i].location, setList[i].time,
  //       //     "brown");
  //       // setmrkList.add({
  //       //   "id": setList[i].id.toString(),
  //       //   "location": setList[i].location,
  //       //   "time": setList[i].time,
  //       //   "color": "brown"
  //       // });
  //     }
  // }

  //Backup
  // for (var i = 0; i < sl.length; i++) {
  //   if (setList[i].location.toString() == "null" ||
  //       setList[i].location == "") {
  //   } else {
  //     // var index = setList[i].location.toString().indexOf(',');
  //     // print("LOC >>>>> " + setList[i].location.toString());
  //     // data.add({
  //     //   "latitude": setList[i].location.toString().substring(0, index),
  //     //   "longitude": setList[i].location.toString().substring(index + 1),
  //     // });
  //     var getDate = setList[i].time.toString().substring(0, 10);
  //     var setDate = setList[i + 1].time.toString().substring(0, 10);
  //     // time for first
  //     var timestamp1 = setList[i].time.toString();
  //     var index1 = timestamp1.toString().indexOf('T');
  //     var hr1 = timestamp1.toString().substring(index1 + 1, index1 + 3);
  //     var mi1 = timestamp1.toString().substring(index1 + 4, index1 + 6);
  //     TimeOfDay testDate1 =
  //         TimeOfDay(hour: int.parse(hr1), minute: int.parse(mi1));
  //     int firstTime = testDate1.hour * 60 + testDate1.minute;
  //     // time for second
  //     var timestamp2 = setList[i + 1].time.toString();
  //     var index2 = timestamp2.toString().indexOf('T');
  //     var hr2 = timestamp2.toString().substring(index2 + 1, index2 + 3);
  //     var mi2 = timestamp2.toString().substring(index2 + 4, index2 + 6);
  //     TimeOfDay testDate2 =
  //         TimeOfDay(hour: int.parse(hr2), minute: int.parse(mi2));
  //     int secondTime = testDate2.hour * 60 + testDate2.minute;

  //     int tt = secondTime - firstTime;
  //     // print("TIME DIS >>> " + tt.toString());
  //     if (i == 0) {
  //       setmrkList.add({
  //         "id": setList[i].id.toString(),
  //         "location": setList[i].location,
  //         "time": setList[i].time,
  //         "color": "blue"
  //       });
  //       // addData(setList[i].id.toString(), setList[i].location,
  //       //     setList[i].time, "blue");
  //     } else if (i == (setList.length - 2)) {
  //       // addData(setList[i].id.toString(), setList[i].location,
  //       //     setList[i].time, "blue");
  //       setmrkList.add({
  //         "id": setList[i].id.toString(),
  //         "location": setList[i].location,
  //         "time": setList[i].time,
  //         "color": "blue"
  //       });
  //     } else if (getDate != setDate) {
  //       // addData(setList[i + 1].id.toString(), setList[i + 1].location,
  //       //     setList[i + 1].time, "green");
  //       setmrkList.add({
  //         "id": setList[i + 1].id.toString(),
  //         "location": setList[i + 1].location,
  //         "time": setList[i + 1].time,
  //         // "color": "green"
  //         "color": "blue"
  //       });
  //     } else if (tt > 10) {
  //       // addData(setList[i + 1].id.toString(), setList[i + 1].location,
  //       //     setList[i + 1].time, "green");
  //       setmrkList.add({
  //         "id": setList[i + 1].id.toString(),
  //         "location": setList[i + 1].location,
  //         "time": setList[i + 1].time,
  //         // "color": "green"
  //         "color": "blue"
  //       });
  //     } else {
  //       // addData(setList[i].id.toString(), setList[i].location, setList[i].time,
  //       //     "brown");
  //       // setmrkList.add({
  //       //   "id": setList[i].id.toString(),
  //       //   "location": setList[i].location,
  //       //   "time": setList[i].time,
  //       //   "color": "brown"
  //       // });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // mrkList();
    checkLanguage();
    someMethod();
    dbHelper = DBHelper();
    testing();
    _getTargetLatLong();

    // _getLQ();

    // dbHelper = DBHelper();
    // _checkAndstartTrack();
    analyst();
  }

  _getCurrentLocation() async {
    bg.BackgroundGeolocation.getCurrentPosition().then((bg.Location locc) {
      // print('[getCurrentPosition] - $location');
      print("CUR LOC >> " + locc.coords.latitude.toString());

      // curseclat = location.coords.latitude.toString();
      // curseclong = location.coords.longitude.toString();
      // location =
      //     "${locc.coords.latitude.toString()}, ${locc.coords.longitude.toString()}";

      // print("location >>> $location");
      setState(() {
        var lat = locc.coords.latitude;
        var long = locc.coords.longitude;
        var id = "curloc";
        final marker = Marker(
          markerId: MarkerId(id.toString()),
          position: LatLng(
              double.parse(lat.toString()), double.parse(long.toString())),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: "Now",
            // title: time.toString(),
            // snippet: office.address,
          ),
        );
        _new_markers[id.toString()] = marker;
      });
    });
  }

  _getLQ() async {
    setState(() {
      final url = 'https://api.mcf.org.mm/api/qld_location/a';

      http.get(Uri.encodeFull(url), headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((res) {
        // var result = json.decode(res.body);
        var result = json.decode(utf8.decode(res.bodyBytes));
        print("LOC RES >>>  " + result.toString());

        for (var c = 0; c < result.length; c++) {
          // print("QC >> " + result[c]["name"]);
          var location =
              result[c]["lat"].toString() + ", " + result[c]["lng"].toString();
          var color;
          if (result[c]["type"] == 1) {
            color = "yellow";
          } else if (result[c]["type"] == 2) {
            color = "brown";
          }

          // setqcmrkList.add({
          //   "id": "qc" + result[c]["id"].toString(),
          //   "location": location,
          //   "name": result[c]["name"],
          //   "color": color
          // });
          setState(() {
            addQCData("qc" + result[c]["id"].toString(), location,
                result[c]["name"], color);
          });
        }

        // var resStatus = result['code'];
      }).catchError((Object error) async {
        print("ON ERROR >>");
      });
    });
  }

  // Future get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  // Future get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/qcList.txt');
  // }

  // Future readL() async {
  //   try {
  //     final file = await _localFile;

  //     // Read the file
  //     String rl = await file.readAsString();

  //     return rl;
  //   } catch (e) {
  //     // If we encounter an error, return 0
  //     return 0;
  //   }
  // }

  // getRead() async {
  //   print("QQQ>>");
  //   readL().then((res) {

  //     print("QC RES 3 >> $res");
  //     var ab = json.decode(res);
  //     print("QC RES AB >> "  + ab[0].toString());
  //   });
  // }

  // _getLQ() async {
  //   setState(() {
  //     final url = 'https://api.mcf.org.mm/api/qld_location/a';

  //     http.get(Uri.encodeFull(url), headers: {
  //       "Accept": "application/json",
  //       "content-type": "application/json"
  //     }).then((res) {
  //       // var result = json.decode(res.body);
  //       var result = json.decode(utf8.decode(res.bodyBytes));
  //       print("LOC RES >>>  " + result.toString());
  //       for (var c = 0; c < result.length; c++) {
  //         print("QC >> " + result[c]["name"]);
  //         var location =
  //             result[c]["lat"].toString() + ", " + result[c]["lng"].toString();
  //         var color;
  //         if (result[c]["type"] == 1) {
  //           color = "yellow";
  //         } else if (result[c]["type"] == 2) {
  //           color = "brown";
  //         }

  //         setmrkList.add({
  //           "id": "qc" + result[c]["id"].toString(),
  //           "location": location,
  //           "time": result[c]["name"],
  //           "color": color
  //         });

  //         // addQCData(
  //         //     "qc" + result[c]["id"].toString(),
  //         //     result[c]["lat"].toString(),
  //         //     result[c]["lng"].toString(),
  //         //     result[c]["name"],
  //         //     color);
  //         // addData("qc" + result[c]["id"].toString(), location,
  //         //     result[c]["name"], color);
  //         // print("CC1 >> " +
  //         //     "qc" +
  //         //     result[c]["id"].toString() +
  //         //     result[c]["lat"].toString() +
  //         //     result[c]["lng"].toString() +
  //         //     result[c]["name"] +
  //         //     color);
  //       }
  //       // var resStatus = result['code'];
  //     }).catchError((Object error) async {
  //       print("ON ERROR >>");
  //     });
  //   });
  // }

  // mrkList() async {
  //   final setList = await dbHelper.getEmployees();
  //   setState(() {
  //     for (var i = 0; i < setList.length; i++) {
  //       var getDate = setList[i].time.toString().substring(0, 10);
  //       var setDate = setList[i + 1].time.toString().substring(0, 10);
  //       // time for first
  //       var timestamp1 = setList[i].time.toString();
  //       var index1 = timestamp1.toString().indexOf('T');
  //       var hr1 = timestamp1.toString().substring(index1 + 1, index1 + 3);
  //       var mi1 = timestamp1.toString().substring(index1 + 4, index1 + 6);
  //       TimeOfDay testDate1 =
  //           TimeOfDay(hour: int.parse(hr1), minute: int.parse(mi1));
  //       int firstTime = testDate1.hour * 60 + testDate1.minute;
  //       // time for second
  //       var timestamp2 = setList[i + 1].time.toString();
  //       var index2 = timestamp2.toString().indexOf('T');
  //       var hr2 = timestamp2.toString().substring(index2 + 1, index2 + 3);
  //       var mi2 = timestamp2.toString().substring(index2 + 4, index2 + 6);
  //       TimeOfDay testDate2 =
  //           TimeOfDay(hour: int.parse(hr2), minute: int.parse(mi2));
  //       int secondTime = testDate2.hour * 60 + testDate2.minute;

  //       int tt = secondTime - firstTime;
  //       // print("TIME DIS >>> " + tt.toString());
  //       if (i == 0) {
  //         setmrkList.add({
  //           "id": setList[i].id.toString(),
  //           "location": setList[i].location,
  //           "time": setList[i].time,
  //           "color": "blue"
  //         });
  //         // addData(setList[i].id.toString(), setList[i].location,
  //         //     setList[i].time, "blue");
  //       } else if (i == (setList.length - 1)) {
  //         // addData(setList[i].id.toString(), setList[i].location,
  //         //     setList[i].time, "blue");
  //         setmrkList.add({
  //           "id": setList[i].id.toString(),
  //           "location": setList[i].location,
  //           "time": setList[i].time,
  //           "color": "blue"
  //         });
  //       } else if (getDate != setDate) {
  //         // addData(setList[i + 1].id.toString(), setList[i + 1].location,
  //         //     setList[i + 1].time, "green");
  //         setmrkList.add({
  //           "id": setList[i + 1].id.toString(),
  //           "location": setList[i + 1].location,
  //           "time": setList[i + 1].time,
  //           "color": "green"
  //         });
  //       } else if (tt > 10) {
  //         // addData(setList[i + 1].id.toString(), setList[i + 1].location,
  //         //     setList[i + 1].time, "green");
  //         setmrkList.add({
  //           "id": setList[i + 1].id.toString(),
  //           "location": setList[i + 1].location,
  //           "time": setList[i + 1].time,
  //           "color": "green"
  //         });
  //       } else {
  //         // addData(setList[i].id.toString(), setList[i].location, setList[i].time,
  //         //     "brown");
  //         setmrkList.add({
  //           "id": setList[i].id.toString(),
  //           "location": setList[i].location,
  //           "time": setList[i].time,
  //           "color": "brown"
  //         });
  //       }
  //     }
  //   });
  // }

  analyst() async {
    await analytics.logEvent(
      name: 'Map_Request',
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

  @override
  void dispose() {
    // timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  _getTargetLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    var lLat = prefs.getString("last-lat") ?? 0;
    var lLong = prefs.getString("last-long") ?? 0;
    print("L/L >> " + lLat.toString() + lLong.toString());
    if (lLat == 0 || lLong == 0) {
      _targetLatLong = LatLng(22.9087267, 96.4237433);
    } else {
      _targetLatLong = LatLng(double.parse(lLat), double.parse(lLong));
    }
    // print("LL >> " + lLat + lLong);

    // _targetLatLong = LatLng(16.8822700, 96.121611);
  }

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  convertDateTime() {
    DateTime now = DateTime.now();
    var yr = DateFormat.y().format(now);
    var mn = DateFormat.M().format(now);
    if (mn.length == 1) {
      mn = "0" + mn;
    }
    var dy = DateFormat.d().format(now);
    if (dy.length == 1) {
      dy = "0" + dy;
    }
    // var time = new DateFormat.jm().format(now);
    var dt = yr + "-" + mn + "-" + dy;
    return dt;
  }

  addData(id, location, time, color) async {
    var index = location.toString().indexOf(',');
    var lat = location.toString().substring(0, index);
    var long = location.toString().substring(index + 1);
    final marker = Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(double.parse(lat), double.parse(long)),
      icon: color == "blue"
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          : color == "green"
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : color == "brown"
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRose)
                  : color == "yellow"
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow)
                      : BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(
        title: time.toString().replaceAll("T", " "),
        // title: time.toString(),
        // snippet: office.address,
      ),
    );
    _new_markers[id.toString()] = marker;
  }

  addQCData(id, location, time, color) async {
    var index = location.toString().indexOf(',');
    var lat = location.toString().substring(0, index);
    var long = location.toString().substring(index + 1);
    final marker = Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(double.parse(lat), double.parse(long)),
      icon: color == "blue"
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          : color == "green"
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : color == "brown"
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta)
                  : color == "yellow"
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow)
                      : BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(
        // title: time.toString().replaceAll("T", " "),
        title: time.toString(),
        // snippet: office.address,
      ),
    );
    _new_markers[id.toString()] = marker;
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    // final List<MapMarker> markers = [];

    // var dbHelper = DBHelper();

    // final sl = await dbHelper.getEmployees();
    // final sl = sl1.reversed.toList();
    setState(() {
      _new_markers.clear();
      _getCurrentLocation();
      Future.delayed(const Duration(milliseconds: 2000), () {
        for (var j = 0; j < setmrkList.length; j++) {
          print("JJJccc >>> " + setmrkList[j]["time"].toString());
          setState(() {
            addData(
                setmrkList[j]["id"].toString(),
                setmrkList[j]["location"].toString(),
                setmrkList[j]["time"].toString(),
                setmrkList[j]["color"].toString());
          });
        }
      });
      _getLQ();

      // Future.delayed(const Duration(milliseconds: 2000), () {
      //   //   print("QCCC >> " + setqcmrkList.toString());

      //   // addData("qc11", "16.835009, 96.1937", "fucktime", "yellow");
      //   for (var c = 0; c < setqcmrkList.length; c++) {
      //     // print("JJJ >>> " + setqcmrkList[c]["location"].toString());
      //     setState(() {
      //       addData(
      //           setqcmrkList[c]["id"].toString(),
      //           setqcmrkList[c]["location"].toString(),
      //           setqcmrkList[c]["name"].toString(),
      //           setqcmrkList[c]["color"].toString());
      //     });
      //   }
      // });
      // //------ Start first last marker ----------
      // int startIdx = 0;
      // int checkStr = 0;
      // int endIdx = 0;

      // for (var i = 0; i < sl.length; i++) {
      //   // for (var i = 0; i < cl; i++) {
      //   if (sl[i].location.toString() == "null" || sl[i].location == "") {
      //   } else {
      //     var time = sl[i].time.toString().substring(0, 10);
      //     var nowTime = convertDateTime();

      //     if (time == nowTime) {
      //       if (checkStr == 0) {
      //         startIdx = i;
      //         checkStr = 1;
      //       } else {
      //         endIdx = i;
      //       }
      //     }
      //   }
      // }

      // print("START >>> " + startIdx.toString());
      // print("END >>> " + endIdx.toString());

      // setState(() {
      //   // if(startIdx)
      //   // if (sl.length != 0) {
      //   var index = sl[startIdx].location.toString().indexOf(',');
      //   var lat = sl[startIdx].location.toString().substring(0, index);
      //   var long = sl[startIdx].location.toString().substring(index + 1);

      //   final marker = Marker(
      //     markerId: MarkerId(sl[startIdx].id.toString()),
      //     position: LatLng(double.parse(lat), double.parse(long)),
      //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //     infoWindow: InfoWindow(
      //       title: sl[startIdx].time.toString().replaceAll("T", " "),
      //       // snippet: office.address,
      //     ),
      //   );
      //   _new_markers[sl[startIdx].id.toString()] = marker;

      //   if (endIdx != 0) {
      //     var index = sl[endIdx].location.toString().indexOf(',');
      //     var lat = sl[endIdx].location.toString().substring(0, index);
      //     var long = sl[endIdx].location.toString().substring(index + 1);

      //     final marker = Marker(
      //       markerId: MarkerId(sl[endIdx].id.toString()),
      //       position: LatLng(double.parse(lat), double.parse(long)),
      //       icon:
      //           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //       infoWindow: InfoWindow(
      //         title: sl[endIdx].time.toString().replaceAll("T", " "),
      //         // snippet: office.address,
      //       ),
      //     );
      //     _new_markers[sl[endIdx].id.toString()] = marker;
      //   }
      //   // }
      // });

      // //------ End first last marker ----------

      // setState(() {
      //   // if(startIdx)

      // });

      // // // int convGetToMin = 0;
      // // // var ctime;
      // // // int tc = 0;

      // for (var i = 0; i < (sl.length - 1); i++) {
      // // // for (var i = 0; i < sl.length; i++) {
      // // //   // for (var i = 0; i < cl; i++) {
      // // //   if (sl[i].location.toString() == "null" || sl[i].location == "") {
      // // //   } else {
      // // //     var index = sl[i].location.toString().indexOf(',');
      // // //     var lat = sl[i].location.toString().substring(0, index);
      // // //     var long = sl[i].location.toString().substring(index + 1);
      // // //     var time = sl[i].time.toString().substring(0, 10);
      // // //     var nowTime = convertDateTime();

      // // //     //First Value
      // // //     var idx = sl[i].time.toString().indexOf('T');
      // // //     var hr = sl[i].time.toString().substring(idx + 1, idx + 3);
      // // //     var mi = sl[i].time.toString().substring(idx + 4, idx + 6);

      // // //     TimeOfDay testDate =
      // // //         TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
      // // //     int testDateInMinutes = testDate.hour * 60 + testDate.minute;

      // // //     if (time == nowTime) {
      // // //       tc = 1;
      // // //       if (tc == 0) {
      // // //         if (sl[i].remark == "Auto") {
      // // //           setState(() {
      // // //             final marker = Marker(
      // // //               markerId: MarkerId(sl[i].id.toString()),
      // // //               position: LatLng(double.parse(lat), double.parse(long)),
      // // //               icon: BitmapDescriptor.defaultMarkerWithHue(
      // // //                   BitmapDescriptor.hueGreen),
      // // //               infoWindow: InfoWindow(
      // // //                 title: sl[i].time,
      // // //                 // snippet: office.address,
      // // //               ),
      // // //             );

      // // //             _new_markers[sl[i].id.toString()] = marker;
      // // //           });
      // // //         } else {
      // // //           setState(() {
      // // //             final marker = Marker(
      // // //               markerId: MarkerId(sl[i].id.toString()),
      // // //               position: LatLng(double.parse(lat), double.parse(long)),
      // // //               icon: BitmapDescriptor.defaultMarkerWithHue(
      // // //                   BitmapDescriptor.hueBlue),
      // // //               infoWindow: InfoWindow(
      // // //                 title: sl[i].time,
      // // //                 // snippet: office.address,
      // // //               ),
      // // //             );

      // // //             _new_markers[sl[i].id.toString()] = marker;
      // // //           });
      // // //         }
      // // //       }

      // // //       int lr = sl.length;
      // // //       print("LAST LIST >>> $lr -" + sl[lr - 1].time.toString());
      // // //       // sl.length == 0 ||

      // // //       if (sl[lr - 1].remark == "Auto") {
      // // //         setState(() {
      // // //           final marker = Marker(
      // // //             markerId: MarkerId(sl[lr - 1].id.toString()),
      // // //             position: LatLng(double.parse(lat), double.parse(long)),
      // // //             icon: BitmapDescriptor.defaultMarkerWithHue(
      // // //                 BitmapDescriptor.hueGreen),
      // // //             infoWindow: InfoWindow(
      // // //               title: sl[lr - 1].time,
      // // //               // snippet: office.address,
      // // //             ),
      // // //           );

      // // //           _new_markers[sl[lr - 1].id.toString()] = marker;
      // // //         });
      // // //       } else {
      // // //         setState(() {
      // // //           final marker = Marker(
      // // //             markerId: MarkerId(sl[lr - 1].id.toString()),
      // // //             position: LatLng(double.parse(lat), double.parse(long)),
      // // //             icon: BitmapDescriptor.defaultMarkerWithHue(
      // // //                 BitmapDescriptor.hueBlue),
      // // //             infoWindow: InfoWindow(
      // // //               title: sl[lr - 1].time,
      // // //               // snippet: office.address,
      // // //             ),
      // // //           );

      // // //           _new_markers[sl[lr - 1].id.toString()] = marker;
      // // //         });
      // // //       }

      // // //       if (tc != 0) {
      // // //         //Second Value
      // // //         var hr1 = sl[(i + 1)].time.toString().substring(idx + 1, idx + 3);
      // // //         var mi1 = sl[(i + 1)].time.toString().substring(idx + 4, idx + 6);

      // // //         TimeOfDay testDate1 =
      // // //             TimeOfDay(hour: int.parse(hr1), minute: int.parse(mi1));
      // // //         int testDateInMinutes1 = testDate1.hour * 60 + testDate1.minute;

      // // //         if ((testDateInMinutes + 5) > testDateInMinutes1) {
      // // //           //Show
      // // //           convGetToMin = testDateInMinutes;
      // // //         } else {
      // // //           //Not show
      // // //           if (sl[i].remark == "Auto") {
      // // //             final marker = Marker(
      // // //               markerId: MarkerId(sl[i].id.toString()),
      // // //               position: LatLng(double.parse(lat), double.parse(long)),
      // // //               icon: BitmapDescriptor.defaultMarkerWithHue(
      // // //                   BitmapDescriptor.hueGreen),
      // // //               infoWindow: InfoWindow(
      // // //                 title: sl[i].time,
      // // //                 // snippet: office.address,
      // // //               ),
      // // //             );
      // // //             setState(() {
      // // //               _new_markers[sl[i].id.toString()] = marker;
      // // //             });
      // // //           } else {
      // // //             final marker = Marker(
      // // //               markerId: MarkerId(sl[i].id.toString()),
      // // //               position: LatLng(double.parse(lat), double.parse(long)),
      // // //               icon: BitmapDescriptor.defaultMarkerWithHue(
      // // //                   BitmapDescriptor.hueBlue),
      // // //               infoWindow: InfoWindow(
      // // //                 title: sl[i].time,
      // // //                 // snippet: office.address,
      // // //               ),
      // // //             );
      // // //             setState(() {
      // // //               _new_markers[sl[i].id.toString()] = marker;
      // // //             });
      // // //           }
      // // //         }
      // // //       }
      // // //     } else {}
      // // //   }

      // // for (var i = 0; i < sl.length; i++) {
      // //   // print("SL >>> " + sl[i].location.toString());
      // //   // } else {)
      // //   if (sl[i].location.toString() == "null" || sl[i].location == "") {
      // //   } else {
      // //     var index = sl[i].location.toString().indexOf(',');
      // //     var lat = sl[i].location.toString().substring(0, index);
      // //     var long = sl[i].location.toString().substring(index + 1);
      // //     // print("Lth >> "+sl[i].length.toString())
      // //     var time = sl[i].time.toString().substring(0, 10);
      // //     var nowTime = convertDateTime();

      // //     var idx = sl[i].time.toString().indexOf('T');
      // //     // var yr = sl[i].location.toString().substring(0, 4);
      // //     // var mn = sl[i].location.toString().substring(5, 7);
      // //     // var dy = sl[i].location.toString().substring(8, 10);
      // //     var hr = sl[i].time.toString().substring(idx + 1, idx + 3);
      // //     var mi = sl[i].time.toString().substring(idx + 4, idx + 6);
      // //     // print("AT >> " + yr.toString() + mn.toString() + dy.toString());
      // //     TimeOfDay testDate =
      // //         TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
      // //     int testDateInMinutes = testDate.hour * 60 + testDate.minute;

      // //     print("ML >> " + time + "Vs" + nowTime);
      // //     if (time == nowTime) {
      // //       if(i == sl.length){
      // //         final marker = Marker(
      // //           markerId: MarkerId(sl[i].id.toString()),
      // //           position: LatLng(double.parse(lat), double.parse(long)),
      // //           icon: BitmapDescriptor.defaultMarkerWithHue(
      // //               BitmapDescriptor.hueBlue),
      // //           infoWindow: InfoWindow(
      // //             title: sl[i].time,
      // //             // snippet: office.address,
      // //           ),
      // //         );
      // //         setState(() {
      // //           _new_markers[sl[i].id.toString()] = marker;
      // //         });
      // //       }
      // //       ctime = convGetToMin + 5;
      // //       print("CT123 >>  " +
      // //           ctime.toString() +
      // //           ":" +
      // //           testDateInMinutes.toString());
      // //       if (testDateInMinutes < ctime) {
      // //         // if (ct == convGetToMin) {
      // //         // snackbarmethod1("Close Interval!");
      // //         if (ctime == 5) {
      // //           convGetToMin = testDateInMinutes;
      // //           // final marker = Marker(
      // //           //   markerId: MarkerId(sl[i].id.toString()),
      // //           //   position: LatLng(double.parse(lat), double.parse(long)),
      // //           //   icon: BitmapDescriptor.defaultMarkerWithHue(
      // //           //       BitmapDescriptor.hueBlue),
      // //           //   infoWindow: InfoWindow(
      // //           //     title: sl[i].time,
      // //           //     // snippet: office.address,
      // //           //   ),
      // //           // );
      // //           // setState(() {
      // //           //   _new_markers[sl[i].id.toString()] = marker;
      // //           // });
      // //         }
      // //       } else {
      // //         print("ABCCCC>>");
      // //         convGetToMin = testDateInMinutes;
      // //         final marker = Marker(
      // //           markerId: MarkerId(sl[i].id.toString()),
      // //           position: LatLng(double.parse(lat), double.parse(long)),
      // //           icon: BitmapDescriptor.defaultMarkerWithHue(
      // //               BitmapDescriptor.hueBlue),
      // //           infoWindow: InfoWindow(
      // //             title: sl[i].time,
      // //             // snippet: office.address,
      // //           ),
      // //         );
      // //         setState(() {
      // //           _new_markers[sl[i].id.toString()] = marker;
      // //         });
      // //       }

      // //     }
      // //   }

      // if (list.location.toString() == "null" || list.location == "") {
      // } else {
      //   var index = list.location.toString().indexOf(',');
      //   var lat = list.location.toString().substring(0, index);
      //   var long = list.location.toString().substring(index + 1);
      //   // print("Lth >> "+list.length.toString())
      //   var time = list.time.toString().substring(0, 10);
      //   var nowTime = convertDateTime();

      //   var idx = list.location.toString().indexOf('T');
      //   // var yr = list.location.toString().substring(0, 4);
      //   // var mn = list.location.toString().substring(5, 7);
      //   // var dy = list.location.toString().substring(8, 10);
      //   var hr = list.location.toString().substring(idx + 1, idx + 3);
      //   var mi = list.location.toString().substring(idx + 4, idx + 6);
      //   // print("AT >> " + yr.toString() + mn.toString() + dy.toString());
      //   TimeOfDay testDate =
      //       TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
      //   int testDateInMinutes = testDate.hour * 60 + testDate.minute;

      //   print("ML >> " + time + "Vs" + nowTime);
      //   if (time == nowTime) {
      //      ctime = convGetToMin + 3;
      //     print("CT123 >>  " +
      //         ctime.toString() +
      //         ":" +
      //         testDateInMinutes.toString());
      //     if (testDateInMinutes < ctime) {
      //       // if (ct == convGetToMin) {
      //       // snackbarmethod1("Close Interval!");
      //       if (ctime == 3) {
      //         convGetToMin = testDateInMinutes;
      //         final marker = Marker(
      //           markerId: MarkerId(list.id.toString()),
      //           position: LatLng(double.parse(lat), double.parse(long)),
      //           icon: BitmapDescriptor.defaultMarkerWithHue(
      //               BitmapDescriptor.hueBlue),
      //           infoWindow: InfoWindow(
      //             title: list.time,
      //             // snippet: office.address,
      //           ),
      //         );
      //         setState(() {
      //           _new_markers[list.id.toString()] = marker;
      //         });
      //       }
      //     } else {
      //       print("ABCCCC>>");
      //       convGetToMin = testDateInMinutes;
      //       final marker = Marker(
      //         markerId: MarkerId(list.id.toString()),
      //         position: LatLng(double.parse(lat), double.parse(long)),
      //         icon: BitmapDescriptor.defaultMarkerWithHue(
      //             BitmapDescriptor.hueBlue),
      //         infoWindow: InfoWindow(
      //           title: list.time,
      //           // snippet: office.address,
      //         ),
      //       );
      //       setState(() {
      //         _new_markers[list.id.toString()] = marker;
      //       });
      //     }
      //   }
      // }
      // // // }
    });

    // for (LatLng markerLocation in _markerLocations) {
    // final BitmapDescriptor markerImage =
    //     await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

    // markers.add(
    //   MapMarker(
    //     id: _markerLocations.indexOf(markerLocation).toString(),
    //     position: markerLocation,
    //     // icon: markerImage,
    //     icon: BitmapDescriptor.defaultMarker,
    //   ),
    // );
    //   print("haha $markerLocation");
    // }

    // _clusterManager = await MapHelper.initClusterManager(
    //   markers,
    //   _minClusterZoom,
    //   _maxClusterZoom,
    // );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    // _markers
    //   ..clear()
    //   ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
            lan == "Zg"
                ? Rabbit.uni2zg(textMyan[0]) + " (Map)"
                : textMyan[0] + " (Map)",
            // checklang == "Eng" ? textEng[0] : textMyan[0] + " (Map)",
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
            //   child: GoogleMap(
            //     initialCameraPosition: CameraPosition(
            //       target: _mainLocation,
            //       zoom: 12.0,
            //     ),
            //     // markers: this.myMarker(),
            //     markers: {

            //       newyork1Marker,
            //       newyork2Marker
            //     },
            //     mapType: MapType.normal,
            //     onMapCreated: (controller) {
            //       setState(() {
            //         myMapController = controller;
            //       });
            //     },
            //   ),

            child: GoogleMap(
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                // target: LatLng(22.908325, 96.4234917),
                target: _targetLatLong,
                zoom: _currentZoom,
              ),
              markers: _new_markers.values.toSet(),
              onMapCreated: _onMapCreated,
              onCameraMove: (position) => _updateMarkers(position.zoom),
            ),
          ),
        ],
      ),
      //--->>Old
      // Stack(
      //   children: <Widget>[
      //     // Google Map widget
      //     Opacity(
      //       opacity: _isMapLoading ? 0 : 1,
      //       child: GoogleMap(
      //         mapToolbarEnabled: false,
      //         initialCameraPosition: CameraPosition(
      //           target: LatLng(16.8822782, 96.121694),
      //           zoom: _currentZoom,
      //         ),
      //         markers: _markers,
      //         onMapCreated: (controller) => _onMapCreated(controller),
      //         onCameraMove: (position) => _updateMarkers(position.zoom),
      //       ),
      //     ),

      //     // Map loading indicator
      //     Opacity(
      //       opacity: _isMapLoading ? 1 : 0,
      //       child: Center(child: CircularProgressIndicator()),
      //     ),

      //     // Map markers loading indicator
      //     if (_areMarkersLoading)
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Align(
      //           alignment: Alignment.topCenter,
      //           child: Card(
      //             elevation: 2,
      //             color: Colors.grey.withOpacity(0.9),
      //             child: Padding(
      //               padding: const EdgeInsets.all(4),
      //               child: Text(
      //                 'Loading',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
    );
  }

  // Set<Marker> myMarker() {
  //   setState(() {
  //     //   // new Timer(const Duration(milliseconds: 50), () {
  //     //   // print("marker>>>>" +
  //     //   //     data[0]["latitude"].toString() +
  //     //   //     "|" +
  //     //   //     data[0]["longitude"].toString());
  //     //   _markers1.add(Marker(
  //     //     // This marker id can be anything that uniquely identifies each marker.
  //     //     markerId: MarkerId(_mainLocation.toString()),
  //     //     // position: LatLng(double.parse(data[0]["latitude"].toString()),
  //     //     //     double.parse(data[0]["longitude"].toString())),
  //     //     position: LatLng(22.908325, 96.4234917),
  //     //     infoWindow: InfoWindow(
  //     //       title: 'Historical City',
  //     //       snippet: '5 Star Rating',
  //     //     ),
  //     //     icon: BitmapDescriptor.defaultMarker,
  //     //   ));
  //     //   return _markers1;
  //     // });
  //   });
  // }
}
