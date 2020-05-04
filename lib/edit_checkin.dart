import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/location/helpers/singleMkr_map.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EditCheckIn extends StatefulWidget {
  final String id;
  final String location;
  final String time;
  final String ride;
  final String color;
  final String remark;

  EditCheckIn(
      {Key key,
      @required this.id,
      @required this.location,
      @required this.time,
      @required this.ride,
      @required this.color,
      @required this.remark})
      : super(key: key);

  @override
  _EditCheckInState createState() => _EditCheckInState();
}

class _EditCheckInState extends State<EditCheckIn> {
  // final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  GoogleMapController myMapController;
  // final Set<Marker> _markers = new Set();
  LatLng _mainLocation;
  String checklang = '';
  List textMyan = [
    "Check In အချက်အလက်",
    // နံပါတ်
  ];
  List textEng = [
    "Edit Check In",
  ];

  final locNameCtr = TextEditingController();
  final locCtrl = TextEditingController();
  final remarkCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  var _start;
  Timer timer;
  var dbHelper;
  var lan;

  bool checkRemark = false;

  @override
  void initState() {
    super.initState();
    someMethod();
    // _checkAndstartTrack();
    // print("Loc" + widget.location.toString());
    if (widget.location == "null" || widget.location == "") {
    } else {
      var index = widget.location.toString().indexOf(',');
      var lat = widget.location.toString().substring(0, index);
      var long = widget.location.toString().substring(index + 1);
      _mainLocation = LatLng(double.parse(lat), double.parse(long));
      print("ML >> " + lat + "|" + long);
    }

    if (widget.ride == "null" || widget.ride == "Checked In") {
      locNameCtr.text = "";
    } else {
      locNameCtr.text = widget.ride;
    }
    if (widget.location == "null" || widget.location == "") {
      locCtrl.text = "";
    } else {
      locCtrl.text = widget.location;
    }
    if (widget.remark == "null") {
      remarkCtrl.text = "";
    } else {
      if (widget.remark.startsWith("[") && widget.remark.endsWith("]")) {
        remarkCtrl.text = "Report";
      } else {
        remarkCtrl.text = widget.remark;
      }
    }
    if (widget.time == "null") {
      timeCtrl.text = "";
    } else {
      timeCtrl.text = widget.time;
    }
    analyst();
    chkRmk();
  }

  chkRmk() async {
    setState(() {
      if (widget.remark == "" || widget.remark == null) {
      } else {
        if (widget.remark == "Auto" ||
            (widget.remark.startsWith("[") && widget.remark.endsWith("]"))) {
          checkRemark = true;
        } else {
          checkRemark = false;
        }
      }
    });
  }

