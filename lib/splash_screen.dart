import 'dart:async';

import 'package:TraceMyanmar/Drawer/report/new_report.dart';
import 'package:TraceMyanmar/Intro/Intro.dart';
import 'package:TraceMyanmar/Intro/TC.dart';
import 'package:TraceMyanmar/contact/contact_list.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:TraceMyanmar/test.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'dart:convert';

JsonEncoder encoder = new JsonEncoder.withIndent("     ");

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  var location;
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    _toClearRref();
    _setBT();
//     firebaseCloudMessaging_Listeners();

    bg.BackgroundGeolocation.onLocation(_onLocation);
    // bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    // bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    // bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

    // 2.  Configure the plugin
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
            // debug: false,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            notificationTitle: "Saw Saw Shar",
            notificationText: "Movement",
            // notificationTitle: "",
            // notificationText: "",            
            reset: true))
        .then((bg.State state) {
      // setState(() {
      // bg.BackgroundGeolocation.start();
      bg.BackgroundGeolocation.start().then((bg.State state) {
        // print('[start] success >> ' + state.enabled.toString());
        // // //   // final prefs = await SharedPreferences.getInstance();
        // // //   // var cp = prefs.getString("changePace") ?? "false";
        // // //   // if (cp == "false") {
        bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
          // print('[changePace] success $isMoving');
          // prefs.setString("changePace", "true");
          // _syncList();
        }).catchError((e) {
          print('[changePace] ERROR: ' + e.code.toString());
        });
        // // //   // } else {
        // // //   //   _syncList();
        // // //   // }
      }).catchError((e) {
        print('[start] ERROR: ' + e.code.toString());
        bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
          // print('[changePace] success $isMoving');
          // _syncList();
        }).catchError((e) {
          print('[changePace] ERROR1: ' + e.code.toString());
        });
      });

      // trackingCheck = state.enabled;
      // _isMoving = state.isMoving;
      // });
    });

    Timer(
        Duration(seconds: 3),
        () => {
              _check()
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => IntroPage(),
              //     ))
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => TabsPage(
              //         openTab: 0,
              //       ),
              //     ))
              // _checkDemo();
            });
  }

  void _onLocation(bg.Location location) async {
    // locCount = locCount + 1;
    // print('[location] >>>> ' + location.toString());
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    // print('PRO CHG EVE >>> $event');
    setState(() {
      // _content = encoder.convert(event.toMap());
      // trackingArray.add(_content);
    });
  }

  _setBT() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("buildType", 1);
  }

  // void firebaseCloudMessaging_Listeners() {
  //   // if (Platform.isIOS) iOS_Permission();
  //   print("FBM >>");
  //   _firebaseMessaging.getToken().then((token) {
  //     print("TOKEN >> " + token.toString());
  //   });

  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //     },
  //   );
  // }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

  _check() async {
    final prefs = await SharedPreferences.getInstance();
    var ref = prefs.getString("firsttime") ?? "false";
    if (ref == "false") {
      //first time
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => IntroPage(),
      //     ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TCPage(
            check: "0",
          ),
        ),
      );
    } else {
      //no need to show
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabsPage(
              openTab: 1,
            ),
          ));
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => TestPage(),
      //       ));
    }
  }

  _toClearRref() async {
    final prefs = await SharedPreferences.getInstance();
    var ref = prefs.getString("refferences") ?? 0;
    print("REF >>> " + ref);
    if (ref == 0) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("refferences", "not first time");
    }
  }

  // _getCurrentLocation() async {
  //   setState(() {});
  //   try {
  //     final position = await Geolocator()
  //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //     // final Geolocator geolocator = Geolocator()
  //     //   ..forceAndroidLocationManager = true;
  //     // var position = await geolocator.getLastKnownPosition(
  //     //     desiredAccuracy: LocationAccuracy.best);
  //     print("location >>> $location");
  //     location = "${position.latitude}, ${position.longitude}";
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString("fist-loc", location);
  //     // latt = "${position.latitude}";
  //     // longg = "${position.longitude}";

  //     // setState(() {});
  //     // print(_locationMessage);
  //     // print(formattedDate);
  //   } on Exception catch (_) {
  //     print('never reached');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        // fit: StackFit.passthrough,
        children: <Widget>[
          // Container(
          //   height: 150.0,
          //   decoration: BoxDecoration(color: Colors.white),
          // ),
          ClipPath(
            child: Container(
                color: Colors.blue.withOpacity(0.8),
                // height: 250.0,
                height: MediaQuery.of(context).size.height * 0.35),
            // clipper: getClipper(),
          ),
          Column(
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                // child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      // padding: const EdgeInsets.only(top: 17.0, left: 120.0),
                      padding: const EdgeInsets.only(top: 17.0, left: 0.0),
                      child: Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 7,
                          ),

                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.grey.withOpacity(0.5),
                          //       offset: Offset(0, 5),
                          //       blurRadius: 25)
                          // ],
                          color: Colors.white,
                          // image: DecorationImage(
                          //     image: new NetworkImage('https://unitutor.azurewebsites.net/regphoto/image/' +
                          //         widget.profileImg),
                          //     fit: BoxFit.cover)
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(75.0),
                          //     ),
                          //     boxShadow: [
                          //       BoxShadow(blurRadius: 7.0, color: Colors.black),
                          // ]
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                  onTap: () {
                                    print("YOUR CLICK PRO IMG >>");
                                    // // _onActionSheetPress(context);
                                  },
                                  child:
                                      // CircleAvatar(
                                      //     backgroundImage:
                                      //         AssetImage("images/choose_img1.png")),
                                      Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            offset: Offset(0, 5),
                                            blurRadius: 25)
                                      ],
                                    ),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.white,
                                        backgroundImage:
                                            AssetImage("assets/tm-logo.png")),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 0.0),
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 0.0),
                      child: Text(
                        "Saw Saw Shar",
                        // "TraceMyanmar",
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
              // SizedBox(
              //   height: 30.0,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
