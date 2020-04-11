import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EditCheckIn extends StatefulWidget {
  final String id;
  final String location;
  final String time;
  final String ride;
  final String remark;

  EditCheckIn(
      {Key key,
      @required this.id,
      @required this.location,
      @required this.time,
      @required this.ride,
      @required this.remark})
      : super(key: key);

  @override
  _EditCheckInState createState() => _EditCheckInState();
}

class _EditCheckInState extends State<EditCheckIn> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
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

  @override
  void initState() {
    super.initState();
    checkLanguage();
    dbHelper = DBHelper();
    _checkAndstartTrack();
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
      remarkCtrl.text = widget.remark;
    }
    if (widget.time == "null") {
      timeCtrl.text = "";
    } else {
      timeCtrl.text = widget.time;
    }
  }

@override
  void dispose() {
    timer.cancel();
    // timer1.cancel();
    super.dispose();
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
      Employee e = Employee(
          int.parse(widget.id), "L, L", widget.time, null, "", remarkCtrl.text);
      dbHelper.update(e);
    } else {
      if (locNameCtr.text == "") {
        var dbHelper = DBHelper();
        Employee e = Employee(int.parse(widget.id), locCtrl.text, widget.time,
            null, "", remarkCtrl.text);
        dbHelper.update(e);
      } else {
        var dbHelper = DBHelper();
        Employee e = Employee(int.parse(widget.id), locCtrl.text, widget.time,
            locNameCtr.text, "", remarkCtrl.text);
        dbHelper.update(e);
      }
    }

    // setState(() {
    Navigator.pop(context, "success");
    // });
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // final Geolocator geolocator = Geolocator()
    //   ..forceAndroidLocationManager = true;
    // var position = await geolocator.getLastKnownPosition(
    //     desiredAccuracy: LocationAccuracy.best);
    setState(() {
      // print("location >>> " + position.toString());
      if (position == null) {
        snackbarmethod1("Can't find your location.");
      } else {
        var location = "${position.latitude}, ${position.longitude}";
        locCtrl.text = location;
      }
    });
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          checklang == "Eng" ? textEng[0] : textMyan[0],
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
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
                              color: Colors.grey, fontWeight: FontWeight.w300),
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
                            labelText: "တည်နေရာ (Location)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontSize: 14, color: Colors.grey, height: 0),
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
                              color: Colors.grey, fontWeight: FontWeight.w300),
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
                            labelText: "အချိန် (Time)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontSize: 14, color: Colors.grey, height: 0),
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
                              color: Colors.black, fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                            labelText: "တည်နေရာ အမည် (Location name)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontSize: 14, color: Colors.black, height: 0),
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
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 5,
                          controller: remarkCtrl,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                            labelText: "မှတ်ချက် (Remark)",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(
                                fontSize: 14, color: Colors.black, height: 0),
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
                            )
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
