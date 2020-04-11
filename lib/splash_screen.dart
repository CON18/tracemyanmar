import 'dart:async';

import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  var location;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _toClearRref();
    Timer(
        Duration(seconds: 3),
        () => {
              // // Navigator.pushReplacement(
              // //     context,
              // //     MaterialPageRoute(
              // //       builder: (context) => Sqlite(),
              // //     ))
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabsPage(
                      openTab: 0,
                    ),
                  ))
              // _checkDemo();
            });
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

  _getCurrentLocation() async {
    setState(() {});
    try {
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // final Geolocator geolocator = Geolocator()
      //   ..forceAndroidLocationManager = true;
      // var position = await geolocator.getLastKnownPosition(
      //     desiredAccuracy: LocationAccuracy.best);
      print("location >>> $location");
      location = "${position.latitude}, ${position.longitude}";
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("fist-loc", location);
      // latt = "${position.latitude}";
      // longg = "${position.longitude}";

      // setState(() {});
      // print(_locationMessage);
      // print(formattedDate);
    } on Exception catch (_) {
      print('never reached');
    }
  }

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
                                        backgroundColor: Colors.blue[400],
                                        backgroundImage:
                                            AssetImage("assets/sss3.png")),
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
                        // "Saw Saw Shar",
                        "TraceMyanmar",
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
