import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:TraceMyanmar/version_history.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;
// import 'dart:convert';

// JsonEncoder encoder = new JsonEncoder.withIndent("     ");

class BackgroundTracking extends StatefulWidget {
  @override
  _BackgroundTrackingState createState() => _BackgroundTrackingState();
}

class _BackgroundTrackingState extends State<BackgroundTracking> {
  String checklang;
  var dbHelper;
  String deviceId;
  String location = "";
  String latt = "";
  String longg = "";
  List textMyan = ["GPS Check In", "QR Check In"];
  List textEng = ["GPS Check In", "QR Check In"];
  String righttime;
  final formKey = new GlobalKey<FormState>();
  int curUserId;
  String rid;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool trackingCheck = false;
  // Timer timer;
  // Timer timer1;

  // bool _trackStatus;
  // bool _isMoving;
  // String _content;

  int saveCount = 0;

  List trackingArray = [];
  List testArray = [];
  var _start;
  @override
  void initState() {
    super.initState();
    chkTracking();

    // bg.BackgroundGeolocation.onLocation(_onLocation);
    // // bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    // // bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    // bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    // // bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

    // // 2.  Configure the plugin
    // bg.BackgroundGeolocation.ready(bg.Config(
    //         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    //         distanceFilter: 10.0,
    //         stopOnTerminate: false,
    //         startOnBoot: true,
    //         debug: true,
    //         logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    //         reset: true))
    //     .then((bg.State state) {
    //   setState(() {
    //     // trackingCheck = state.enabled;
    //     // _isMoving = state.isMoving;
    //   });
    // });

//   CountdownTimer(Duration(seconds: 5), Duration(seconds: 1)).listen((data){
// })..onData((data){
//   print('data $data');
// })..onDone((){
//   print('onDone.........');
// });

    // const mins = const Duration(seconds: 15);
    // timer = Timer.periodic(
    //   mins,
    //   (Timer t) => setState(
    //     () {
    //       print("TTT >> " + t.toString());
    //       //   _getCurrentLocationForTrack();
    //     },
    //   ),
    // );

    // saveRef();
    checkLanguage();
    dbHelper = DBHelper();
    // isUpdating = false;
    // refreshList();
    _getDeviceId();
    gettime();
    _getLastLatLong();
    _getCurrentLocation();
    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

  _checkAndstartTrack() async {
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
    }
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
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      var location = "${position.latitude}, ${position.longitude}";
      print("location >>> $location");

      DateTime now = DateTime.now();
      var curDT = new DateFormat.yMd().add_jm().format(now);

      Employee e = Employee(curUserId, location, curDT, "Checked In", "", "Auto");
      dbHelper.save(e);

      final prefs = await SharedPreferences.getInstance();
      int c = prefs.getInt("saveCount") ?? 0;
      final prefs1 = await SharedPreferences.getInstance();
      int r = c + 1;
      prefs1.setInt("saveCount", r);
      setState(() {
        saveCount = r;
      });
      print("Save --->>>>");
      _start = startInterval;
      countDownSave();
    } on Exception catch (_) {
      print('never reached');
    }
    // });
  }

  chkTracking() async {
    final prefs = await SharedPreferences.getInstance();
    var chkT = prefs.getString("chk_tracking") ?? "0";

    if (chkT == "0" || chkT == "true") {
      setState(() {
        trackingCheck = true;
        saveCount = prefs.getInt("saveCount") ?? 0;
        // final prefs = await SharedPreferences.getInstance();
        prefs.setString("chk_tracking", "true");
        prefs.setInt("timer", startInterval);
        _start = startInterval;
        // countDownSave();
        _checkAndstartTrack();
      });
      // _isMoving = false;
      // _content = '';
    } else {
      setState(() {
        trackingCheck = false;
      });
    }
  }

  // int locCount = 0;
  // void _onLocation(bg.Location location) {
  //   locCount = locCount + 1;
  //   print('[location] >>>> $locCount - $location');
  //   // String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
  //   setState(() {
  //     _content = encoder.convert(location.toMap());

  //     trackingArray.add(_content);
  //     // _odometer = odometerKM;
  //   });
  // }

  // void _onProviderChange(bg.ProviderChangeEvent event) {
  //   // print('PRO CHG EVE >>> $event');
  //   setState(() {
  //     _content = encoder.convert(event.toMap());
  //     // trackingArray.add(_content);
  //   });
  // }

  _getLastLatLong() async {
    var lLat;
    var lLong;

    var allLists = await dbHelper.getEmployees();
    // print("L-leng 11 >> " + allLists.toString());
    // print("L-leng >> " + allLists.length.toString());
    if (allLists.length != 0) {
      for (final list in allLists) {
        if (list.location.toString() == "null" || list.location == "") {
        } else {
          var index = list.location.toString().indexOf(',');
          lLat = list.location.toString().substring(0, index);
          lLong = list.location.toString().substring(index + 1);
        }
      }
      print("Last lat/long >> " + lLat.toString() + lLong.toString());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("last-lat", lLat);
      prefs.setString("last-long", lLong);
    }
  }

  _getCurrentLocation() async {
    initState() {}
    //Get last check in location

    setState(() {});
    try {
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // final Geolocator geolocator = Geolocator()
      //   ..forceAndroidLocationManager = true;
      // var position = await geolocator.getLastKnownPosition(
      //     desiredAccuracy: LocationAccuracy.best);
      // print("location >>> $location");
      location = "${position.latitude}, ${position.longitude}";
      print("location >>> $location");
      latt = "${position.latitude}";
      longg = "${position.longitude}";

      // DateTime now = DateTime.now();
      // var curDT = new DateFormat.yMd().add_jm().format(now);
      // var param = [
      //   {
      //     "datetime": curDT,
      //     "lat": curLat,
      //     "long": curLong,
      //     "location": location
      //   }
      // ];
      // testArray.add(param);

      setState(() {});
    } on Exception catch (_) {
      print('never reached');
      location = "";
    }
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  _getDeviceId() async {
    deviceId = await DeviceId.getID;
    print(deviceId);
  }

  gettime() async {
    var now = new DateTime.now();
    print(now);
    setState(() {});
  }

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

  validate() async {
    // print("CurUserId >>" + remark.toString());

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
            DateTime now = DateTime.now();
            righttime = new DateFormat.yMd().add_jm().format(now);

            //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
          });
          formKey.currentState.save();

          // } else {
          print("2222");

          Employee e = Employee(curUserId, null, righttime, "", "", "");
          dbHelper.save(e);

          _getLastLatLong();
          setState(() {});
          // }
          // clearName();
          // refreshList();
          setState(() {
            rid = "Checked In";
          });

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabsPage(
                  openTab: 1,
                ),
              ));
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
            DateTime now = DateTime.now();
            righttime = new DateFormat.yMd().add_jm().format(now);

            //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
          });
          formKey.currentState.save();
          // if (isUpdating) {
          //   print("11111111");
          //   // if (location == null) {
          //   // Employee e =
          //   //     Employee(curUserId, "L, L", righttime, rid, color, remark);
          //   // dbHelper.update(e);

          //   // } else {
          //   Employee e =
          //       Employee(curUserId, location, righttime, rid, color, remark);
          //   dbHelper.update(e);
          //   // }

          //   setState(() {
          //     isUpdating = false;
          //   });
          // } else {
          // print("2222");
          // if (location == null) {
          //   Employee e = Employee(curUserId, "L, L", righttime, rid, color, "");
          //   dbHelper.save(e);
          // } else {
          Employee e = Employee(curUserId, location, righttime, rid, "", "");
          dbHelper.save(e);
          // }

          // color = "1";
          // this.alertmsg = "Check In Successfully!";
          // this.snackbarmethod();
          _getLastLatLong();
          setState(() {});
          // }
          // clearName();
          // refreshList();
          setState(() {
            rid = "Checked In";
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabsPage(
                  openTab: 1,
                ),
              ));
        }
      }
    }
  }

  Future scanBarcodeNormal() async {
    String barcodeScanRes = "";
    try {
      barcodeScanRes = await scanner.scan();
      if (barcodeScanRes != null) {
        if (barcodeScanRes.substring(0, 1) == "{") {
          print(barcodeScanRes);
          // var route = new MaterialPageRoute(
          //     builder: (BuildContext context) =>
          //         new Sqlite());
          // Navigator.of(context).push(route);
          var scanresult = jsonDecode(barcodeScanRes);
          rid = scanresult["rid"];

          // remark = scanresult["remark"];
          // print("RMK >> " + remark.toString());
          validate();
          setState(() {});
        } else {
          print("haha");
        }
      } else {
        scanBarcodeNormal();
      }
      setState(() {
        // _scanBarcode = barcodeScanRes;
        // print(_scanBarcode);
        // alertmsg = _scanBarcode;
        snackbarmethod1(barcodeScanRes);

        // this._method1();
      });
      // } on PlatformException catch(ex){
      //   if(ex.code == BarcodeScanner.CameraAccessDenied){
      //     setState(() {
      //       alertmsg = "The permission was denied.";
      //     });
      //   }else{
      //     setState(() {
      //       alertmsg = "unknown error ocurred $ex";
      //     });
      //   }
    } on FormatException {
      setState(() {
        // alertmsg = "Scan canceled, try again !";
        // print(alertmsg);
        snackbarmethod1("Scan canceled, try again !");
      });
    } catch (e) {
      // alertmsg = "Unknown error $e";
      snackbarmethod1("Unknown error $e");
    }
    print(barcodeScanRes);
    // this._method1();
  }

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
                            // trackingCheck ? Container() : validate();
                            validate();
                            setState(() {});
                          },
                          child: Text(
                            // isUpdating
                            //     ? 'UPDATE'
                            //     : checklang == "Eng" ? textEng[0] :
                            textMyan[0],
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
                      color: Colors.blue,
                      // trackingCheck ? Colors.grey : Colors.blue,
                      onPressed: () {
                        setState(() {
                          // trackingCheck ? Container() :
                           scanBarcodeNormal();
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
                //   child: Image.asset(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100.0,
              ),
              // Container(
              //   width: 200,
              //   height: 200,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     // border: Border.all(
              //     //   color: Colors.white,
              //     //   width: 0,
              //     // ),
              //     boxShadow: [
              //       BoxShadow(
              //           color: Colors.grey.withOpacity(0.5),
              //           offset: Offset(0, 5),
              //           blurRadius: 25)
              //     ],
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.all(20.0),
              //   child: CircleAvatar(
              //       backgroundColor: Colors.transparent,
              //       backgroundImage: AssetImage("assets/play-button.png")),
              // ),

              Container(
                  height: 150,
                  // width: 100,
                  decoration: BoxDecoration(
                      // shape: BoxShape.rectangle,
                      // border: Border.all(
                      //   color: Colors.white,
                      //   width: 5,
                      // ),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey.withOpacity(0.5),
                      //       offset: Offset(0, 5),
                      //       blurRadius: 25)
                      // ],
                      ),
                  //   child: CircleAvatar(
                  //       backgroundColor: Colors.blue,
                  //       backgroundImage: AssetImage("assets/start1.png")),
                  // ),
                  child: Image.asset("assets/sss3.png")),
              SizedBox(
                height: 10.0,
              ),
//               TraceMyanmar မှ ကြိုဆိုပါသည်။
// Welcome to Trace Myanmar.
              Text(
                "TraceMyanmar",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "မှ ကြိုဆိုပါသည်။",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Welcome to TraceMyanmar",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              // // // GestureDetector(
              // // //   onTap: () async {
              // // //     if (trackingCheck == true) {
              // // //       // bg.BackgroundGeolocation.stop().then((bg.State state) {
              // // //       //   // print('[stop] success: $state');
              // // //       //   // Reset odometer.
              // // //       //   bg.BackgroundGeolocation.setOdometer(0.0);

              // // //       setState(() {
              // // //         //     bg.BackgroundGeolocation.changePace(false)
              // // //         //         .then((bool isMoving) {
              // // //         //       // print('[changePace] success $isMoving');
              // // //         //     }).catchError((e) {
              // // //         //       print('[changePace] ERROR: ' + e.code.toString());
              // // //         //     });
              // // //         trackingCheck = false;
              // // //       });
              // // //       final prefs = await SharedPreferences.getInstance();
              // // //       prefs.setString("chk_tracking", "0");
              // // //       prefs.setInt("timer", 0);
              // // //       prefs.setInt("saveCount", 0);
              // // //       setState(() {
              // // //         saveCount = 0;
              // // //       });
              // // //       timer.cancel();
              // // //       //     // _odometer = '0.0';
              // // //       //     // trackingCheck = state.enabled;
              // // //       //     // _isMoving = state.isMoving;
              // // //       //   });

              // // //     } else {
              // // //       //-----------
              // // //       // bg.BackgroundGeolocation.start().then((bg.State state) {
              // // //       //   // print('[start] success >> ' + state.enabled.toString());

              // // //       //     // trackingCheck = state.enabled;
              // // //       //     // _isMoving = state.isMoving;
              // // //       //     bg.BackgroundGeolocation.changePace(true)
              // // //       //         .then((bool isMoving) {
              // // //       //       // print('[changePace] success $isMoving');
              // // //       //     }).catchError((e) {
              // // //       //       print('[changePace] ERROR: ' + e.code.toString());
              // // //       //     });
              // // //       setState(() {
              // // //         trackingCheck = true;
              // // //       });

              // // //       final prefs = await SharedPreferences.getInstance();
              // // //       prefs.setString("chk_tracking", "true");
              // // //       prefs.setInt("timer", startInterval);
              // // //       _start = startInterval;
              // // //       countDownSave();
              // // //       //   });

              // // //     }
              // // //   },
              // // //   child: Container(
              // // //       height: 100,
              // // //       width: 100,
              // // //       decoration: BoxDecoration(
              // // //         shape: BoxShape.rectangle,
              // // //         border: Border.all(
              // // //           color: Colors.white,
              // // //           width: 5,
              // // //         ),
              // // //         boxShadow: [
              // // //           BoxShadow(
              // // //               color: Colors.grey.withOpacity(0.5),
              // // //               offset: Offset(0, 5),
              // // //               blurRadius: 25)
              // // //         ],
              // // //       ),
              // // //       //   child: CircleAvatar(
              // // //       //       backgroundColor: Colors.blue,
              // // //       //       backgroundImage: AssetImage("assets/start1.png")),
              // // //       // ),
              // // //       child: trackingCheck
              // // //           ? Image.asset("assets/stop1.png")
              // // //           : Image.asset("assets/start1.png")),
              // // // ),
              // // // SizedBox(
              // // //   height: 30.0,
              // // // ),
              // // // trackingCheck
              // // //     ? Column(
              // // //         children: <Widget>[
              // // //           Container(
              // // //               width: MediaQuery.of(context).size.width * 0.70,
              // // //               child: RichText(
              // // //                 textAlign: TextAlign.center,
              // // //                 text: TextSpan(
              // // //                   text:
              // // //                       'သွားရောက်သောနေရာများမှတ်သားခြင်းကို ရပ်လိုပါက ',
              // // //                   style: TextStyle(color: Colors.black),
              // // //                   children: <TextSpan>[
              // // //                     TextSpan(
              // // //                       text: 'STOP',
              // // //                       style: TextStyle(
              // // //                         color: Colors.black,
              // // //                         // fontWeight: FontWeight.bold,
              // // //                       ),
              // // //                     ),
              // // //                     TextSpan(text: ' ကို နှိပ်ပါ။'),
              // // //                   ],
              // // //                 ),
              // // //               )
              // // //               // Text(
              // // //               //   "သွားရောက်သောနေရာများကိုမှတ်သားစေလိုပါက  START ကို နှိပ်ပါ။",
              // // //               //   textAlign: TextAlign.center,
              // // //               //   style: TextStyle(
              // // //               //       color: Colors.black,
              // // //               //       fontWeight: FontWeight.bold),
              // // //               // ),
              // // //               ),
              // // //           SizedBox(
              // // //             height: 10.0,
              // // //           ),
              // // //           Container(
              // // //               width: MediaQuery.of(context).size.width * 0.70,
              // // //               child: RichText(
              // // //                 textAlign: TextAlign.center,
              // // //                 text: TextSpan(
              // // //                   text: 'Press ',
              // // //                   style: TextStyle(color: Colors.black),
              // // //                   children: <TextSpan>[
              // // //                     TextSpan(
              // // //                       text: 'STOP',
              // // //                       style: TextStyle(
              // // //                         color: Colors.black,
              // // //                         // fontWeight: FontWeight.bold,
              // // //                       ),
              // // //                     ),
              // // //                     TextSpan(
              // // //                         text:
              // // //                             ' button to stop tracing your locations.'),
              // // //                   ],
              // // //                 ),
              // // //               )),
              // // //           // Container(
              // // //           //     width: MediaQuery.of(context).size.width * 0.70,
              // // //           //     child: Text(
              // // //           //       " START button to trace your locations.",
              // // //           //       textAlign: TextAlign.center,
              // // //           //       style: TextStyle(color: Colors.black),
              // // //           //     )),
              // // //         ],
              // // //       )
              // // //     : Column(
              // // //         children: <Widget>[
              // // //           // Container(
              // // //           //     width: MediaQuery.of(context).size.width * 0.70,
              // // //           //     child: Text(
              // // //           //       "သွားရောက်သောနေရာများမှတ်သားခြင်းကို ရပ်လိုပါက STOP ကို နှိပ်ပါ။",
              // // //           //       textAlign: TextAlign.center,
              // // //           //       style: TextStyle(
              // // //           //           color: Colors.black,
              // // //           //           fontWeight: FontWeight.bold),
              // // //           //     )),
              // // //           Container(
              // // //               width: MediaQuery.of(context).size.width * 0.70,
              // // //               child: RichText(
              // // //                 textAlign: TextAlign.center,
              // // //                 text: TextSpan(
              // // //                   text:
              // // //                       'သွားရောက်သောနေရာများကို မှတ်သားစေလိုပါက ',
              // // //                   style: TextStyle(color: Colors.black),
              // // //                   children: <TextSpan>[
              // // //                     TextSpan(
              // // //                       text: 'START',
              // // //                       style: TextStyle(
              // // //                         color: Colors.black,
              // // //                         // fontWeight: FontWeight.bold,
              // // //                       ),
              // // //                     ),
              // // //                     TextSpan(text: ' ကို နှိပ်ပါ။'),
              // // //                   ],
              // // //                 ),
              // // //               )),
              // // //           SizedBox(
              // // //             height: 10.0,
              // // //           ),
              // // //           Container(
              // // //               width: MediaQuery.of(context).size.width * 0.70,
              // // //               child: RichText(
              // // //                 textAlign: TextAlign.center,
              // // //                 text: TextSpan(
              // // //                   text: 'Press ',
              // // //                   style: TextStyle(color: Colors.black),
              // // //                   children: <TextSpan>[
              // // //                     TextSpan(
              // // //                       text: 'START',
              // // //                       style: TextStyle(
              // // //                         color: Colors.black,
              // // //                         // fontWeight: FontWeight.bold,
              // // //                       ),
              // // //                     ),
              // // //                     TextSpan(
              // // //                         text: ' button to trace your locations.'),
              // // //                   ],
              // // //                 ),
              // // //               )),
              // // //           // Container(
              // // //           //     width: MediaQuery.of(context).size.width * 0.70,
              // // //           //     child: Text(
              // // //           //       "Press STOP button to stop tracing your locations.",
              // // //           //       textAlign: TextAlign.center,
              // // //           //       style: TextStyle(color: Colors.black),
              // // //           //     )),
              // // //         ],
              // // //       ),
              // // // SizedBox(
              // // //   height: 20.0,
              // // // ),
              // // // saveCount == 0
              // // //     ? Container()
              // // //     : Container(
              // // //         child: Text(
              // // //           "[" + saveCount.toString() + "]",
              // // //           textAlign: TextAlign.center,
              // // //           style: TextStyle(
              // // //               fontWeight: FontWeight.bold, fontSize: 18.0),
              // // //         ),
              // // //       )
              // Container(child: Text('$_content')),
              // Container(
              //   child: Text(
              //     'Array to save/upload',
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.70,
              //   child: Text('$testArray'),
              // )
              // Text("သွားရောက်သောနေရာများမှတ်သားခြင်းကို ရပ်လိုပါက  Stop ကိုနှိပ်ပါ။")
            ],
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[form()],
    );
  }
}
