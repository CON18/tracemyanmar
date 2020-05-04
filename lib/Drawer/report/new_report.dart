import 'dart:async';
import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:TraceMyanmar/Drawer/report/report.dart';
import 'package:flutter/material.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewReport extends StatefulWidget {
  @override
  _NewReportState createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  List itemLists = [
    {"id": "01", "no": "၁။ ", "title": "ကောင်းမွန်", "select": false},
    {"id": "02", "no": "၁။ ", "title": "ဖျားနာ", "select": false},
    {"id": "03", "no": "၁။ ", "title": "ချောင်းဆိုး", "select": false},
    {"id": "04", "no": "၁။ ", "title": "အားအင်ကုန်ခန်း", "select": false},
    {"id": "05", "no": "၁။ ", "title": "အသက်ရှူကျပ်", "select": false},
  ];
  // final TextEditingController _text1 = new TextEditingController();
  // final TextEditingController _text2 = new TextEditingController();
  // final TextEditingController _text3 = new TextEditingController();
  var phone, loc, date;
  // bool v1 = false;
  // bool v2 = false;
  // bool v3 = false;
  // bool vv = false;
  // var a, b, c, d, e, haha;
  // String v4 = "null";
  String checklang = '';
  List textMyan = [
    "စစ်​​ဆေးခြင်း (Reporting)",
    "စုစုပေါင်းအမှတ် (Total Mark)",
    "တည်နေရာ (Location)",
    "ဖုန်းနံပါတ် (Phone)",
    "",
    "ပယ်ဖျက်မည်",
    "အတည်ပြုပါ (Submit)"
  ];
  List textEng = [
    "Reporting",
    "Total Mark",
    "Location",
    "Phone Number",
    "",
    "Cancel",
    "Report"
  ];

  var lan;

  int checkCount = 0;

  var _start;
  Timer timer;
  var dbHelper;
  var showLoc;
  var showLat;
  var showLong;

  bool selectGood = false;

  @override
  void initState() {
    super.initState();
    checkLanguage();

    dbHelper = DBHelper();
    // _checkAndstartTrack();
    getdata();
    someMethod();
    // for (var i = 0; i < l.length; i++) {
    //     isChecking.add(false);
    //   }
    analyst();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'Report_Request',
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

  checkLanguage() async {
    // final prefs = await SharedPreferences.getInstance();
    // checklang = prefs.getString("Lang");
    // if (checklang == "" || checklang == null || checklang.length == 0) {
    //   checklang = "Eng";
    // } else {
    //   checklang = checklang;
    // }
    checklang = "Myanmar";
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  getdata() async {
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
        setState(() {
          loc = "${position.latitude}, ${position.longitude}";
          showLoc =
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
          showLat = "${position.latitude}";
          showLong = "${position.longitude}";
        });

        // latt = "${position.latitude}";
        // longg = "${position.longitude}";
      } else {
        final position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print(position);
        // var lat = "${position.latitude}";
        // var long = "${position.longitude}";
        setState(() {
          loc = "${position.latitude}, ${position.longitude}";
          showLoc =
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
          showLat = "${position.latitude}";
          showLong = "${position.longitude}";
        });

        // loc = lat + ", " + long;
        // DateTime now = DateTime.now();
        // date = new DateFormat.yMd().add_jm().format(now);
        date = convertDateTime();
        final prefs = await SharedPreferences.getInstance();
        var phno = prefs.getString('UserId') ?? 0;
        if (phno == 0) {
          phone = null;
        } else {
          phone = phno;
        }
        // print(phno);

        // _text2.text = '$position';
        // _text3.text = phno;

      }
    }
  }

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

  @override
  void dispose() {
    // timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

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
  //     // UserId
  //     final prefs = await SharedPreferences.getInstance();
  //     var userId = prefs.getString("UserId") ?? null;

  //     final position = await Geolocator()
  //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //     var location = "${position.latitude}, ${position.longitude}";
  //     print("location >>> $location");

  //     // DateTime now = DateTime.now();
  //     // var curDT = new DateFormat.yMd().add_jm().format(now);
  //     var curDT = convertDateTime();
  //     if (userId == null) {
  //       Employee e = Employee(null, location, curDT, "Checked In", "", "Auto");
  //       dbHelper.save(e);
  //     } else {
  //       Employee e = Employee(
  //           int.parse(userId), location, curDT, "Checked In", "", "Auto");
  //       dbHelper.save(e);
  //     }

  //     // final prefs = await SharedPreferences.getInstance();
  //     int c = prefs.getInt("saveCount") ?? 0;
  //     final prefs1 = await SharedPreferences.getInstance();
  //     int r = c + 1;
  //     prefs1.setInt("saveCount", r);
  //     // setState(() {
  //     //   refreshList();
  //     // });
  //     print("Save --->>>>");
  //     _start = startInterval;
  //     countDownSave();
  //   } on Exception catch (_) {
  //     print('never reached');
  //   }
  //   // });
  // }

  _selectChange(list) async {
    setState(() {
      if (list["id"].toString() == "01") {
        print("AA" + itemLists[0]["select"].toString());
        // for (var ii = 0; ii < itemLists.length; ii++) {}

        itemLists[0]["select"] = true;
        itemLists[1]["select"] = false;
        itemLists[2]["select"] = false;
        itemLists[3]["select"] = false;
        itemLists[4]["select"] = false;

        // setState(() {
        //   selectGood = true;
        // });
      } else {
        for (var ii = 0; ii < itemLists.length; ii++) {
          if (itemLists[ii]["id"].toString() == list["id"].toString()) {
            if (list["select"].toString() == "true") {
              itemLists[ii]["select"] = false;
              // checkCount = checkCount - 1;
              // chooseLists.removeWhere((item) =>
              //     item["services_syskey"] == list[ii]["services_syskey"]);
            } else {
              itemLists[ii]["select"] = true;
              // checkCount = checkCount + 1;
              // chooseLists.add(list);
            }
            itemLists[0]["select"] = false;
          }
        }
      }
    });
  }

  showAlertDialog(BuildContext context, lst) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        // var chkLst = [];

        print("CHECK LIST >> " + lst.toString());
        // setState(() {
        // Navigator.pop(context);
        // 0-0-0-0-0
        _send(lst);
        // });
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: Colors.blue.shade300),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0),
      // ),
      backgroundColor: Colors.white,
      content: Text(
        // "သတင်းပို့ (Report)",
        lan == "Zg"
            ? Rabbit.uni2zg("သတင်းပို့ (Report)")
            : "သတင်းပို့ (Report)",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // snackbarmethod(text) {
  //   _scaffoldkey.currentState.showSnackBar(new SnackBar(
  //     content: new Text(text),
  //     backgroundColor: Colors.blue.shade400,
  //     duration: Duration(seconds: 1),
  //   ));
  // }

  _send(chkLst) async {
    setState(() {
      // DateTime now = DateTime.now();
      // var curDT = new DateFormat.yMd().add_jm().format(now);
      // setState(() {
      // DateTime now = DateTime.now();
      // righttime = new DateFormat.yMd().add_jm().format(now);

      var curDT = convertDateTime();

      //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
      // });
      // if (phone == null || phone == '') {
      if (loc == null || loc == '') {
        // Employee e = Employee(phone, null, date, "Checked In", "", chkLst);
        // dbHelper.save(e);
        print("11 >> " + phone.toString());
        Employee e =
            Employee(null, null, curDT, "Checked In", "0", "[" + chkLst + "]");
        dbHelper.save(e);
        // DateTime now = DateTime.now();
        // var curDT = new DateFormat.yMd().add_jm().format(now);
        // var curDT = convertDateTime();
      } else {
        print("22>>>");
        // Employee e =
        //     Employee(null, loc, curDT, "Checked In", "0", chkLst.toString());
        Employee e =
            Employee(null, loc, curDT, "Checked In", "0", "[" + chkLst + "]");
        dbHelper.save(e);
      }

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => TabsPage(
      //               openTab: 2,
      //             )));
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/list', (Route<dynamic> route) => false);
      // } else {
      //   print("PHONEEEE >>> " + phone.toString());
      //   if (loc == null || loc == '') {
      //     // Employee e = Employee(phone, null, date, "Checked In", "", chkLst);
      //     // dbHelper.save(e);
      //     print("11 >> " + phone.toString());
      //     // Employee e = Employee(null, null, curDT, "Checked In", "0", chkLst);
      //     // dbHelper.save(e);
      //     Employee e = Employee(null, null, curDT, "Checked In", "0", chkLst);
      //     dbHelper.save(e);
      //     // DateTime now = DateTime.now();
      //     // var curDT = new DateFormat.yMd().add_jm().format(now);
      //     // var curDT = convertDateTime();
      //   } else {
      //     print("22");
      //     // String lst = "$chkLst";
      //     print(int.parse(phone).toString() +
      //         loc +
      //         curDT +
      //         "Checked In" +
      //         "0" +
      //         "'$chkLst'");
      //     var ph = phone.toString().substring(1, 3);
      //     // var lst =
      //     //     chkLst.toString().substring(1, chkLst.toString().length - 1);
      //     // Employee e = Employee(, loc, curDT, "Checked In", "0", "Auto");
      //     // dbHelper.save(e);

      //     Employee e1 = Employee(null, loc, curDT, "Checked In", "0", chkLst);
      //     dbHelper.save(e1);
      //   }
      //   // Navigator.pop(context);
      //   // Navigator.pop(context);
      //   // Navigator.push(
      //   //     context,
      //   //     MaterialPageRoute(
      //   //         builder: (context) => TabsPage(
      //   //               openTab: 1,
      //   //             )));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // _text1.text = checkCount.toString();
    // final totalMark = new TextField(
    //   controller: _text1,
    //   decoration: InputDecoration(
    //     labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
    //     hasFloatingPlaceholder: true,
    //     labelStyle: (checklang == "Eng")
    //         ? TextStyle(
    //             fontSize: 17,
    //             color: Colors.black,
    //             height: 0,
    //             fontWeight: FontWeight.w300)
    //         : TextStyle(fontSize: 16, color: Colors.black, height: 0),
    //     enabled: false,
    //   ),
    // );
    // final location = new TextField(
    //   controller: _text2,
    //   decoration: InputDecoration(
    //     labelText: checklang == "Eng" ? textEng[2] : textMyan[2],
    //     hasFloatingPlaceholder: true,
    //     labelStyle: (checklang == "Eng")
    //         ? TextStyle(
    //             fontSize: 17,
    //             color: Colors.black,
    //             height: 0,
    //             fontWeight: FontWeight.w300)
    //         : TextStyle(fontSize: 16, color: Colors.black, height: 0),
    //   ),
    // );
    // final phonenumber = new TextField(
    //   controller: _text3,
    //   decoration: InputDecoration(
    //     labelText: checklang == "Eng" ? textEng[3] : textMyan[3],
    //     hasFloatingPlaceholder: true,
    //     labelStyle: (checklang == "Eng")
    //         ? TextStyle(
    //             fontSize: 17,
    //             color: Colors.black,
    //             height: 0,
    //             fontWeight: FontWeight.w300)
    //         : TextStyle(fontSize: 16, color: Colors.black, height: 0),
    //   ),
    // );

    final reportbutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () async {
        var lst = '';
        for (var ii = 0; ii < itemLists.length; ii++) {
          if (itemLists[ii]["select"] == true) {
            // chkLst.add(1);
            if (lst == '') {
              lst += "1";
            } else {
              lst += "-1";
            }
          } else {
            // chkLst.add(0);
            if (lst == '') {
              lst += "0";
            } else {
              lst += "-0";
            }
          }
        }
        if (lst == "0-0-0-0-0") {
          snackbarmethod1("Require to choose condition.");
        } else {
          showAlertDialog(context, lst);
        }

        // print(_text1.text);
        // print(_text2.text);
        // print(_text3.text);
        // if (v1 == true) {
        //   setState(() {
        //     v4 = "True";
        //   });
        // } else if (v2 == true) {
        //   setState(() {
        //     v4 = "False";
        //   });
        // } else if (v3 == true) {
        //   v4 = "Pending";
        // }
        // print(v4);
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Container(
        // width: 150.0,
        height: 38.0,
        child: Center(
            // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
            child: Text(
                // checklang == "Eng" ? textEng[6] : textMyan[6],
                lan == "Zg" ? Rabbit.uni2zg(textMyan[6]) : textMyan[6],
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          // checklang == "Eng" ? textEng[1] : textMyan[1],
          lan == "Zg"
              ? Rabbit.uni2zg("သတင်းပို့ (Report)")
              : "သတင်းပို့ (Report)",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18.0,
            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 0.0, right: 20.0, bottom: 0.0, top: 0.0),
                      child: loc == null
                          ? Container()
                          : Text(
                              // "တည်နေရာ (Location)",
                              lan == "Zg"
                                  ? Rabbit.uni2zg("တည်နေရာ (Location)")
                                  : "တည်နေရာ (Location)",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily:
                                      lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0, top: 20.0),
                      child: loc == null
                          ? Container()
                          : Text(
                              // "Latitude: " + showLat,
                              showLat + ", " + showLong,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 17),
                            ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Container(
                //       padding: EdgeInsets.only(
                //           left: 20.0, right: 20.0, bottom: 0.0, top: 20.0),
                //       child: loc == null
                //           ? Container()
                //           : Text(
                //               "Longitude: " + showLong,
                //               overflow: TextOverflow.ellipsis,
                //               style: TextStyle(fontSize: 17),
                //             ),
                //     ),
                //   ],
                // ),
              ],
            ),
            new Container(
                child: Row(
              children: <Widget>[
                Text(
                  // "ရောဂါလက္ခဏာနှင့်သွားလာမူများ",
                  lan == "Zg"
                      ? Rabbit.uni2zg("အခြေအနေ (Condition)")
                      : "အခြေအနေ (Condition)",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                  ),
                ),
                Spacer(),

                // // Padding(
                // //   padding: const EdgeInsets.only(right: 25.0),
                // //   child: checkCount == 0
                // //       ? Container()
                // //       : Text(
                // //           "[ $checkCount ]",
                // //           style: TextStyle(
                // //               fontSize: 18,
                // //               fontWeight: FontWeight.bold,
                // //               color: Colors.blue),
                // //         ),
                // // ),
              ],
            )),
            SizedBox(
              height: 7,
            ),
            Expanded(
              // child: Padding(
              // padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: new ListView.builder(
                  itemCount: itemLists.length,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            _selectChange(itemLists[i]);
                            // itemLists[0]["select"].toString() == "true"
                            //     ? a = 1
                            //     : a = 0;
                            // b = itemLists[1]["select"].toString() == "true"
                            //     ? b = 1
                            //     : b = 0;
                            // c = itemLists[2]["select"].toString() == "true"
                            //     ? c = 1
                            //     : c = 0;
                            // d = itemLists[3]["select"].toString() == "true"
                            //     ? d = 1
                            //     : d = 0;
                            // e = itemLists[4]["select"].toString() == "true"
                            //     ? e = 1
                            //     : e = 0;
                            // haha = '$a' +
                            //     ',' +
                            //     '$b' +
                            //     ',' +
                            //     '$c' +
                            //     ',' +
                            //     '$d' +
                            //     ',' +
                            //     '$e';
                            // print(haha);
                            // setState(() {});
                            // itemLists[i]["select"] = value;
                          },
                        );
                      },
                      child: new ListTile(
                        title: new Row(
                          children: <Widget>[
                            new Expanded(
                                child: new Text(
                              // itemLists[i]["title"],
                              lan == "Zg"
                                  ? Rabbit.uni2zg(itemLists[i]["title"])
                                  : itemLists[i]["title"],
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.blueGrey,
                                ),
                                child: new Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.blue,
                                  hoverColor: Colors.pink,
                                  value: itemLists[i]["select"],
                                  onChanged: (bool value) {
                                    _selectChange(itemLists[i]);
                                    // a = itemLists[0]["select"].toString() ==
                                    //         "true"
                                    //     ? a = 1
                                    //     : a = 0;
                                    // b = itemLists[1]["select"].toString() ==
                                    //         "true"
                                    //     ? b = 1
                                    //     : b = 0;
                                    // c = itemLists[2]["select"].toString() ==
                                    //         "true"
                                    //     ? c = 1
                                    //     : c = 0;
                                    // d = itemLists[3]["select"].toString() ==
                                    //         "true"
                                    //     ? d = 1
                                    //     : d = 0;
                                    // e = itemLists[4]["select"].toString() ==
                                    //         "true"
                                    //     ? e = 1
                                    //     : e = 0;
                                    // haha = '$a' +
                                    //     ',' +
                                    //     '$b' +
                                    //     ',' +
                                    //     '$c' +
                                    //     ',' +
                                    //     '$d' +
                                    //     ',' +
                                    //     '$e';
                                    // print(haha);
                                    // setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              // ),
            ),

            // Expanded(
            //   child: Column(
            //     children: <Widget>[
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Container(
            //             padding: EdgeInsets.only(
            //                 left: 0.0, right: 20.0, bottom: 0.0, top: 20.0),
            //             child: loc == null
            //                 ? Container()
            //                 : Text(
            //                     // "တည်နေရာ (Location)",
            //                     lan == "Zg"
            //                         ? Rabbit.uni2zg("တည်နေရာ (Location)")
            //                         : "တည်နေရာ (Location)",
            //                     textAlign: TextAlign.left,
            //                     style: TextStyle(
            //                         fontFamily:
            //                             lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
            //                         fontSize: 18.0,
            //                         fontWeight: FontWeight.w500),
            //                   ),
            //           ),
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Container(
            //             padding: EdgeInsets.only(
            //                 left: 20.0, right: 20.0, bottom: 0.0, top: 20.0),
            //             child: loc == null
            //                 ? Container()
            //                 : Text(
            //                     // "Latitude: " + showLat,
            //                     showLat + ", " + showLong,
            //                     overflow: TextOverflow.ellipsis,
            //                     style: TextStyle(fontSize: 17),
            //                   ),
            //           ),
            //         ],
            //       ),
            //       // Row(
            //       //   mainAxisAlignment: MainAxisAlignment.start,
            //       //   crossAxisAlignment: CrossAxisAlignment.start,
            //       //   children: <Widget>[
            //       //     Container(
            //       //       padding: EdgeInsets.only(
            //       //           left: 20.0, right: 20.0, bottom: 0.0, top: 20.0),
            //       //       child: loc == null
            //       //           ? Container()
            //       //           : Text(
            //       //               "Longitude: " + showLong,
            //       //               overflow: TextOverflow.ellipsis,
            //       //               style: TextStyle(fontSize: 17),
            //       //             ),
            //       //     ),
            //       //   ],
            //       // ),
            //     ],
            //   ),
            // )

            // Expanded(
            //   child:
            //   Container(
            //     padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
            //     height: 320,
            //     child: Card(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //       elevation: 3.0,
            //       child: ListView(
            //         padding: EdgeInsets.all(2.0),
            //         children: <Widget>[
            //           SizedBox(height: 10.0,),
            //           Center(
            //             child: new Container(
            //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
            //               child: totalMark,
            //             ),
            //           ),
            //           SizedBox(height: 10.0,),
            //           Center(
            //             child: new Container(
            //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
            //               child: location,
            //             ),
            //           ),
            //           SizedBox(height: 10.0,),
            //           Center(
            //             child: new Container(
            //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
            //               child: phonenumber,
            //             ),
            //           ),
            //           // Center(
            //           //   child: new Container(
            //           //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
            //           //     child: question,
            //           //   ),
            //           // ),
            //           SizedBox(height: 20.0,),
            //           // Row(
            //           //   children: <Widget>[
            //               // new Container(
            //               //   padding: EdgeInsets.only(left: 26.0),
            //               //   child: cancelbutton,
            //               // ),
            //               new Container(
            //                 padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
            //                 child: reportbutton,
            //               ),
            //               SizedBox(height: 15.0,),
            //           //   ],
            //           // ),

            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 60.0,
            // // ),
            // FloatingActionButton(
            //   child: Icon(Icons.arrow_forward_ios),
            //   backgroundColor: Colors.blue,
            //   onPressed: () {
            //     // print("CL >> " + srLst.toString());
            //     var route = new MaterialPageRoute(
            //         builder: (BuildContextcontext) => new Reporting(
            //               value: checkCount,
            //             ));
            //     Navigator.of(context).push(route);
            //   },
            //   // shape: RoundedRectangleBorder(
            //   //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
            //   elevation: 10.0,
            // ),
          ],
        ),
      ),
      // // // floatingActionButton: Align(
      // // //   alignment: Alignment.bottomCenter,
      // // //   child: FloatingActionButton(
      // // //     backgroundColor: Colors.blue,
      // // //     onPressed: () {
      // // //       // print("CL >> " + srLst.toString());
      // // //       var route = new MaterialPageRoute(
      // // //           builder: (BuildContextcontext) => new Reporting(
      // // //                 value: checkCount,
      // // //               ));
      // // //       Navigator.of(context).push(route);
      // // //     },
      // // //     tooltip: 'Increment',
      // // //     // child: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      // // //     child: Icon(Icons.arrow_forward_ios),
      // // //     // shape: RoundedRectangleBorder(
      // // //     //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
      // // //     elevation: 10.0,
      // // //   ),
      // // // ),
      persistentFooterButtons: <Widget>[
        Form(
          // key: formKey,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Padding(
                              padding: EdgeInsets.only(left: 0.0, right: 0.0),
                              child: reportbutton
                              // RaisedButton(
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(5.0),
                              //   ),
                              //   color: Colors.blue,
                              //   onPressed: () async {},
                              //   child: Text(
                              //     checklang == "Eng" ? textEng[0] : textMyan[0],
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.w300),
                              //   ),
                              // ),
                              ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
      // child: FloatingActionButton(
      //   backgroundColor: Colors.blue,
      //   onPressed: () {
      //     var route = new MaterialPageRoute(
      //                           builder: (BuildContextcontext) =>
      //                               new Reposting(value: 3,));
      //                       Navigator.of(context).push(route);
      //     // print("CL >> " + srLst.toString());
      //   },
      //   tooltip: 'Increment',
      //   // child: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      //   child: Icon(Icons.arrow_forward_ios),
      //   // shape: RoundedRectangleBorder(
      //   //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //   elevation: 10.0,
      // ),
      // )
      // ],
    );
  }
}
