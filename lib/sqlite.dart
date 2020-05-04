import 'dart:convert';
import 'package:TraceMyanmar/Drawer/drawer.dart';
import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/edit_checkin.dart';
import 'package:TraceMyanmar/location/helpers/singleMkr_map.dart';
import 'package:TraceMyanmar/location/pages/home_page.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:TraceMyanmar/version_history.dart';
import 'package:device_id/device_id.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'employee.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class Sqlite extends StatefulWidget {
  final String value;

  Sqlite({Key key, this.value}) : super(key: key);
  @override
  _SqliteState createState() => _SqliteState();
}

class _SqliteState extends State<Sqlite> {
  SlidableController slidableController = SlidableController();

  double calDisc(lat1, lon1, lat2, lon2) {
    final Distance distance = new Distance();
    var meter = distance(new LatLng(double.parse(lat1), double.parse(lon1)),
        new LatLng(double.parse(lat2), double.parse(lon2)));
    return meter;
  }

  // Future<List<Employee>> employees;
  var employeesLst = [];
  // var employeesLstTest = [];
  TextEditingController controller = TextEditingController();
  final chklocNameCtr = TextEditingController();
  final chkremarkCtrl = TextEditingController();
  String name, id, righttime, rid;
  String location = "";
  int curUserId;
  String deviceId = "";
  String alertmsg = "";
  final formKey = new GlobalKey<FormState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var dbHelper;
  bool isUpdating;
  String _locationMessage = "";
  String lat = "";
  String long = "";
  String latt = "";
  String longg = "";
  String formattedDate;
  final _formKey = new GlobalKey<FormState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  DateTime current;
  String _scanBarcode = "";
  var scanresult;
  String result;
  String color;
  String checklang = '';
  String remark = "";

  bool showArrow = false;

  var _start;
  var _syncstart;
  Timer timer;
  Timer syncTimer;
  var lan;
  // bool _isLoading = true;

  List textMyan = [
    "GPS Check In",
    "QR Check In",
    "တင်ပို့ပါ",
    "ဗားရှင်း 1.0.18"
  ];
  List textEng = ["GPS Check In", "QR Check In", "Submit", "Version 1.0.18"];
  final String url =
      "https://play.google.com/store/apps/details?id=com.mit.TraceMyanmar2020&hl=en";

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