  @override
  void dispose() {
    // timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'EditCheckIn_Request',
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

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
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

  editCheckIn() async {
    if (locCtrl.text == "L, L") {
      var dbHelper = DBHelper();
      Employee e = Employee(int.parse(widget.id), "L, L", widget.time, null,
          widget.color, remarkCtrl.text);
      dbHelper.update(e);
    } else {
      if (locNameCtr.text == "") {
        var dbHelper = DBHelper();
        Employee e = Employee(int.parse(widget.id), locCtrl.text, widget.time,
            null, widget.color, remarkCtrl.text);
        dbHelper.update(e);
      } else {
        var dbHelper = DBHelper();
        Employee e = Employee(int.parse(widget.id), locCtrl.text, widget.time,
            locNameCtr.text, widget.color, remarkCtrl.text);
        dbHelper.update(e);
      }
    }

    // setState(() {
    Navigator.pop(context, "success");
    // });
  }

  // snackbarmethod1(name) {
  //   _scaffoldkey.currentState.showSnackBar(new SnackBar(
  //     // content: new Text("Please wait, searching your location"),
  //     content: new Text(name),
  //     backgroundColor: Colors.blue.shade400,
  //     duration: Duration(seconds: 3),
  //   ));
  // }

  // _getCurrentLocation() async {
  //   final position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   // final Geolocator geolocator = Geolocator()
  //   //   ..forceAndroidLocationManager = true;
  //   // var position = await geolocator.getLastKnownPosition(
  //   //     desiredAccuracy: LocationAccuracy.best);
  //   setState(() {
  //     // print("location >>> " + position.toString());
  //     if (position == null) {
  //       snackbarmethod1("Can't find your location.");
  //     } else {
  //       var location = "${position.latitude}, ${position.longitude}";
  //       locCtrl.text = location;
  //     }
  //   });
  //   // setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // checklang == "Eng" ? textEng[0] : textMyan[0],
          lan == "Zg" ? Rabbit.uni2zg(textMyan[0]) : textMyan[0],
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18.0,
            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: Builder(builder: (BuildContext context) {
          return new GestureDetector(
            onTap: () {
              editCheckIn();
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
          // height: 290,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0, top: 15.0, bottom: 0.0),
                  child: Column(
                    children: <Widget>[
                      // (widget.location == "L, L")
                      // ? Padding(
                      //     padding:
                      //         const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      //     child: Column(
                      //       children: <Widget>[
                      //         Row(
                      //           children: <Widget>[
                      //             Container(
                      //               width: MediaQuery.of(context).size.width *
                      //                   0.60,
                      //               child: TextFormField(
                      //                 readOnly: true,
                      //                 keyboardType: TextInputType.number,
                      //                 controller: locCtrl,
                      //                 style: TextStyle(
                      //                     color: Colors.grey,
                      //                     fontWeight: FontWeight.w300),
                      //                 decoration: InputDecoration(
                      //                   // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                      //                   labelText: "တည်နေရာ (Location)",
                      //                   hasFloatingPlaceholder: true,
                      //                   labelStyle: TextStyle(
                      //                       fontSize: 16,
                      //                       color: Colors.black,
                      //                       height: 0),
                      //                   fillColor: Colors.grey,
                      //                 ),
                      //               ),
                      //             ),
                      //             GestureDetector(
                      //               onTap: () {
                      //                 print("GCL");
                      //                 _getCurrentLocation();
                      //               },
                      //               child: Container(
                      //                 padding: EdgeInsets.only(
                      //                     left: 15.0, top: 10.0),
                      //                 child: Icon(
                      //                   Icons.location_on,
                      //                   color: Colors.green,
                      //                   size: 30,
                      //                 ),
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   )
                      // :
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                        child: Container(
                            child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          controller: locCtrl,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                          ),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                            // labelText: "တည်နေရာ (Location)",
                            labelText: lan == "Zg"
                                ? Rabbit.uni2zg("တည်နေရာ (Location)")
                                : "တည်နေရာ (Location)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 0,
                              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                            ),
                            fillColor: Colors.grey,
                          ),
                        )),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                        child: Container(
                            child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          controller: timeCtrl,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                          ),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                            // labelText: "အချိန် (Time)",
                            labelText: lan == "Zg"
                                ? Rabbit.uni2zg("အချိန် (Time)")
                                : "အချိန် (Time)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 0,
                              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                            ),
                            fillColor: Colors.grey,
                          ),
                        )),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                        child: Container(
                            child: TextFormField(
                          readOnly: false,
                          keyboardType: TextInputType.text,
                          controller: locNameCtr,
                          style: TextStyle(
                              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                            // labelText: "တည်နေရာ အမည် (Location name)",
                            labelText: lan == "Zg"
                                ? Rabbit.uni2zg("တည်နေရာ အမည် (Location name)")
                                : "တည်နေရာ အမည် (Location name)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                fontSize: 14,
                                color: Colors.black,
                                height: 0),
                            fillColor: Colors.grey,
                          ),
                        )),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                        child: Container(
                            child: TextFormField(
                          readOnly: checkRemark,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 5,
                          controller: remarkCtrl,
                          style: TextStyle(
                              color: checkRemark ? Colors.grey : Colors.black,
                              fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: checkRemark
                                      ? Colors.grey
                                      : Colors.lightBlue,
                                  width: 1.0),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: checkRemark
                                      ? Colors.grey
                                      : Colors.lightBlue,
                                  width: 1.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color:
                                      checkRemark ? Colors.grey : Colors.grey,
                                  width: 1.0),
                            ),
                            // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                            // labelText: "မှတ်ချက် (Remark)",
                            labelText: lan == "Zg"
                                ? Rabbit.uni2zg("မှတ်ချက် (Remark)")
                                : "မှတ်ချက် (Remark)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                fontSize: 14,
                                color: checkRemark ? Colors.grey : Colors.black,
                                height: 0),
                            fillColor: Colors.grey,
                          ),
                        )),
                      ),
                      // (widget.location == "null" || widget.location == "")
                      //     ? Container():
                      SizedBox(
                        height: 25.0,
                      ),
                      (widget.location == "null" || widget.location == "")
                          ? Container()
                          : Container(
                              height: 300,
                              width: MediaQuery.of(context).size.width * 90,
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
                                      title: widget.time
                                          .toString()
                                          .replaceAll("T", " "),
                                    ),
                                    // icon: BitmapDescriptor.defaultMarker,
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
                            )
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 new RaisedButton(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),
//                                   onPressed: () async {
//                                     var index =
//                                         widget.location.toString().indexOf(',');
//                                     double lat = double.parse(widget.location
//                                         .toString()
//                                         .substring(0, index));
//                                     double long = double.parse(widget.location
//                                         .toString()
//                                         .substring(index + 1));
//                                     // MapsLauncher.launchCoordinates(
//                                     //     lat, long, widget.time.toString());
//                                     // void _launchMapsUrl(double lat, double lon) async {
//                                     final url =
//                                         'https://www.google.com/maps/search/?api=1&query=$lat,$long';
//                                     if (await canLaunch(url)) {
//                                       await launch(url);
//                                     } else {
//                                       throw 'Could not launch $url';
//                                     }
// // }
//                                     // update("S");
//                                     // Navigator.push(
//                                     //     context,
//                                     //     MaterialPageRoute(
//                                     //         builder: (context) => SingleMarker(
//                                     //               id: widget.id.toString(),
//                                     //               location: widget.location
//                                     //                   .toString(),
//                                     //               time: widget.time.toString(),
//                                     //               ride: widget.ride.toString(),
//                                     //             )));
//                                   },
//                                   color: Colors.blue,
//                                   textColor: Colors.white,
//                                   child: Container(
//                                     // width: 120.0,
//                                     width: MediaQuery.of(context).size.width *
//                                         0.75,
//                                     height: 38.0,
//                                     child: Center(
//                                         // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
//                                         child: Text(
//                                             // checklang == "Eng" ? textEng[6] : textMyan[6],
//                                             lan == "Zg"
//                                                 ? Rabbit.uni2zg('​မြေပုံ (Map)')
//                                                 : '​မြေပုံ (Map)',
//                                             style: TextStyle(
//                                               fontFamily: lan == "Zg"
//                                                   ? "Zawgyi"
//                                                   : "Pyidaungsu",
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w300,
//                                             ))),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                       SizedBox(
//                         height: 20.0,
//                       ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
