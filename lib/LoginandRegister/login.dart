import 'dart:async';
import 'dart:convert';

import 'package:TraceMyanmar/Drawer/Profile/new_profile.dart';
import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/version_history.dart';
import 'package:crypto/crypto.dart';
import 'package:device_id/device_id.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:TraceMyanmar/LoginandRegister/register.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final mynameController = TextEditingController();
  final myController = TextEditingController();
  bool _validate = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var ftoken;
  String phoneNo = "";
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  var data;
  bool isLoading = false;
  String checklang = '';
  List textMyan = ["စီစစ်ခြင်း (Verify)", "ကုဒ်ရယူပါ"];
  List textEng = ["Verify", "Next"];
  var _start;
  String checkfont = '';
  String lan = '';
  Timer timer;
  var dbHelper;
  var deviceId = '';
  checkLanguage() async {
    // final prefs = await SharedPreferences.getInstance();
    // checklang = prefs.getString("Lang");
    // if (checklang == "" || checklang == null || checklang.length == 0) {
    //   checklang = "Eng";
    // } else {
    //   checklang = checklang;
    // }
    checklang = "Myanmar";
    // dbHelper = DBHelper();
    // _checkAndstartTrack();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    checkLanguage();
    getlocation();
    someMethod();
    analyst();
  }

  _getDeviceId() async {
    var did = await DeviceId.getID;

    setState(() {
      deviceId = did;
      print(deviceId);
    });
  }

  analyst() async {
    await analytics.logEvent(
      name: 'Login_Request',
      parameters: <String, dynamic>{
        'string': myController.text,
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

  // တစ်ခါသုံး စကားဝှက်
  // အတည်ပြုပါ
  // ရှေ့ဆက်

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
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

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 2),
    ));
  }

  getlocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Thaw location $position");
  }

  _goNext(sKey, sId) async {
    // var key = utf8.encode('sss@2020');
    // var bytes = utf8.encode(sKey);

    // var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    // var digest = hmacSha256.convert(bytes);
    // print("HMAC digest as bytes: ${digest.bytes}");
    // print("HMAC digest as hex string: $digest");

    String url =
        // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/startregister";
        // "http://sawsawsharservice.azurewebsites.net/module001/serviceRegisterTraceMyanmar/startregister";
        // "https://sssuat.azurewebsites.net/module001/serviceRegisterTraceMyanmar/startregister";
        // "http://uatsssverify.azurewebsites.net/module001/serviceRegisterTraceMyanmar/startregister";
        url2 + "/module001/serviceRegisterTraceMyanmar/startregister";
    var body = jsonEncode({
      "uuid": deviceId,
      "phoneno": myController.text.toString(),
      "sessionid": sId,
      "hash": sKey,
      "skipexisting": "true"
    });
    // print("bdy >> " + body.toString());
    // snackbarmethod1("BODY >> " + body.toString());
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) async {
      print("Response >> " + res.toString());
      var result = json.decode(utf8.decode(res.bodyBytes));
      var resStatus = result['code'];
      var succ = result['desc'];
      // var err = result['error'];
      print("RES STATUS >> " + resStatus.toString());
      print("RES DESC >> " + succ.toString());

      if (resStatus == '0000') {
        setState(() {
          isLoading = false;
        });

        final prefs = await SharedPreferences.getInstance();
        final key1 = 'FCMToken';
        final fcmtoken = ftoken;
        prefs.setString(key1, fcmtoken);
        print('FToken $ftoken');

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register(
                      phone: myController.text,
                      sId: sId,
                      hash: sKey,
                      deviceId: deviceId,
                    )));
      } else if (resStatus == "7777") {
        final prefs = await SharedPreferences.getInstance();
        final key1 = 'FCMToken';
        final fcmtoken = ftoken;
        prefs.setString(key1, fcmtoken);
        print('FToken $ftoken');
        final key2 = 'UserId';
        // final UserId = '${deviceId}';
        prefs.setString(key2, myController.text);

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil('/profile', (Route<dynamic> route) => false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NewProfile(userid: myController.text
                    // , username: ""
                    )));
      } else {
        setState(() {
          isLoading = false;
        });
        this.alertmsg = succ;
        this.snackbarmethod();
      }
      // if (succ == "OK") {
      //   // this.alertmsg = resStatus;
      //   // this.snackbarmethod();
      //   // Future.delayed(const Duration(milliseconds: 2000), () {
      //   final prefs = await SharedPreferences.getInstance();
      //   final key1 = 'FCMToken';
      //   final fcmtoken = ftoken;
      //   prefs.setString(key1, fcmtoken);
      //   print('FToken $ftoken');
      //   final key2 = 'UserId';
      //   // final UserId = '${deviceId}';
      //   prefs.setString(key2, myController.text);
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => TabsPage(
      //                 openTab: 0,
      //               )));
      // } else {
      //   final prefs = await SharedPreferences.getInstance();
      //   final key1 = 'FCMToken';
      //   final fcmtoken = ftoken;
      //   prefs.setString(key1, fcmtoken);
      //   print('FToken $ftoken');

      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               Register(value: myController.text)));
      // }
    }).catchError((Object error) async {
      print("ON ERROR >>");
      setState(() {
        isLoading = false;
      });
    });
  }

  convertDateTime24hrs() {
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
    var time = new DateFormat.Hms().format(now);

    var dt = yr + "-" + mn + "-" + dy + " " + time;
    return dt;
  }

  @override
  Widget build(BuildContext context) {
    var loginbody = SingleChildScrollView(
      child: new Column(
        key: _formKey,
        children: <Widget>[
          // SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          //           child: Container(
          //       width: double.infinity,
          //       child: Padding(
          //         padding: const EdgeInsets.fromLTRB(20.0, 180.0, 20.0, 0.0),
          //         child: TextField(
          //           controller: mynameController,
          //           obscureText: false,
          //           enabled: true,
          //           style: TextStyle(color: Colors.black),
          //           keyboardType: TextInputType.text,
          //           // onChanged: (text) {
          //           //   // _doSomething(text);
          //           // },
          //           decoration: InputDecoration(
          //             prefixIcon: Icon(Icons.account_box),
          //             contentPadding:
          //                 new EdgeInsets.symmetric(vertical: 9.0, horizontal: 25.0),
          //             hintText: "အမည် (Name)",
          //             errorText: _validate ? "Please Fill Name" : null,
          //             errorStyle: TextStyle(
          //                 fontSize: 14,
          //                 color: Colors.red,
          //                 fontWeight: FontWeight.w400,
          //                 wordSpacing: 1),
          //             hintStyle: TextStyle(
          //                 fontSize: 15,
          //                 color: Color.fromARGB(200, 90, 90, 90),
          //                 fontWeight: FontWeight.w100),
          //             fillColor: Colors.black,
          //             border: OutlineInputBorder(
          //               borderSide: const BorderSide(
          //                   color: Color.fromRGBO(40, 103, 178, 1), width: 1),
          //               borderRadius: BorderRadius.circular(15.0),
          //             ),
          //           ),
          //         ),
          //       )),
          // ),
          Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 250.0, 20.0, 0.0),
                child: TextField(
                  controller: myController,
                  obscureText: false,
                  enabled: true,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.phone,
                  // onChanged: (text) {
                  //   // _doSomething(text);
                  // },
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.phone_android),
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.lightBlue,
                    ),
                    // contentPadding: new EdgeInsets.symmetric(
                    //     vertical: 9.0, horizontal: 25.0),
                    contentPadding: EdgeInsets.only(left: 0, top: 2),
                    hintText: lan == "Zg"
                        ? Rabbit.uni2zg(
                            // "မိုဘိုင်းဖုန်းနံပါတ် ( Mobile Phone Number)")
                            "မိုဘိုင်းဖုန်းနံပါတ် (Mobile Number)")
                        // : "မိုဘိုင်းဖုန်းနံပါတ် ( Mobile Phone Number)",
                        : "မိုဘိုင်းဖုန်းနံပါတ် (Mobile Number)",
                    // "မိုဘိုင်းဖုန်းနံပါတ် ( Mobile Phone Number)",
                    errorText: _validate ? "Please Fill Mobile Number" : null,
                    errorStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        wordSpacing: 1),
                    hintStyle: TextStyle(
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                        fontSize: 13,
                        color: Color.fromARGB(200, 90, 90, 90),
                        fontWeight: FontWeight.w100),
                    fillColor: Colors.black,
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.lightBlue[100], width: 1.0)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.lightBlue[100], width: 1.0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(
                            color: Colors.lightBlue[100], width: 1.0)),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(40, 103, 178, 1), width: 1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.47,
              child: RaisedButton(
                // shape: new CircleBorder(),
                elevation: 5,

                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  _firebaseMessaging.subscribeToTopic('hello');
                  ftoken = _firebaseMessaging
                      .getToken()
                      .then((token) => ftoken = token);
                  setState(() {
                    print(myController.text);
                    myController.text.isEmpty
                        ? _validate = true
                        : _validate = false;

                    phoneNo = myController.text;
                    //   if (phoneNo.indexOf("7") == 0 && phoneNo.length == 9) {
                    //     phoneNo = '+959' + this.phoneNo;
                    //   } else if (phoneNo.indexOf("9") == 0 &&
                    //       phoneNo.length == 9) {
                    //     phoneNo = '+959' + phoneNo;
                    //   } else if (phoneNo.indexOf("+") != 0 &&
                    //       phoneNo.indexOf("7") != 0 &&
                    //       phoneNo.indexOf("9") != 0 &&
                    //       (phoneNo.length == 8 ||
                    //           phoneNo.length == 9 ||
                    //           phoneNo.length == 7)) {
                    //     this.phoneNo = '+959' + this.phoneNo;
                    //   } else if (phoneNo.indexOf("09") == 0 &&
                    //       (phoneNo.length == 10 ||
                    //           phoneNo.length == 11 ||
                    //           phoneNo.length == 9)) {
                    //     phoneNo = '+959' + phoneNo.substring(2);
                    //   } else if (phoneNo.indexOf("959") == 0 &&
                    //       (phoneNo.length == 11 ||
                    //           phoneNo.length == 12 ||
                    //           phoneNo.length == 10)) {
                    //     phoneNo = '+959' + phoneNo.substring(3);
                    //   }

                    if (phoneNo.startsWith('+959')) {
                      print('Your text is phone!!');
                      // showFloatingFlushbar(context, 'LOADING', 'Please wait...', 2);
                      // verifyPhone(value);
                    } else if (phoneNo.startsWith('09')) {
                      // showFloatingFlushbar(context, 'LOADING', 'Please wait...', 2);
                      phoneNo = '+959' + phoneNo.substring(2, phoneNo.length);
                      print("PHONE CH >> " + phoneNo);
                      // verifyPhone(finPh);
                    } else if (phoneNo.length == 7 || phoneNo.length == 9) {
                      phoneNo = '+959' + phoneNo;
                      print("PHONE CH >> " + phoneNo);
                    } else {
                      print('Invalid Email/ Phone');
                      // showErrorFloatingFlushbar(
                      //     context, 'Error', 'Invalid Email/ Phone!', 2);
                    }
                  });
                  myController.text = phoneNo;
                  if (myController.text == "" || myController.text == null) {
                    setState(() {
                      isLoading = false;
                    });
                  } else {
// For 1, Change > https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/checkRegister
// For 2, Change > https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/register

                    // String url =
                    // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/checkRegister";
                    // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/checkRegisterV1";

                    // "http://connect.nirvasoft.com/apx/module001/serviceOTP/sendmsg";

                    // var body = jsonEncode({
                    //   "phone": myController.text.toString(),
                    //   "text": "as Your One Time Password.",
                    //   "appname": "TraceMyanmar",
                    //   "domain": "domainname",
                    //   "otpcode": "0"
                    // });
                    // var body = jsonEncode({
                    //   "phoneNo": myController.text.toString(),
                    //   "uuid": deviceId
                    // });
                    final prefs = await SharedPreferences.getInstance();
                    var sKey = prefs.getString("getsessionkey") ?? "";
                    var sId = prefs.getString("getsessionid") ?? "";
                    deviceId = await DeviceId.getID;
                    if (sKey == "" || sId == "") {
                      print("111 >>>");
                      final prefs = await SharedPreferences.getInstance();
                      var fcmToken = prefs.getString("fcmToken") ?? "";
                      if (fcmToken == "") {
                        _firebaseMessaging.getToken().then((token) async {
                          print("TOKEN >> " + token.toString());
                          // token = token;
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("fcmToken", token);
                          fcmToken = token;
                        });
                      }
                      String url =
                          // "http://uatsssverify.azurewebsites.net/module001/serviceRegisterTraceMyanmar/getsession";
                          url2 +
                              "/module001/serviceRegisterTraceMyanmar/getnewsession";
                      // "http://52.187.13.89:8080/tracemyanmar/module001/service004/saveUser";
                      var body;
                      // snackbarmethod1("URL >> $url");
                      var ltime = convertDateTime24hrs();
                      body = jsonEncode({
                        "uuid": deviceId,
                        "fcmtoken": fcmToken,
                        "localtime": ltime
                      });

                      // print("BODY >> " + body.toString());
                      http.post(url, body: body, headers: {
                        "Accept": "application/json",
                        "content-type": "application/json"
                      }).then((dynamic res) async {
                        print("Response >> " + res.toString());
                        var result = json.decode(utf8.decode(res.bodyBytes));
                        var resStatus = result['desc'];
                        var sKey = result['key'];
                        var sId = result['sessionid'];
                        print("CODE >> " + resStatus.toString());
                        if (resStatus == 'Success') {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("getsessionkey", sKey);
                          prefs.setString("getsessionid", sId);
                          _goNext(sKey, sId);
                        } else {}
                      });
                    } else {
                      _goNext(sKey, sId);
                    }
                  }

                  //   http.Response response =
                  //       await http.post(url, headers: headers, body: json);
                  //   int statusCode = response.statusCode;
                  //   if (statusCode == 200) {
                  //     String body = response.body;
                  //     print(body);
                  //     data = jsonDecode(body);
                  //     if (data["code"] == "0000") {
                  //       setState(() {
                  //         isLoading = false;
                  //       });
                  //       final prefs = await SharedPreferences.getInstance();
                  //       final key1 = 'FCMToken';
                  //       final fcmtoken = ftoken;
                  //       prefs.setString(key1, fcmtoken);
                  //       print('FToken $ftoken');
                  //       this.alertmsg = data['desc'];
                  //       this.snackbarmethod();
                  //       Future.delayed(const Duration(milliseconds: 2000), () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     Register(value: myController.text)));
                  //       });
                  //     } else if (data["code"] == "0001") {
                  //       setState(() {
                  //         isLoading = false;
                  //       });
                  //       final prefs = await SharedPreferences.getInstance();
                  //       final key1 = 'FCMToken';
                  //       final fcmtoken = ftoken;
                  //       prefs.setString(key1, fcmtoken);
                  //       print('FToken $ftoken');
                  //       final key2 = 'UserId';
                  //       final UserId = myController.text;
                  //       prefs.setString(key2, UserId);
                  //       this.alertmsg = data['desc'];
                  //       this.snackbarmethod();
                  //       Future.delayed(const Duration(milliseconds: 2000), () {
                  //         // Navigator.push(
                  //         //     context,
                  //         //     MaterialPageRoute(
                  //         //         builder: (context) =>
                  //         //             Sqlite(value: myController.text)));
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => TabsPage(
                  //                 openTab: 0,
                  //               ),
                  //             ));
                  //       });
                  //     } else {
                  //       setState(() {
                  //         isLoading = false;
                  //       });
                  //       this.alertmsg = data['desc'];
                  //       this.snackbarmethod();
                  //     }
                  //   } else {
                  //     print("Connection Fail");
                  //     setState(() {
                  //       this.alertmsg = data['desc'];
                  //       this.snackbarmethod();
                  //       // isLoading = false;
                  //     });
                  //   }
                  // }
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // color: Colors.blue,
                textColor: Colors.white,
                child: Text(
                  lan == "Zg"
                      ? Rabbit.uni2zg("ရှေ့ဆက် (Next)")
                      : "ရှေ့ဆက် (Next)",
                  // "ရှေ့ဆက် (Next)",
                  style: TextStyle(
                      fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                // Container(
                //   width: 55.0,
                //   height: 55.0,

                //   //   child: Center(
                //   //       child: Text(checklang=="Eng" ? textEng[0] : textMyan[0],
                //   //           style: TextStyle(
                //   //             fontSize: 17,
                //   //             color: Colors.white,
                //   //             fontWeight: FontWeight.w300,
                //   //           ))),
                //   child: Icon(
                //     Icons.keyboard_arrow_right,
                //     color: Colors.white,
                //     size: 40,
                //   ),

                //   // child: Image.asset('assets/circle.png'),
                // ),
              ),
            ),
          )
        ],
      ),
    );
    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          loginbody,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                ),
              ))
        ],
      ),
    );
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.blue,
          title: new Container(
            child: new Text(
              lan == "Zg" ? Rabbit.uni2zg(textEng[0]) : textEng[0],
              // checklang == "Eng" ? textEng[0] : textMyan[0],
              // 'စီစစ်ခြင်း (Verify)',
              style: TextStyle(
                  fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                  fontSize: 18.0,
                  color: Colors.white,
                  height: 1.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
        body: isLoading ? bodyProgress : loginbody);
  }
}