  _openURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Future scanBarcodeNormal() async {
  //   String barcodeScanRes = "";
  //   try {
  //     barcodeScanRes = await scanner.scan();
  //     if (barcodeScanRes != null) {
  //       if (barcodeScanRes.substring(0, 1) == "{") {
  //         print(barcodeScanRes);
  //         // var route = new MaterialPageRoute(
  //         //     builder: (BuildContext context) =>
  //         //         new Sqlite());
  //         // Navigator.of(context).push(route);
  //         scanresult = jsonDecode(barcodeScanRes);
  //         result = scanresult["rid"];
  //         rid = result;

  //         remark = scanresult["remark"];
  //         // print("RMK >> " + remark.toString());
  //         validate();
  //         setState(() {});
  //       } else {
  //         print("haha");
  //       }
  //     } else {
  //       scanBarcodeNormal();
  //     }
  //     setState(() {
  //       _scanBarcode = barcodeScanRes;
  //       print(_scanBarcode);
  //       alertmsg = _scanBarcode;
  //       // this._method1();
  //     });
  //     // } on PlatformException catch(ex){
  //     //   if(ex.code == BarcodeScanner.CameraAccessDenied){
  //     //     setState(() {
  //     //       alertmsg = "The permission was denied.";
  //     //     });
  //     //   }else{
  //     //     setState(() {
  //     //       alertmsg = "unknown error ocurred $ex";
  //     //     });
  //     //   }
  //   } on FormatException {
  //     setState(() {
  //       alertmsg = "Scan canceled, try again !";
  //       print(alertmsg);
  //     });
  //   } catch (e) {
  //     alertmsg = "Unknown error $e";
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString("errorLog", "ERROR FROM SQLITE >> " + e);
  //   }
  //   print(barcodeScanRes);
  //   // this._method1();
  // }

  void _onItemTapped(int index) {
    setState(() {
      // _selectedIndex = index;
    });
  }

  Future<bool> popped() {
    // DateTime now = DateTime.now();
    // if (current == null || now.difference(current) > Duration(seconds: 2)) {
    //   current = now;
    //   Fluttertoast.showToast(
    //     msg: "Press back Again To exit !",
    //     toastLength: Toast.LENGTH_SHORT,
    //   );
    //   return Future.value(false);
    // } else {
    Fluttertoast.cancel();
    return Future.value(true);
    // }
  }

  // Timer timer;

  @override
  void initState() {
    super.initState();
    saveRef();
    checkLanguage();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
    _getDeviceId();
    gettime();
    // _checkTimer();
    // _checkAutoSync();
    _getLastLatLong();
    _getCurrentLocation();
    someMethod();
    analyst();

    _getversion();

    // setState(() {});

    // _checkAndstartTrack();
    // slidableController = SlidableController(
    //   // onSlideAnimationChanged: handleSlideAnimationChanged,
    //   onSlideIsOpenChanged: handleSlideIsOpenChanged,
    // );
// _syncList();
    // _startBG();
  }

  @override
  void dispose() {
    // timer.cancel();
    // syncTimer.cancel();
    super.dispose();
  }

  _getversion() async {}

  analyst() async {
    await analytics.logEvent(
      name: 'CheckInList_Request',
      parameters: <String, dynamic>{
        // 'string': myController.text,
      },
    );
  }

  Future someMethod() async {
    String deviceLanguage = await Devicelocale.currentLocale;
    var checkfont = deviceLanguage.substring(3, 5);
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

  // _startBG() {
  //   bg.BackgroundGeolocation.onLocation(_onLocation);
  //   // bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
  //   // bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
  //   bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
  //   // bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

  //   // 2.  Configure the plugin
  //   // bg.BackgroundGeolocation.ready(bg.Config(

  //   //         // desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
  //   //         // distanceFilter: 10.0,
  //   //         // // stopOnTerminate: false,
  //   //         // // startOnBoot: true,
  //   //         // // debug: true,
  //   //         // autoSync: true,
  //   //         // logLevel: bg.Config.LOG_LEVEL_VERBOSE,
  //   //         // // reset: true,
  //   //         // // enableTimestampMeta: true,
  //   //         // notificationTitle: "TraceMM",
  //   //         // notificationText: "location"
  //   //         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
  //   //         distanceFilter: 10.0,
  //   //         stopOnTerminate: false,
  //   //         startOnBoot: true,
  //   //         debug: true,
  //   //         logLevel: bg.Config.LOG_LEVEL_VERBOSE,
  //   //         notificationTitle: "Saw Saw Shar",
  //   //         notificationText: "Movement",
  //   //         reset: true))
  //   //     .then((bg.State state) {
  //   // setState(() {
  //   // bg.BackgroundGeolocation.start();
  //   bg.BackgroundGeolocation.start().then((bg.State state) {
  //     // print('[start] success >> ' + state.enabled.toString());
  //     // // //   // final prefs = await SharedPreferences.getInstance();
  //     // // //   // var cp = prefs.getString("changePace") ?? "false";
  //     // // //   // if (cp == "false") {
  //     bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
  //       print('[changePace] success $isMoving');
  //       // prefs.setString("changePace", "true");
  //       // _syncList();
  //     }).catchError((e) {
  //       print('[changePace] ERROR: ' + e.code.toString());
  //     });
  //     // // //   // } else {
  //     // // //   //   _syncList();
  //     // // //   // }
  //   }).catchError((e) {
  //     print('[start] ERROR: ' + e.code.toString());
  //     bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
  //       print('[changePace] success $isMoving');
  //     }).catchError((e) {
  //       print('[changePace] ERROR1: ' + e.code.toString());
  //     });
  //   });
  // }

  // void _onLocation(bg.Location location) async {
  //   // locCount = locCount + 1;
  //   print('[location] >>>> ' + location.timestamp.toString());
  // }

  // void _onProviderChange(bg.ProviderChangeEvent event) {
  //   // print('PRO CHG EVE >>> $event');
  //   setState(() {
  //     // _content = encoder.convert(event.toMap());
  //     // trackingArray.add(_content);
  //   });
  // }

  saveRef() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refferences", "not first time");
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  // //-->>For sync timer
  // _checkAutoSync() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   int val = prefs.getInt("autoSyncTimer") ?? 0;

  //   if (val == 0) {
  //     _syncstart = syncInterval;
  //     countDownSaveForSync();
  //   } else {
  //     _syncstart = val.toString();
  //     countDownSaveForSync();
  //   }
  // }

  // countDownSaveForSync() {
  //   print("START >> $_syncstart");
  //   const oneSec = const Duration(seconds: 1);
  //   syncTimer = Timer.periodic(
  //     oneSec,
  //     (Timer t) => setState(
  //       () {
  //         if (_syncstart == 0) {
  //           // _getCurrentLocationForTrack();
  //           // sendData();
  //           _syncList("1");
  //           refreshList();
  //           syncTimer.cancel();
  //         } else {
  //           _syncstart = int.parse(_syncstart.toString()) - 1;
  //           savesyncTimer();
  //           // print("Sec>>" + _start.toString());
  //         }
  //         print("CD11 >> " + _syncstart.toString());
  //       },
  //     ),
  //   );
  // }

  // savesyncTimer() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("autoSyncTimer", _syncstart);
  // }

  // //-->>End for sync timer

  // //-->>For submitting timer
  // _checkTimer() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   int val = prefs.getInt("timer") ?? 0;

  //   if (val == 0) {
  //     _start = startInterval;
  //     countDownSave();
  //   } else {
  //     _start = val.toString();
  //     countDownSave();
  //   }
  // }

  // countDownSave() {
  //   print("START >> $_start");
  //   const oneSec = const Duration(seconds: 1);
  //   timer = Timer.periodic(
  //     oneSec,
  //     (Timer t) => setState(
  //       () {
  //         if (_start == 0) {
  //           // _getCurrentLocationForTrack();
  //           sendData();
  //           timer.cancel();
  //         } else {
  //           _start = int.parse(_start.toString()) - 1;
  //           saveTimer();
  //           // print("Sec>>" + _start.toString());
  //         }

  //         if (_start == 10) {
  //           _syncList("1");
  //         }
  //         print("CD >> " + _start.toString());
  //       },
  //     ),
  //   );
  // }

  // saveTimer() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("timer", _start);
  // }

  // sendData() async {
  //   // print("DATE >> $dt");
  //   // snackbarmethod1("Loading...");
  //   final prefs = await SharedPreferences.getInstance();
  //   var ph = prefs.getString('UserId');
  //   var setList = [];
  //   setList = await dbHelper.getEmployees();
  //   // setState(() {});
  //   var data = [];
  //   var comTime;
  //   for (var i = 0; i < setList.length; i++) {
  //     // print("AAA >> ${setList[i].location}");
  //     if (setList[i].location == null || setList[i].location == "") {
  //     } else {
  //       if (setList[i].color.toString() == "0") {
  //         if (i == 0) {
  //           comTime = setList[i].time.toString();
  //         } else {
  //           comTime = setList[i - 1].time.toString();
  //         }

  //         var ii1 = comTime.indexOf('T');
  //         var yr1 = comTime.substring(0, 4);
  //         var mn1 = comTime.substring(5, 7);
  //         var dy1 = comTime.substring(8, 10);
  //         var hr1 = comTime.substring(ii1 + 1, ii1 + 3);
  //         var mi1 = comTime.substring(ii1 + 4, ii1 + 6);
  //         final coTime = DateTime(int.parse(yr1), int.parse(mn1),
  //             int.parse(dy1), int.parse(hr1), int.parse(mi1));

  //         var ii = setList[i].time.toString().indexOf('T');
  //         var yr = setList[i].time.toString().substring(0, 4);
  //         var mn = setList[i].time.toString().substring(5, 7);
  //         var dy = setList[i].time.toString().substring(8, 10);
  //         var hr = setList[i].time.toString().substring(ii + 1, ii + 3);
  //         var mi = setList[i].time.toString().substring(ii + 4, ii + 6);
  //         final gcTime = DateTime(int.parse(yr), int.parse(mn), int.parse(dy),
  //             int.parse(hr), int.parse(mi));

  //         var duration = gcTime.difference(coTime).inMinutes.toString();

  //         var index = setList[i].location.toString().indexOf(',');
  //         // [{"mid":null,"did":"4e2f63299f46aa50","mhash":"","dhash":"","timestamp":"2020-04-13","duration":1.0,"lat":22.909595,"lng":96.4212117,"source":"TraceMyanmar","eventname":null,"location":"22.909595, 96.4212117","remark":"","contact":"","contacttype":"GPS"}]
  //         // print("DATE >> " + setList[i].time.toString());
  //         // var timestamp = setList[i].time.toString().substring(0, 10);
  //         // print("timestamp>> $timestamp");
  //         data.add({
  //           "mid": ph,
  //           "did": deviceId,
  //           "mhash": deviceId,
  //           "dhash": "",
  //           "timestamp": setList[i].time.toString(),
  //           "duration": double.parse(duration),
  //           "lat": double.parse(
  //               setList[i].location.toString().substring(0, index)),
  //           "lng": double.parse(
  //               setList[i].location.toString().substring(index + 1)),
  //           "source": submitSource,
  //           "eventname": setList[i].rid,
  //           "location": setList[i].location,
  //           "remark": setList[i].remark.toString(),
  //           "contact": "",
  //           "contacttype": "GPS"
  //           // "time": setList[i].time
  //         });
  //       }
  //     }
  //   }
  //   //http://192.168.205.137:8081/IonicDemoService/module001/service005/saveUser

  //   final url =
  //       // 'http://uattrackingapi.azurewebsites.net/api/people_history/insertmany';
  //       url2 + "/api/people_history/insertmany";
  //   var body = jsonEncode(data);
  //   print("BDY >> " + body);
  //   if (body == "[]") {
  //     _start = startInterval;
  //     countDownSave();
  //   } else {
  //     http.post(Uri.encodeFull(url), body: body, headers: {
  //       "Accept": "application/json",
  //       "content-type": "application/json"
  //     }).then((res) {
  //       var result = json.decode(res.body);
  //       print("RES >> $result");
  //       if (result == 0) {
  //         for (var i = 0; i < setList.length; i++) {
  //           // print("AAA 111 >> ${setList[i].id}");
  //           if (setList[i].location == null ||
  //               setList[i].location == "" ||
  //               setList[i].color.toString() == "1") {
  //           } else {
  //             // print("BBB >>>>");
  //             Employee e = Employee(
  //                 int.parse(setList[i].id.toString()),
  //                 setList[i].location,
  //                 setList[i].time,
  //                 setList[i].rid,
  //                 "1",
  //                 setList[i].remark);
  //             dbHelper.update(e);
  //           }
  //         }
  //         // this.snackbarmethod1("Submitted  Successfully.");
  //         refreshList();
  //         setState(() {
  //           _start = startInterval;
  //           countDownSave();
  //         });

  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => TabsPage(
  //                 openTab: 2,
  //               ),
  //             ));
  //       } else {
  //         this.snackbarmethod1("Can not submit");
  //       }
  //     }).catchError((Object error) async {
  //       print("ON ERROR >>");
  //       _start = startInterval;
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("errorLog", "ERROR FROM SQLITE >> " + error);
  //       countDownSave();
  //     });
  //   }
  // }
  // //-->>End for submitting timer

  // _checkAndstartTrack() async {
  //   final result = await Geolocator().isLocationServiceEnabled();
  //   if (result == false) {
  //     snackbarmethod1("Please turn on GPS.");
  //   } else {
  //     GeolocationStatus result1 =
  //         await Geolocator().checkGeolocationPermissionStatus();

  //     print("RESULT >>> " + result1.toString());
  //     if (result1.toString() == "GeolocationStatus.denied") {
  //       //ask permission
  //       final position = await Geolocator()
  //           .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //       // location = "${position.latitude}, ${position.longitude}";
  //       // latt = "${position.latitude}";
  //       // longg = "${position.longitude}";
  //     } else {
  //       final prefs = await SharedPreferences.getInstance();
  //       var chkT = prefs.getString("chk_tracking") ?? "0";
  //       if (chkT == "0") {
  //         //tracking off
  //       } else {
  //         //tracking on
  //         final prefs = await SharedPreferences.getInstance();
  //         int val = prefs.getInt("timer") ?? 0;

  //         if (val == 0) {
  //         } else {
  //           _start = val.toString();
  //           countDownSave();
  //         }
  //       }
  //     }
  //   }
  // }

  // countDownSave() {
  //   print("START >> $_start");
  //   const oneSec = const Duration(seconds: 1);
  //   timer = Timer.periodic(
  //     oneSec,
  //     (Timer t) => setState(
  //       () {
  //         if (_start == 0) {
  //           _getCurrentLocationForTrack();
  //           timer.cancel();
  //         } else {
  //           _start = int.parse(_start.toString()) - 1;
  //           saveTimer();
  //           // print("Sec>>" + _start.toString());
  //         }
  //         print("CD >> " + _start.toString());
  //       },
  //     ),
  //   );
  // }

  // saveTimer() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("timer", _start);
  // }

  // _getCurrentLocationForTrack() async {
  //   //auto check in location

  //   // setState(() async {
  //   //tracking on
  //   try {
  //     final position = await Geolocator()
  //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //     var location = "${position.latitude}, ${position.longitude}";
  //     print("location >>> $location");

  //     // DateTime now = DateTime.now();
  //     // var curDT = new DateFormat.yMd().add_jm().format(now);
  //     var curDT = convertDateTime();

  //     Employee e =
  //         Employee(curUserId, location, curDT, "Checked In", "", "Auto");
  //     dbHelper.save(e);

  //     final prefs = await SharedPreferences.getInstance();
  //     int c = prefs.getInt("saveCount") ?? 0;
  //     final prefs1 = await SharedPreferences.getInstance();
  //     int r = c + 1;
  //     prefs1.setInt("saveCount", r);
  //     setState(() {
  //       refreshList();
  //     });
  //     print("Save --->>>>");
  //     _start = startInterval;
  //     countDownSave();
  //   } on Exception catch (_) {
  //     print('never reached');
  //   }
  //   // });
  // }

// void handleSlideAnimationChanged(bool isOpen) {
//   print("object")
// }
//   void handleSlideIsOpenChanged(bool isOpen) {
//     setState(() {
//       // _fabColor = isOpen ? Colors.green : Colors.blue;
//       showArrow = isOpen;
//       print("1234 >>>>>" + isOpen.toString());
//     });
//   }

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  // snackbarmethod1(name) {
  //   _scaffoldkey.currentState.showSnackBar(new SnackBar(
  //     // content: new Text("Please wait, searching your location"),
  //     content: new Text(name),
  //     backgroundColor: Colors.blue.shade400,
  //     duration: Duration(seconds: 3),
  //   ));
  // }

  _getLastLatLong() async {
    print("GLLL>>");
    var lLat;
    var lLong;

    var allLists = await dbHelper.getEmployees();
    // print("L-leng 11 >> " + allLists.toString());
    // print("L-leng >> " + allLists.length.toString());
    var time;
    // var hr, mi;

    if (allLists.length != 0) {
      for (final list in allLists) {
        if (list.location.toString() == "null" || list.location == "") {
        } else {
          var index = list.location.toString().indexOf(',');
          // var itx = list.location.toString().indexOf('T');
          lLat = list.location.toString().substring(0, index);
          lLong = list.location.toString().substring(index + 1);
          time = list.time.toString().substring(11, list.time.length);
          // hr = list.time.toString().substring(itx + 1, itx + 3);
          // mi = list.time.toString().substring(itx + 4, itx + 6);
        }
      }
      print("Last Time >> " + time.toString());
      print("Last lat/long >> " + lLat.toString() + lLong.toString());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("last-lat", lLat);
      prefs.setString("last-long", lLong);
      prefs.setString("last-time", time);
      // var hr = time.toString().substring(0, 2);
      // var mi = time.toString().substring(3, 5);
      // TimeOfDay now = TimeOfDay.now();
      // int nowInMinutes = now.hour * 60 + now.minute;
      // TimeOfDay testDate =
      //     TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
      // int convToMin = testDate.hour * 60 + testDate.minute;
      // snackbarmethod1(
      //     "LT >> " + nowInMinutes.toString() + "|" + convToMin.toString());
    }
  }

  _getCurrentLocation() async {
    // initState() {}
    //Get last check in location

    // setState(() {});
    // bg.BackgroundGeolocation.getCurrentPosition(
    //         // persist: false, // <-- do not persist this location
    //         // desiredAccuracy: 0, // <-- desire best possible accuracy
    //         // timeout: 30000, // <-- wait 30s before giving up.
    //         // samples: 3 // <-- sample 3 location before selecting best.
    //         )
    //     .then((bg.Location locc) {
    //   // print('[getCurrentPosition] - $location');
    //   print("CUR LOC >> " + locc.coords.latitude.toString());
    //   setState(() {
    //     // curseclat = location.coords.latitude.toString();
    //     // curseclong = location.coords.longitude.toString();
    //     location =
    //         "${locc.coords.latitude.toString()}, ${locc.coords.longitude.toString()}";

    //     print("location >>> $location");
    //     latt = "${locc.coords.latitude}";
    //     longg = "${locc.coords.longitude}";
    //   });
    // }).catchError((dynamic error) async {
    //   // util.Dialog.alert(context, "Sync", error.toString());
    //   print('[sync] ERROR-CL >>: $error');
    // });

    try {
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // final Geolocator geolocator = Geolocator()
      //   ..forceAndroidLocationManager = true;
      // var position = await geolocator.getLastKnownPosition(
      //     desiredAccuracy: LocationAccuracy.best);
      print("location >>> $location");
      location = "${position.latitude}, ${position.longitude}";
      latt = "${position.latitude}";
      longg = "${position.longitude}";

      setState(() {});
      print(_locationMessage);
      print(formattedDate);
    } on Exception catch (_) {
      print('never reached');
      location = "";
    }
  }

  getCardno() async {
    var setList = [];
    setList = await dbHelper.getEmployees();
    setState(() {});
    var data = [];
    for (var i = 0; i < setList.length; i++) {
      var index = setList[i].location.toString().indexOf(',');
      data.add({
        "phoneNo": "${widget.value}",
        "deviceId": deviceId,
        "latitude": setList[i].location.toString().substring(0, index),
        "longitude": setList[i].location.toString().substring(index + 1),
        "time": setList[i].time
      });
    } //http://192.168.205.137:8081/IonicDemoService/module001/service005/saveUser
    //
    final url =
        // 'https://service.mcf.org.mm/tracemyanmar/module001/service005/saveUser';
        // "http://uatsssverify.azurewebsites.net/tracemyanmar/module001/service005/saveUser";
        url2 + "/tracemyanmar/module001/service005/saveUser";
    var body = jsonEncode({"data": data});
    print(body);
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print(result);
      if (result['msgCode'] == "0000") {
        // color = "0";
        _scaffoldkey.currentState.showSnackBar(new SnackBar(
          content: new Text("Submitted Successfully!"),
          backgroundColor: Colors.blue.shade400,
          duration: Duration(seconds: 1),
        ));
      } else {
        this.alertmsg = result['msgDesc'];
        this.snackbarmethod();
      }
    });
  }

  gettime() async {
    var now = new DateTime.now();
    print(now);
    setState(() {});
  }

  _getDeviceId() async {
    String device_id = await DeviceId.getID;
    deviceId = device_id;
    print(deviceId);
  }

  refreshList() async {
    dbHelper = DBHelper();
    isUpdating = false;
    _getDeviceId();
    gettime();
    _getCurrentLocation();
    var setList = [];
    employeesLst = [];
    employeesLst.clear();
    setList = await dbHelper.getEmployees();
    if (setList != []) {
      for (var i = 0; i < setList.length; i++) {
        // // // var getDate = setList[i].time.toString().substring(0, 10);
        // // // var setDate = setList[i + 1].time.toString().substring(0, 10);
        // // // // time for first
        // // // var timestamp1 = setList[i].time.toString();
        // // // var index1 = timestamp1.toString().indexOf('T');
        // // // var hr1 = timestamp1.toString().substring(index1 + 1, index1 + 3);
        // // // var mi1 = timestamp1.toString().substring(index1 + 4, index1 + 6);
        // // // TimeOfDay testDate1 =
        // // //     TimeOfDay(hour: int.parse(hr1), minute: int.parse(mi1));
        // // // int firstTime = testDate1.hour * 60 + testDate1.minute;
        // // // // time for second
        // // // var timestamp2 = setList[i + 1].time.toString();
        // // // var index2 = timestamp2.toString().indexOf('T');
        // // // var hr2 = timestamp2.toString().substring(index2 + 1, index2 + 3);
        // // // var mi2 = timestamp2.toString().substring(index2 + 4, index2 + 6);
        // // // TimeOfDay testDate2 =
        // // //     TimeOfDay(hour: int.parse(hr2), minute: int.parse(mi2));
        // // // int secondTime = testDate2.hour * 60 + testDate2.minute;

        // // // int tt = secondTime - firstTime;
        // // // // print("TIME DIS >>> " + tt.toString());
        // // // if (i == 0) {
        addData(setList[i], "blue");
        // // // } else if (i == (setList.length - 2)) {
        // // //   addData(setList[i], "blue");
        // // // } else if (getDate != setDate) {
        // // //   addData(setList[i + 1], "green");
        // // // } else if (tt > 10) {
        // // //   addData(setList[i + 1], "green");
        // // // } else {
        // // //   addData(setList[i], "brown");
        // // // }

        // if (setList.length == i) {
        // addData(setList[i], "brown");
        // snackbarmethod1("FUKJVLSDJFL ${setList.length} - $i");
        // }

      }
      // employeesLst.add({
      //   "id": setList[i].id.toString(),
      //   "location": setList[i].location.toString(),
      //   "time": setList[i].time.toString(),
      //   "rid": setList[i].rid.toString(),
      //   "color": setList[i].color.toString(),
      //   "remark": setList[i].remark.toString(),
      // "marker": "blue"
      // });
    }

    // print("CHECK IDDD >>> " + employeesLstTest[0]["id"].toString());

    // setState(() {
    //   // var emp = [];
    //   employees = dbHelper.getEmployees();

    //   // employeesLst = dbHelper.getEmployees();
    //   // print("EMP LGH >> " + employeesLst.length.toString());
    //   // print("EMP LOC >> " + employeesLst[0].location.toString());
    //   // for(var i = 0; i < employees.length; i++){

    //   // }

    //   // Future.delayed(const Duration(seconds: 2), () {
    //   //   _isLoading = false;
    //   // });
    // });
    setState(() {});
  }

  addData(setList, color) async {
    setState(() {
      employeesLst.add({
        "id": setList.id.toString(),
        "location": setList.location.toString(),
        "time": setList.time.toString(),
        "rid": setList.rid.toString(),
        "color": setList.color.toString(),
        "remark": setList.remark.toString(),
        "marker": color.toString()
      });
    });
  }

  clearName() {
    controller.text = '';
    setState(() {});
  }

  // // _alertCheckIn() async {
  // //   return showDialog<void>(
  // //     context: context,
  // //     barrierDismissible: false, // user must tap button!
  // //     builder: (BuildContext context) {
  // //       return AlertDialog(
  // //         title: Text('GPS Check In'),
  // //         content: SingleChildScrollView(
  // //           child: ListBody(
  // //             children: <Widget>[
  // //               Padding(
  // //                 padding: const EdgeInsets.fromLTRB(00.0, 0.0, 00.0, 0.0),
  // //                 child: Container(
  // //                     child: TextFormField(
  // //                   readOnly: false,
  // //                   keyboardType: TextInputType.text,
  // //                   controller: chklocNameCtr,
  // //                   style: TextStyle(
  // //                       color: Colors.black, fontWeight: FontWeight.w300),
  // //                   decoration: InputDecoration(
  // //                     // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
  // //                     labelText: "*တည်နေရာ အမည် (Location name)",
  // //                     hasFloatingPlaceholder: true,
  // //                     labelStyle: TextStyle(
  // //                         fontSize: 14, color: Colors.black, height: 0),
  // //                     fillColor: Colors.grey,
  // //                   ),
  // //                 )),
  // //               ),
  // //               // SizedBox(
  // //               //   height: 5,
  // //               // ),
  // //               // Text(
  // //               //employeesLst   "* Required",
  // //               //   style: TextStyle(color: Colors.redAccent),
  // //               // ),
  // //               SizedBox(
  // //                 height: 5,
  // //               ),
  // //               Padding(
  // //                 padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
  // //                 child: Container(
  // //                     child: TextFormField(
  // //                   readOnly: false,
  // //                   keyboardType: TextInputType.multiline,
  // //                   minLines: 1,
  // //                   maxLines: 5,
  // //                   controller: chkremarkCtrl,
  // //                   style: TextStyle(
  // //                       color: Colors.black, fontWeight: FontWeight.w300),
  // //                   decoration: InputDecoration(
  // //                     // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
  // //                     labelText: "မှတ်ချက် (Remark)",
  // //                     hasFloatingPlaceholder: true,
  // //                     labelStyle: TextStyle(
  // //                         fontSize: 14, color: Colors.black, height: 0),
  // //                     fillColor: Colors.grey,
  // //                   ),
  // //                 )),
  // //               ),
  // //             ],
  // //           ),
  // //         ),
  // //         actions: <Widget>[
  // //           FlatButton(
  // //             child: Text(
  // //               'Cancel',
  // //               style: TextStyle(color: Colors.blueAccent),
  // //             ),
  // //             onPressed: () {
  // //               chklocNameCtr.text = "";
  // //               chkremarkCtrl.text = "";
  // //               Navigator.of(context).pop();
  // //             },
  // //           ),
  // //           FlatButton(
  // //             child: Text(
  // //               'Check In',
  // //               style: TextStyle(color: Colors.blueAccent),
  // //             ),
  // //             onPressed: () {
  // //               if (chklocNameCtr.text == null || chklocNameCtr.text == "") {
  // //                 // snackbarmethod1("Fill တည်နေရာ အမည် (Location name)");
  // //               } else {
  // //                 setState(() {
  // //                   DateTime now = DateTime.now();
  // //                   formattedDate = new DateFormat.yMd().add_jm().format(now);
  // //                   righttime = formattedDate;
  // //                   //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
  // //                 });
  // //                 formKey.currentState.save();

  // //                 // } else {
  // //                 print("2222");

  // //                 Employee e = Employee(curUserId, null, righttime,
  // //                     chklocNameCtr.text, color, chkremarkCtrl.text);
  // //                 dbHelper.save(e);

  // //                 _getLastLatLong();
  // //                 setState(() {});
  // //                 // }
  // //                 clearName();
  // //                 refreshList();
  // //                 setState(() {
  // //                   rid = "Checked In";
  // //                 });
  // //                 chklocNameCtr.text = "";
  // //                 chkremarkCtrl.text = "";
  // //                 Navigator.of(context).pop();
  // //               }
  // //             },
  // //           ),
  // //         ],
  // //       );
  // //     },
  // //   );
  // // }

  validate() async {
    print("CurUserId >>" + remark.toString());
    final prefs = await SharedPreferences.getInstance();
    var gtime = prefs.getString("last-time") ?? "";
    int convToMin = 0;
    if (gtime != "") {
      var hr = gtime.toString().substring(0, 2);
      var mi = gtime.toString().substring(3, 5);
      TimeOfDay getTime = TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
      convToMin = getTime.hour * 60 + getTime.minute;
    }

    // DateTime now1 = DateTime.now();
    // var ddd = new DateFormat("hh:mm:ss").format(now1);
    TimeOfDay now = TimeOfDay.now();
    int nowTime = now.hour * 60 + now.minute;

    if (nowTime == convToMin) {
      // snackbarmethod1("Close Interval!");
    } else {
      prefs.setString("last-time", gtime);
      // var gtime = prefs.getString("last-time", );

      // try {
      // if (location == "") {
      //   final position = await Geolocator()
      //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      //   // final Geolocator geolocator = Geolocator()
      //   //   ..forceAndroidLocationManager = true;
      //   // var position = await geolocator.getLastKnownPosition(
      //   //     desiredAccuracy: LocationAccuracy.best);
      //   print("location >>> $location");
      //   location = "${position.latitude}, ${position.longitude}";
      //   latt = "${position.latitude}";
      //   longg = "${position.longitude}";
      // }
      // final result1 = await Geolocator().checkGeolocationPermissionStatus();

      final result = await Geolocator().isLocationServiceEnabled();
      if (result == false) {
        snackbarmethod1("Please turn on GPS.");
      } else {
        GeolocationStatus result1 =
            await Geolocator().checkGeolocationPermissionStatus();
        print("RESULT >>> " + result1.toString());
        if (result1.toString() == "GeolocationStatus.denied") {
          //ask permission
          final position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          location = "${position.latitude}, ${position.longitude}";
          latt = "${position.latitude}";
          longg = "${position.longitude}";
        } else {
          if (location == null) {
            // this.snackbarmethod1("Location not accessible.");
            // _alertCheckIn();
            setState(() {
              // DateTime now = DateTime.now();
              // formattedDate = new DateFormat.yMd().add_jm().format(now);
              formattedDate = convertDateTime();
              righttime = formattedDate;
              //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
            });
            formKey.currentState.save();

            // } else {
            print("2222 >> " + curUserId.toString());

            Employee e = Employee(
                curUserId, null, righttime, "", "0", chkremarkCtrl.text);
            dbHelper.save(e);

            _getLastLatLong();
            setState(() {});
            // }
            clearName();
            refreshList();
            setState(() {
              rid = "Checked In";
            });
          } else if (formKey.currentState.validate()) {
            // if (location == "") {
            //   final position = await Geolocator()
            //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            //   // final Geolocator geolocator = Geolocator()
            //   //   ..forceAndroidLocationManager = true;
            //   // var position = await geolocator.getLastKnownPosition(
            //   //     desiredAccuracy: LocationAccuracy.best);
            //   print("location >>> $location");
            //   location = "${position.latitude}, ${position.longitude}";
            //   latt = "${position.latitude}";
            //   longg = "${position.longitude}";
            // }

            setState(() {
              // DateTime now = DateTime.now();
              // formattedDate = new DateFormat.yMd().add_jm().format(now);
              formattedDate = convertDateTime();
              righttime = formattedDate;
              //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
            });
            formKey.currentState.save();
            if (isUpdating) {
              print("11111111");
              // if (location == null) {
              // Employee e =
              //     Employee(curUserId, "L, L", righttime, rid, color, remark);
              // dbHelper.update(e);

              // } else {
              // final prefs = await SharedPreferences.getInstance();
              // var lastLat = prefs.getString("last-lat") ?? "";
              // var lastLong = prefs.getString("last-long") ?? "";

              // if (lastLat == '' ||
              //     lastLat == null ||
              //     lastLong == "" ||
              //     lastLong == null) {
              //   print("LLL>>");
              //   // snackbarmethod1("You check in here last time.");
              //   Employee e =
              //       Employee(curUserId, location, righttime, rid, color, remark);
              //   dbHelper.update(e);
              //   // Employee e = Employee(curUserId, location, righttime, rid, "0", "");
              //   // dbHelper.save(e);
              // } else {
              //   print("LLL1111>>");
              //   double di = calDisc(lastLat, lastLong, latt, longg);
              //   if (di > locDistance) {
              Employee e =
                  Employee(curUserId, location, righttime, rid, color, remark);
              dbHelper.update(e);

              //   prefs.setString("last-lat", latt);
              //   prefs.setString("last-long", longg);
              //   // syncDataWithDis += "$count" + "{" + lat + ", " + long + "}";
              //   // lastLat = lat;
              //   // lastLong = long;
              // }
              // }

              // }

              setState(() {
                isUpdating = false;
              });
            } else {
              print("22221234 >> " + curUserId.toString());
              // if (location == null) {
              //   Employee e = Employee(curUserId, "L, L", righttime, rid, color, "");
              //   dbHelper.save(e);
              // } else {
              // final prefs = await SharedPreferences.getInstance();
              // var lastLat = prefs.getString("last-lat") ?? "";
              // var lastLong = prefs.getString("last-long") ?? "";

              // if (lastLat == '' ||
              //     lastLat == null ||
              //     lastLong == "" ||
              //     lastLong == null) {
              //   print("LLL>>");
              //   // snackbarmethod1("You check in here last time.");
              //   Employee e =
              //       Employee(curUserId, location, righttime, rid, "0", "");
              //   dbHelper.save(e);
              // } else {
              //   print("LLL1111>>");
              //   double di = calDisc(lastLat, lastLong, latt, longg);
              //   if (di > locDistance) {
              Employee e =
                  Employee(curUserId, location, righttime, rid, "0", "");
              dbHelper.save(e);

              //     prefs.setString("last-lat", latt);
              //     prefs.setString("last-long", longg);
              //     // syncDataWithDis += "$count" + "{" + lat + ", " + long + "}";
              //     // lastLat = lat;
              //     // lastLong = long;
              //   }
              // }

              // }

              // color = "1";
              // this.alertmsg = "Check In Successfully!";
              // this.snackbarmethod();
              _getLastLatLong();
              setState(() {});
            }
            clearName();
            refreshList();
            setState(() {
              rid = "Checked In";
            });
          }
        }
      }
    }
    // // setState(() {});
    // } on Exception catch (_) {
    //   print('never reached');
    // }
  }

  //-->> Old
  // form() {
  //   return Form(
  //     key: formKey,
  //     child: Padding(
  //       padding: EdgeInsets.all(15.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           // TextFormField(
  //           //   controller: controller,
  //           //   keyboardType: TextInputType.text,
  //           //   decoration: InputDecoration(labelText: 'Name'),
  //           //   validator: (val) => val.length == 0 ? 'Enter Name' : null,
  //           //   onSaved: (val) => name = val,
  //           // ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               RaisedButton(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(5.0),
  //                 ),
  //                 color: Colors.blue,
  //                 onPressed: () async {
  //                   _getCurrentLocation();
  //                   validate();
  //                   setState(() {});
  //                 },
  //                 child: Text(
  //                   isUpdating ? 'UPDATE' : 'Check In',
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.w300),
  //                 ),
  //               ),
  //               FlatButton(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(5.0),
  //                 ),
  //                 color: Colors.blue,
  //                 onPressed: () {
  //                   setState(() {
  //                     scanBarcodeNormal();
  //                   });
  //                 },
  //                 child: Text(
  //                   'Scan QR',
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.w300),
  //                 ),
  //               ),
  //               // GestureDetector(
  //               //   onTap: () {
  //               //     setState(() {
  //               //       scanBarcodeNormal();
  //               //     });
  //               //   },
  //               //   child: Image.asset(
  //               //     "assets/scan.png",
  //               //     width: 40.0,
  //               //     height: 40.0,
  //               //     color: Colors.blue,
  //               //   ),
  //               // )
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 13.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            // _getCurrentLocation();
                            validate();
                            setState(() {});
                          },
                          child: Text(
                            isUpdating
                                ? 'UPDATE'
                                : checklang == "Eng" ? textEng[0] : textMyan[0],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   width: 20.0,
                // ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.47,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 13.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          // scanBarcodeNormal();
                        });
                      },
                      child: Text(
                        checklang == "Eng" ? textEng[1] : textMyan[1],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       scanBarcodeNormal();
                //     });
                //   },
                //   child: Imaassetge.asset(
                //     "assets/scan.png",
                //     width: 40.0,
                //     height: 40.0,
                //     color: Colors.blue,
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  //--->> Old
  // SingleChildScrollView dataTable(List<Employee> employees) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: DataTable(
  //       columnSpacing: 65,
  //       dataRowHeight: 90,
  //       headingRowHeight: 0,
  //       sortAscending: true,
  //       columns: [
  //         DataColumn(
  //             label: Text(
  //           '',
  //           style: TextStyle(color: Colors.black87, fontSize: 14),
  //         )),
  //         // DataColumn(
  //         //   label: Text('Device ID')
  //         // ),

  //         // DataColumn(
  //         //   label: Text(
  //         //     'Location',
  //         //     style: TextStyle(color: Colors.black87, fontSize: 14),
  //         //   ),
  //         // ),
  //         // DataColumn(
  //         //   label: Text(
  //         //     'Time',
  //         //     style: TextStyle(color: Colors.black87, fontSize: 14),
  //         //   ),
  //         // ),
  //         DataColumn(
  //           label: Text(
  //             '',
  //             style: TextStyle(color: Colors.black87, fontSize: 14),
  //           ),
  //         ),
  //         DataColumn(
  //           label: Text(
  //             '',
  //             style: TextStyle(color: Colors.black87, fontSize: 14),
  //           ),
  //         ),
  //       ],
  //       rows: employees
  //           .map(
  //             (employee) => DataRow(cells: [
  //               DataCell(
  //                   Icon(Icons.location_on,
  //                       size: 30, color: Colors.green.shade400), onTap: () {
  //                 Navigator.push(context,
  //                     MaterialPageRoute(builder: (context) => HomePage()));
  //               }
  //                   // Text(employee.location.toString(),
  //                   //     style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15)
  //                   //     // ,style: employee.color=="1"? TextStyle(fontWeight: FontWeight.w400,color: Colors.red) :TextStyle(fontWeight: FontWeight.w400,color: Colors.amber)
  //                   //     ),
  //                   ),
  //               // DataCell(
  //               //   Text(deviceId),
  //               // ),
  //               // DataCell(
  //               //   Text(employee.location.toString(),
  //               //       style: TextStyle(fontWeight: FontWeight.w400)
  //               //       // ,style: employee.color=="1"? TextStyle(fontWeight: FontWeight.w400,color: Colors.red) :TextStyle(fontWeight: FontWeight.w400,color: Colors.amber)
  //               //       ),
  //               // ),
  //               // DataCell(
  //               //   Text(employee.name), onTap: (){
  //               //     setState(() {
  //               //       isUpdating = true;
  //               //       curUserId = employee.id;
  //               //     });
  //               //     controller.text = employee.name;
  //               //   }
  //               // ),
  //               // DataCell(Text(employee.time.toString(),
  //               //     style: TextStyle(fontWeight: FontWeight.w400))),
  //               DataCell(Container(
  //                   width: 150,
  //                   child: Text(
  //                     employee.rid.toString() == "null"
  //                         ? "Checked In"
  //                         : employee.rid.toString() +
  //                             '\n' +
  //                             employee.time.toString(),
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
  //                   ))),
  //               // overflow: TextOverflow.ellipsis
  //               DataCell(IconButton(
  //                   icon: Icon(
  //                     Icons.delete,
  //                     color: Colors.red.shade300,
  //                   ),
  //                   onPressed: () {
  //                     dbHelper.delete(employee.id);
  //                     refreshList();
  //                   })),
  //             ]),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    var hr = parts[0].padLeft(2, '0');
    var hours;

    if (hr == "24") {
      hours = "00";
    } else if (hr == "25") {
      hours = "01";
    } else if (hr == "26") {
      hours = "02";
    } else if (hr == "27") {
      hours = "03";
    } else if (hr == "28") {
      hours = "04";
    } else if (hr == "29") {
      hours = "05";
    } else if (hr == "30") {
      hours = "06";
    } else {
      hours = hr;
    }
    return '${hours}:${parts[1].padLeft(2, '0')}:00';
    // return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:00';
  }

  formatTimeOfDay(year, month, day, hr, mi) {
    final dt = DateTime(year, month, day, hr, mi);

    if (month.toString().length == 1) {
      month = "0" + month.toString();
    }
    // var dy = DateFormat.d().format(now);
    if (day.toString().length == 1) {
      day = "0" + day.toString();
    }

    final format = DateFormat.yMd().add_jm().format(dt);
    var time = format.toString().substring(10, format.length);

    var rt = year.toString() +
        "-" +
        month.toString() +
        "-" +
        day.toString() +
        " " +
        time.toString();
    return rt;
  }

  _syncList(String check) async {
    final prefs = await SharedPreferences.getInstance();
    var locDistance = prefs.getInt("meter") ?? 0;
    int count = await bg.BackgroundGeolocation.count;
    if (count == 0) {
      // util.Dialog.alert(context, "Sync", "Database is empty");
      // return;
      if (check == "1") {
        // _syncstart = syncInterval;
        // countDownSaveForSync();
      } else {
        // snackbarmethod1("No movement");
      }
    } else {
      // // _getLastLatLong() async {
      // var lLat;
      // var lLong;

      // var allLists = await dbHelper.getEmployees();
      // // print("L-leng 11 >> " + allLists.toString());
      // // print("L-leng >> " + allLists.length.toString());
      // if (allLists.length != 0) {
      //   for (final list in allLists) {
      //     if (list.location.toString() == "null" || list.location == "") {
      //     } else {
      //       var index = list.location.toString().indexOf(',');
      //       lLat = list.location.toString().substring(0, index);
      //       lLong = list.location.toString().substring(index + 1);

      bg.BackgroundGeolocation.sync().then((List records) async {
       print('[sync] success >> ' + records.toString());
        // var samLoc = '';
        final prefs = await SharedPreferences.getInstance();
        var count = 0;
        var convGetToMin = 0;
        var di = prefs.getInt("datainterval") ?? 60;
        var datainterval = int.parse(di.toString()) / 60;
        for (var i = 0; i < records.length; i++) {
          print("List loop >> " + records[i]["coords"]["latitude"].toString());
          var lat = records[i]["coords"]["latitude"].toString();
          var long = records[i]["coords"]["longitude"].toString();
          var loc = lat + ", " + long;
          var timestamp = records[i]["timestamp"].toString();

          var index = timestamp.toString().indexOf('T');
          // // var yr = timestamp.toString().substring(0, 4);
          // // var mn = timestamp.toString().substring(5, 7);
          // // var dy = timestamp.toString().substring(8, 10);
          var hr = timestamp.toString().substring(index + 1, index + 3);
          var mi = timestamp.toString().substring(index + 4, index + 6);
          // print("AT >> " + yr.toString() + mn.toString() + dy.toString());
          TimeOfDay testDate =
              TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
          int testDateInMinutes = testDate.hour * 60 + testDate.minute;
          // print("TD >> " + testDateInMinutes.toString());
          int ct = testDateInMinutes + 390;
          var mct = durationToString(ct);
          // print("MyCurTime >> " + mct);
          // // // var hrr = mct.substring(0, 2);
          // // // var mii = mct.substring(3, 5);

          // var cvtDate = formatTimeOfDay(int.parse(yr), int.parse(mn),
          //     int.parse(dy), int.parse(hrr), int.parse(mii));
          DateTime now = DateTime.now();
          var yr = DateFormat.y().format(now);
          var mn = DateFormat.M().format(now);
          var dy = DateFormat.d().format(now);
          if (mn.toString().length == 1) {
            mn = "0" + mn.toString();
          }
          // var dy = DateFormat.d().format(now);
          if (dy.toString().length == 1) {
            dy = "0" + dy.toString();
          }

          var cvtDate = yr + "-" + mn + "-" + dy + "T" + mct;
          // print("AA >> " + cvtDate.toString());

          var chklat =
              records[i]["coords"]["latitude"].toString().substring(0, 7);
          var chklong =
              records[i]["coords"]["longitude"].toString().substring(0, 7);
          var chkLoc = chklat + ", " + chklong;
          print("chkLoc >> " + chkLoc);

          var lastLat = prefs.getString("last-lat") ?? "";
          var lastLong = prefs.getString("last-long") ?? "";

          // final prefs = await SharedPreferences.getInstance();
          // var gtime = prefs.getString("last-time") ?? "";
          // convGetToMin = 0;
          // if (gtime != "") {
          //   var ghr = gtime.toString().substring(0, 2);
          //   var gmi = gtime.toString().substring(3, 5);
          //   TimeOfDay getTime =
          //       TimeOfDay(hour: int.parse(ghr), minute: int.parse(gmi));
          //   convGetToMin = getTime.hour * 60 + getTime.minute;
          // }

          // TimeOfDay nowTime =
          //     TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
          // int convNowToMin = nowTime.hour * 60 + nowTime.minute;
          // snackbarmethod1("COMPARE TIME >> " +
          //     ct.toString() +
          //     "||" +
          //     convGetToMin.toString());
          // var ctime = convGetToMin + 3;
          // if (ct < ctime) {
          //   // if (ct == convGetToMin) {
          //   // snackbarmethod1("Close Interval!");
          //   if (i == 0) {
          //     convGetToMin = ct;
          //   }
          // } else {
          // if (ct < (convGetToMin + datainterval)) {
          // snackbarmethod1("Close Interval!");
          if (i == 0) {
            convGetToMin = ct;
            // }
          } else {
            // prefs.setString("last-time", gtime);
            if (ct == (convGetToMin + datainterval)) {
              convGetToMin = ct;
              // snackbarmethod1(
              //     "Compare time >> " + ct.toString() + "::" + ctime.toString());

              if (lastLat == '' ||
                  lastLat == null ||
                  lastLong == "" ||
                  lastLong == null) {
                Employee e =
                    Employee(null, loc, cvtDate, "Checked In", "0", "Auto");
                dbHelper.save(e);
                count += 1;
                prefs.setString("last-lat", lat);
                prefs.setString("last-long", long);
              } else {
                double di = calDisc(lastLat, lastLong, lat, long);
                if (di > locDistance) {
                  Employee e =
                      Employee(null, loc, cvtDate, "Checked In", "0", "Auto");
                  dbHelper.save(e);
                  count += 1;
                  prefs.setString("last-lat", lat);
                  prefs.setString("last-long", long);
                  // syncDataWithDis += "$count" + "{" + lat + ", " + long + "}";
                  lastLat = lat;
                  lastLong = long;
                }
              }
            }
          }
          // if (samLoc == chkLoc) {
          // } else {
          //   Employee e =
          //       Employee(curUserId, loc, cvtDate, "Checked In", "0", "Auto");
          //   dbHelper.save(e);
          //   samLoc = chkLoc;
          //   count += 1;
          // }
        }
        if (count == 0) {
          // snackbarmethod1("No movement");
        } else {
          snackbarmethod1(count.toString() + " location(s)");
        }
        if (check == "1") {
          // _syncstart = syncInterval;
          // countDownSaveForSync();
        }
        refreshList();

        setState(() {});
        // bg.BackgroundGeolocation.playSound(
        //     util.Dialog.getSoundId("MESSAGE_SENT"));
      }).catchError((dynamic error) async {
        // util.Dialog.alert(context, "Sync", error.toString());
        print('[sync] ERROR: $error');
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", "ERROR FROM SQLITE >> " + error);
      });
    }
    //     }
    //   }
    // }
  }

  _onRefresh() async {
    // monitor network fetch
    // isLoading = true;

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    print("REFRESH MESSAGE LIST > ");

    // msgLists = List.generate(0, (i) => "Item");
    // await Future.delayed(Duration(milliseconds: 1000));
    // var date = convertDateTime();
    // print("Date Format Test >> " + date.toString());
    _syncList("0");
    setState(() {
      refreshList();
    });

    _refreshController.refreshCompleted();
    // _startBG();
    // setState(() {});
    // _listKey.currentState.initState();
  }

  Widget buildItem(int i, employees) {
    return Column(
      children: <Widget>[
        Container(
          child: Slidable(
            key: Key(employees[i]["id"].toString()),
            controller: slidableController,
            actionPane: SlidableScrollActionPane(),
            // SlidableStrechActionPane
            // SlidableDrawerActionPane
            // SlidableScrollActionPane
            // SlidableBehindActionPane
            // actionExtentRatio: 0.25,
            actionExtentRatio: 0.17,
            child: Container(
              color: Colors.white,
              child: new ListTile(
                onTap: () async {
                  print("Edit >> " + employees[i]["location"].toString());
                  // curUserId, location, righttime, rid, color, remark
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditCheckIn(
                                id: employees[i]["id"].toString(),
                                location: employees[i]["location"].toString(),
                                time: employees[i]["time"].toString(),
                                ride: employees[i]["rid"].toString(),
                                color: employees[i]["color"].toString(),
                                remark: employees[i]["remark"].toString(),
                              )));
                  // print("res>>" + res.toString());
                  if (res == "success") {
                    refreshList();
                  }
                },
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black26,
                ),
                leading: GestureDetector(
                  onTap: () {
                    // print("AAA");
                    // print(
                    //     "LIST >> " + employees[i].location.toString());
                    if (employees[i]["location"] == "" ||
                        employees[i]["location"] == null) {
                      snackbarmethod1("You're in default location");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleMarker(
                                    id: employees[i]["id"].toString(),
                                    location:
                                        employees[i]["location"].toString(),
                                    time: employees[i]["time"].toString(),
                                    ride: employees[i]["rid"].toString(),
                                  )));
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => GoogleMapPage()));
                  },
                  child: new Container(
                    child: Icon(Icons.location_on,
                        size: 30,
                        color: (employees[i]["location"] == "" ||
                                employees[i]["location"] == null)
                            ? Colors.grey
                            : employees[i]["marker"] == "blue"
                                ? Colors.blue
                                : employees[i]["marker"] == "green"
                                    ? Colors.blue[800]
                                    : employees[i]["marker"] == "brown"
                                        ? Colors.brown
                                        : Colors.grey),
                    // Icon(Icons.location_on),
                  ),
                ),
                // title: employees[i]["rid"].toString() == "null"
                //     ? Container()
                //     : employees[i]["rid"].toString() == "Checked In"
                //         ? Text(
                //             employees[i].location.toString(),
                //             style: TextStyle(
                //               fontFamily: "Pyidaungsu",
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15.0,
                //             ),
                //           )
                //         : Text(
                //             employees[i]["rid"].toString(),
                //             style: TextStyle(
                //               fontFamily: "Pyidaungsu",
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15.0,
                //             ),
                //           ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    employees[i]["rid"].toString() == "null"
                        ? Text(
                            // employees[i].location.toString(),
                            lan == "Zg"
                                ? Rabbit.uni2zg(
                                    employees[i]["location"].toString())
                                : employees[i]["location"].toString(),
                            style: TextStyle(
                              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                              color: employees[i]["color"].toString() == "0"
                                  ? Colors.blue
                                  : Colors.black,
                              fontWeight:
                                  employees[i]["color"].toString() == "0"
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 15.0,
                            ),
                          )
                        : employees[i]["rid"].toString() == "Checked In"
                            ? Text(
                                // employees[i].location.toString(),
                                lan == "Zg"
                                    ? Rabbit.uni2zg(
                                        employees[i]["location"].toString())
                                    : employees[i]["location"].toString(),
                                style: TextStyle(
                                  fontFamily:
                                      lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                  color: employees[i]["color"].toString() == "0"
                                      ? Colors.blue
                                      : Colors.black,
                                  fontWeight:
                                      employees[i]["color"].toString() == "0"
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: 15.0,
                                ),
                              )
                            : Text(
                                // employees[i]["rid"].toString(),
                                lan == "Zg"
                                    ? Rabbit.uni2zg(
                                        employees[i]["rid"].toString())
                                    : employees[i]["rid"].toString(),
                                style: TextStyle(
                                  fontFamily:
                                      lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                  color: employees[i]["color"].toString() == "0"
                                      ? Colors.blue
                                      : Colors.black,
                                  fontWeight:
                                      employees[i]["color"].toString() == "0"
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: 15.0,
                                ),
                              ),
                    // employees[i]["rid"].toString() == "Checked In"
                    //     ? Container()
                    //     : Row(
                    //         children: <Widget>[
                    //           Text(
                    //             employees[i].location.toString(),
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //               fontFamily: "Pyidaungsu",
                    //               // fontWeight: FontWeight.bold,
                    //               fontSize: 15.0,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          employees[i]["time"].toString().replaceAll("T", " "),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    (employees[i]["remark"] == "" ||
                            employees[i]["remark"] == null)
                        ? Container()
                        : Row(
                            children: <Widget>[
                              Text(
                                // employees[i]["remark"].toString(),
                                (employees[i]["remark"]
                                            .toString()
                                            .startsWith("[") &&
                                        employees[i]["remark"]
                                            .toString()
                                            .endsWith("]"))
                                    ? "Report"
                                    : lan == "Zg"
                                        ? Rabbit.uni2zg(
                                            employees[i]["remark"].toString())
                                        : employees[i]["remark"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily:
                                      lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 5.0,
                    ),
                    // employees[i]["rid"].toString() == "null"
                    //     ? Container()
                    //     : Text(
                    //         // employees[i]["time"],
                    //         employees[i]["time"].toString(),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    // SizedBox(width: 5,),
                  ],
                ),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                // caption: 'Delete',
                iconWidget: Container(
                  // color: Colors.cusRed,
                  padding: EdgeInsets.all(8.0),

                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    color: Colors.redAccent,
                    borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: new Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                color: Colors.white,
                // icon: Icons.delete,
                onTap: () {
                  // print("Delete>>" + employees[i].id.toString());
                  dbHelper.delete(int.parse(employees[i]["id"]));
                  refreshList();
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  dataTable() {
    if (employeesLst.length != 0) {
      return Expanded(
          child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              // header: WaterDropHeader(),
              child: ListView.builder(
                  itemCount: employeesLst.length,
                  itemBuilder: (context, i) {
                    return buildItem(i, employeesLst.reversed.toList());
                  })));
    } else {
      // print("EMP LENGTH >> " + employees.length.toString());
      // print("EMP LOC >> " + employees[0].location.toString());
      // Future.delayed(const Duration(milliseconds: 2000), () {}
      return Expanded(
          child: Center(
              child: Container(
                  child: Text(
        "No Data Found",
        style: TextStyle(
            color: Colors.black26, fontSize: 18.0, fontWeight: FontWeight.bold),
      ))));
    }
    // return Container(
    //   child: Text(employees[i]["rid"].toString()),
    // );
    // });
  }

  // list() {
  //   return Expanded(child: dataTable()
  //       // child: FutureBuilder(
  //       //   future: employees,
  //       //   builder: (context, snapshot) {
  //       //     if (snapshot.hasData) {
  //       //       // _isLoading = false;
  //       //       return dataTable(snapshot.data);
  //       //     }
  //       //     // print("EMP >> $employees");
  //       //     // if (employees == null || employees == []) {
  //       //     //   return Center(child: Text("No Data Found"));
  //       //     // } else {
  //       //     //   return Container(
  //       //     //     child: Text("dflkj"),
  //       //     //   );
  //       //     // }
  //       //     if (snapshot.data == null || snapshot.data.length == 0) {
  //       //       // return Center(child: Text("No Data Found"));
  //       //       return Container();
  //       //     }
  //       //     return CircularProgressIndicator();
  //       //   },
  //       // ),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        key: _scaffoldkey,
        // // // drawer: Drawerr(),
        // // // appBar: AppBar(
        // // //   backgroundColor: Colors.blue,
        // // //   title: Text(
        // // //     'Saw Saw Shar',
        // // //     style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
        // // //   ),
        // // //   centerTitle: true,
        // // //   actions: <Widget>[
        // // //     PopupMenuButton<int>(
        // // //       itemBuilder: (context) => [
        // // //         PopupMenuItem(
        // // //           value: 1,
        // // //           child:
        // // //               // Column(
        // // //               //   mainAxisAlignment: MainAxisAlignment.start,
        // // //               //   crossAxisAlignment: CrossAxisAlignment.start,
        // // //               //   children: <Widget>[
        // // //               Text(
        // // //             checklang == "Eng"
        // // //                 ? textEng[2] + " (Submit)"
        // // //                 : textMyan[2] + " (Submit)",
        // // //             style: TextStyle(
        // // //                 fontWeight: FontWeight.w400, color: Colors.black),
        // // //           ),
        // // //           //   Text(
        // // //           //     " (Submit)",
        // // //           //     style: TextStyle(
        // // //           //         fontWeight: FontWeight.w400,
        // // //           //         color: Colors.black),
        // // //           //   ),
        // // //           // ],
        // // //           // )
        // // //         ),
        // // //         PopupMenuItem(
        // // //           value: 2,
        // // //           child:
        // // //               // Column(
        // // //               //   mainAxisAlignment: MainAxisAlignment.start,
        // // //               //   crossAxisAlignment: CrossAxisAlignment.start,
        // // //               //   children: <Widget>[
        // // //               Text(
        // // //                   checklang == "Eng"
        // // //                       ? textEng[3] + " (Version)"
        // // //                       : textMyan[3] + " (Version)",
        // // //                   style: TextStyle(
        // // //                       fontWeight: FontWeight.w400,
        // // //                       color: Colors.black)),
        // // //           //     Text(" (Version)",
        // // //           //         style: TextStyle(
        // // //           //             fontWeight: FontWeight.w400,
        // // //           //             color: Colors.black)),
        // // //           //   ],
        // // //           // ),
        // // //         ),
        // // //       ],
        // // //       // initialValue: 2,
        // // //       onCanceled: () {
        // // //         print("You have canceled the menu.");
        // // //       },
        // // //       onSelected: (value) {
        // // //         print("value:$value");
        // // //         if (value == 1) {
        // // //           setState(() {
        // // //             isUpdating = false;
        // // //             setState(() {
        // // //               getCardno();
        // // //             });
        // // //           });
        // // //         }
        // // //         if (value == 2) {
        // // //           setState(() {
        // // //             _openURL();
        // // //           });
        // // //         }
        // // //       },
        // // //       // icon: Icon(Icons.list),
        // // //     ),
        // // //   ],
        // // // ),
        body:
            // _isLoading
            //     ? Container()
            Container(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              // form(),
              Container(),
              // list(),
              dataTable(),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[form()],
      ),
    );
  }
}
