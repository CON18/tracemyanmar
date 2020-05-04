import 'dart:async';
import 'dart:convert';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  final String userid;
  final String username;

  ViewProfile({Key key, this.userid, this.username}) : super(key: key);
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String qrText;
  String checklang = '';
  List textMyan = [
    "ကိုယ်ရေးအချက်အလက် (Profile)",
  ];
  List textEng = [
    "Profile",
  ];

  var _start;
  Timer timer;
  var dbHelper;

  var lan;

  @override
  void initState() {
    super.initState();
    checkLanguage();
    _genQR();
    someMethod();
    // dbHelper = DBHelper();
    // _checkAndstartTrack();
    //    String text = 'ယေဓမ္မာ ဟေတုပ္ပဘဝါ တေသံ ဟေတုံ တထာဂတော အာဟ တေသဉ္စ ယောနိရောဓေါ ဧဝံ ဝါဒီ မဟာသမဏော။';
    // String zawgyiText = Rabbit.uni2zg(text);
    // String unicodeText = Rabbit.zg2uni(zawgyiText);
    analyst();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'ProfileView_Request',
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

  _genQR() {
    var param;
    if (widget.username == "" || widget.username == null) {
      param = [
        {"name": "", "phone": widget.userid}
      ];
      qrText = jsonEncode(param);
    } else {
      param = [
        {"name": widget.username, "phone": widget.userid}
      ];
      qrText = jsonEncode(param);
    }

    // print("QR TEXT >> " + json);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        // key: _scaffoldKey,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        // title: Text(
        //   "Edit Profile",
        //   style: TextStyle(
        //       fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        // ),
        backgroundColor: Colors.blue.withOpacity(0.8),
        elevation: 0.0,
        // title: Text(
        //   checklang == "Eng" ? textEng[0] : textMyan[0],
        //   style: TextStyle(
        //       fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        // ),
        title: Text(
          // checklang == "Eng" ? textEng[0] : textMyan[0],
          lan == "Zg" ? Rabbit.uni2zg(textMyan[0]) : textMyan[0],
          style: TextStyle(
              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
              fontWeight: FontWeight.w300,
              fontSize: 18.0),
        ),
        centerTitle: true,
        // actions: <Widget>[
        //   GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => NewProfile(
        //                   userid: widget.userid, username: widget.username)));
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 18.0),
        //       child: Icon(
        //         Icons.edit,
        //         color: Colors.white,
        //       ),
        //     ),
        //   )
        // ]
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                  color: Colors.blue.withOpacity(0.8),
                  // height: 250.0,
                  height: MediaQuery.of(context).size.height * 0.20),
              // height: orientation == Orientation.portrait ? 100.0 : 200.0,
              // clipper: getClipper(),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Flexible(
                  //   flex: 1,
                  // child: Container(
                  // child:

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        // padding: const EdgeInsets.only(top: 17.0, left: 120.0),
                        padding: const EdgeInsets.only(
                            top: 80.0, left: 0.0, bottom: 0.0),
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
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: GestureDetector(
                                onTap: () {
                                  print("YOUR CLICK PRO IMG >>");
                                },
                                child:
                                    // CircleAvatar(
                                    //     backgroundImage:
                                    //         AssetImage("images/choose_img1.png")),
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // border: Border.all(
                                    //   color: Colors.lightBlueAccent,
                                    //   width: 3,
                                    // ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(0, 5),
                                          blurRadius: 25)
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/user-icon.png")
                                      // backgroundImage:
                                      //     AssetImage("images/default.jpg")
                                      ),
                                ),
                                // : CircleAvatar(
                                //     backgroundImage: NetworkImage(
                                //       // 'http://unitutor.azurewebsites.net/regphoto/image/' +
                                //       'http://hcm.mitcloud.com/photoUpload/photo/' +
                                //           widget.proImg,
                                //     ),
                                //   ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                    // ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 0.0, bottom: 0.0),
                        child: Column(
                          children: <Widget>[
                            (widget.username == "" || widget.username == null)
                                ? Container()
                                : Text(
                                    lan == "Zg"
                                        ? Rabbit.uni2zg(widget.username)
                                        : widget.username,
                                    // "Chit Oo Naung",
                                    // "ချစ်ဦးနောင်",
                                    style: TextStyle(
                                        fontFamily: lan == "Zg"
                                            ? "Zawgyi"
                                            : "Pyidaungsu",
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                              height: 5.0,
                            ),
                            (widget.userid == "" || widget.userid == null)
                                ? Container()
                                : Text(
                                    lan == "Zg"
                                        ? Rabbit.uni2zg(widget.userid)
                                        : widget.userid,
                                    // "+959966680686",
                                    // "chitoonaunganalyst661@gmail.com",
                                    style: TextStyle(
                                      fontFamily:
                                          lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                            // SizedBox(
                            //   height: 5.0,
                            // ),
                            // Text(
                            //   "9/mkn(naing) 123456",
                            //   // "+959966680686",
                            //   // "chitoonaunganalyst661@gmail.com",
                            //   style: TextStyle(
                            //     fontFamily: "Pyidaungsu",
                            //     fontSize: 16.0,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: QrImage(
                                data: qrText.toString(),
                                size: 200,
                                // gapless: true,
                                // foregroundColor: Colors.green,
                                foregroundColor: Colors.blue,
                                backgroundColor: Colors.white38,
                                errorCorrectionLevel: QrErrorCorrectLevel.H,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                  // Container(
                  //   color: Colors.red,
                  //   child: Text("CHIT OO NAUNG"),
                  // ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
