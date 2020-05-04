import 'dart:convert';
import 'dart:async';

import 'package:TraceMyanmar/Drawer/Profile/new_profile.dart';
import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:TraceMyanmar/tabs.dart';
import 'package:flutter/material.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class Register extends StatefulWidget {
  final String phone;
  final String sId;
  final String hash;
  final String deviceId;

  Register({Key key, this.phone, this.sId, this.hash, this.deviceId})
      : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final myController = TextEditingController();
  var ftoken;
  final _formKey = new GlobalKey<FormState>();
  // final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  bool isLoading = false;
  String checklang = '';
  List textMyan = ["ဝင်မည်"];
  // List textMyan = [""];
  List textEng = ["Ok"];
  String checkfont = '';
  String lan = '';
  var _syncstart;
  var _start;

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 2),
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

  // var _start;
  // Timer timer;
  // var dbHelper;

  @override
  void initState() {
    super.initState();
    checkLanguage();
    someMethod();
    // dbHelper = DBHelper();
    // _checkAndstartTrack();
    analyst();
    // _checkTimer();
    // _checkAutoSync();
  }

// //-->>For sync timer
//   _checkAutoSync() async {
//     final prefs = await SharedPreferences.getInstance();
//     int val = prefs.getInt("autoSyncTimer") ?? 0;

//     if (val == 0) {
//       _syncstart = syncInterval;
//       countDownSaveForSync();
//     } else {
//       _syncstart = val.toString();
//       countDownSaveForSync();
//     }
//   }

//   countDownSaveForSync() {
//     print("START >> $_syncstart");
//     const oneSec = const Duration(seconds: 1);
//     syncTimer = Timer.periodic(
//       oneSec,
//       (Timer t) => setState(
//         () {
//           if (_syncstart == 0) {
//             // _getCurrentLocationForTrack();
//             // sendData();
//             // _syncList("1");
//             syncTimer.cancel();
//           } else {
//             _syncstart = int.parse(_syncstart.toString()) - 1;
//             savesyncTimer();
//             // print("Sec>>" + _start.toString());
//           }
//           // print("CD11 >> " + _syncstart.toString());
//         },
//       ),
//     );
//   }

//   savesyncTimer() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setInt("autoSyncTimer", _syncstart);
//   }

//   //-->>End for sync timer
//   //-->>For submitting timer
//   _checkTimer() async {
//     final prefs = await SharedPreferences.getInstance();
//     int val = prefs.getInt("timer") ?? 0;

//     if (val == 0) {
//       _start = startInterval;
//       countDownSave();
//     } else {
//       _start = val.toString();
//       countDownSave();
//     }
//   }

//   countDownSave() {
//     print("START >> $_start");
//     const oneSec = const Duration(seconds: 1);
//     submitTimer = Timer.periodic(
//       oneSec,
//       (Timer t) => setState(
//         () {
//           if (_start == 0) {
//             // _getCurrentLocationForTrack();
//             // sendData1();
//             submitTimer.cancel();
//           } else {
//             _start = int.parse(_start.toString()) - 1;
//             saveTimer();
//             // print("Sec>>" + _start.toString());
//           }

//           // if (_start == 10) {
//           //   _syncList("1");
//           // }
//           // print("CD >> " + _start.toString());
//         },
//       ),
//     );
//   }

//   saveTimer() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setInt("timer", _start);
//   }

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
  }

  // sendData1() async {
  //   // print("DATE >> $dt");
  //   // snackbarmethod1("Loading...");
  //   final prefs = await SharedPreferences.getInstance();
  //   var ph = prefs.getString('UserId');
  //   var setList = [];
  //   setList = await dbHelper.getEmployees();
  //   // setState(() {});
  //   var data = [];
  //   for (var i = 0; i < setList.length; i++) {
  //     // print("AAA >> ${setList[i].location}");
  //     if (setList[i].location == null || setList[i].location == "") {
  //     } else {
  //       if (setList[i].color.toString() == "0") {
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
  //           "duration": 1.00,
  //           "lat": double.parse(
  //               setList[i].location.toString().substring(0, index)),
  //           "lng": double.parse(
  //               setList[i].location.toString().substring(index + 1)),
  //           "source": "SSS",
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

  //   final url = 'https://api.mcf.org.mm/api/people_history/insertmany';
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
  //         setState(() {
  //           _start = startInterval;
  //           countDownSave();
  //         });

  //         // Navigator.pushReplacement(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //       builder: (context) => TabsPage(
  //         //         openTab: 1,
  //         //       ),
  //         //     ));
  //       } else {
  //         this.snackbarmethod1("Can not submit");
  //       }
  //     }).catchError((Object error) async {
  //       print("ON ERROR 222 >>");
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("errorLog", error);
  //       _start = startInterval;
  //       countDownSave();
  //     });
  //   }
  // }
  //-->>End for submitting timer

  analyst() async {
    await analytics.logEvent(
      name: 'OTP_Request',
      parameters: <String, dynamic>{
        'string': widget.phone,
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
    // submitTimer.cancel();
    // syncTimer.cancel();
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

  @override
  Widget build(BuildContext context) {
    var registerbody = SingleChildScrollView(
      child: new Column(
        key: _formKey,
        children: <Widget>[
          // Padding(
          //   // padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
          //   padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
          // child:
          // Container(
          //   child: Text(""),
          // ),
          Container(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(35.0, 240.0, 35.0, 0.0),
            child: TextField(
              controller: myController,
              obscureText: false,
              // enabled: isLoading==true ? false :true,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                // _doSomething(text);
              },
              decoration: InputDecoration(
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 9.0, horizontal: 25.0),
                // errorText:
                //     _validate ? checklang == "Eng" ? textEng[6] : textMyan[6] : null,
                hintText: lan == "Zg"
                    ? Rabbit.uni2zg("တစ်ခါသုံး စကားဝှက် (SMS OTP)")
                    : "တစ်ခါသုံး စကားဝှက် (SMS OTP)",
                // "တစ်ခါသုံး စကားဝှက် (SMS OTP)",
                hintStyle: TextStyle(
                    fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                    fontSize: 15,
                    color: Color.fromARGB(200, 90, 90, 90),
                    fontWeight: FontWeight.w100),
                errorStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 1),
                fillColor: Colors.black,
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide:
                        BorderSide(color: Colors.lightBlue[100], width: 1.0)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide:
                        BorderSide(color: Colors.lightBlue[100], width: 1.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide:
                        BorderSide(color: Colors.lightBlue[100], width: 1.0)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(40, 103, 178, 1), width: 1),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          )
              //   ),
              ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 20.0),
            child: Container(
              child: RaisedButton(
                // shape: new CircleBorder(),
                elevation: 5,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String url =
                      // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/register";
                      // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/register";
                      // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/verifyregister";
                      // "http://sawsawsharservice.azurewebsites.net/module001/serviceRegisterTraceMyanmar/verifyregister";
                      // "https://sssuat.azurewebsites.net/module001/serviceRegisterTraceMyanmar/verifyregister";
                      // "http://uatsssverify.azurewebsites.net/module001/serviceRegisterTraceMyanmar/verifyregister";
                      url2 +
                          "/module001/serviceRegisterTraceMyanmar/verifyregister";

                  // "http://connect.nirvasoft.com/apx/module001/serviceOTP/checkOTP";
                  // var body = jsonEncode({
                  //   "phone": widget.value,
                  //   "text": "Please add your text for message",
                  //   "appname": "TraceMyanmar",
                  //   "domain": "domainname",
                  //   "otpcode": myController.text
                  // });
                  // var body = jsonEncode(
                  //     {"phoneNo": widget.value, "otp": myController.text});

                  var body = jsonEncode({
                    "uuid": widget.deviceId,
                    "phoneno": widget.phone,
                    "otp": myController.text,
                    "sessionid": widget.sId,
                    "hash": widget.hash
                  });
                  // snackbarmethod1("BDY >> " + body.toString());
                  http.post(Uri.encodeFull(url), body: body, headers: {
                    "Accept": "application/json",
                    "content-type": "application/json"
                  }).then((dynamic res) async {
                    print("Response >> " + res.toString());
                    var result = json.decode(utf8.decode(res.bodyBytes));
                    var resStatus = result['code'];
                    var succ = result['desc'];
                    if (resStatus.toString() == "0000") {
                      final prefs = await SharedPreferences.getInstance();
                      final key1 = 'FCMToken';
                      final fcmtoken = ftoken;
                      prefs.setString(key1, fcmtoken);
                      print('FToken $ftoken');
                      final key2 = 'UserId';
                      final UserId = '${widget.phone}';
                      prefs.setString(key2, UserId);
                      this.alertmsg = succ;
                      // this.alertmsg = "Verified Successfully.";
                      this.snackbarmethod();
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Sqlite()));
                        // Navigator.pushNamedAndRemoveUntil(context, '/home');
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     '/home', (Route<dynamic> route) => false);

                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     '/profile', (Route<dynamic> route) => false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewProfile(
                                      userid: widget.phone,
                                      //  username: ""
                                    )));

                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => TabsPage(
                        //         openTab: 0,
                        //       ),
                        //     ));
                      });
                    } else {
                      this.alertmsg = "Incorrect OTP";
                      this.snackbarmethod();
                      setState(() {
                        isLoading = false;
                      });
                    }
                  });

                  // String url =
                  //     "http://52.187.13.89:8080/tracemyanmar/module001/serviceRegisterTraceMyanmar/register";
                  // Map<String, String> headers = {
                  //   "Content-type": "application/json"
                  // };
                  // String json = '{ "phoneNo": "' +
                  //     "${widget.value}" +
                  //     '","otp": "' +
                  //     myController.text +
                  //     '","token": "' +
                  //     '$ftoken' +
                  //     '"}';
                  // http.Response response =
                  //     await http.post(url, headers: headers, body: json);
                  // int statusCode = response.statusCode;
                  // if (statusCode == 200) {
                  //   String body = response.body;
                  //   print(body);
                  //   var data = jsonDecode(body);
                  //   if (data["code"] == "0000") {
                  //     setState(() {
                  //       isLoading = false;
                  //     });
                  //     if (data['desc'] == "Your Otp is wrong.") {
                  //       // this.alertmsg = data['desc'];
                  //       this.alertmsg = "Incorrect OTP";
                  //       this.snackbarmethod();
                  //     } else {
                  //       final prefs = await SharedPreferences.getInstance();
                  //       final key1 = 'FCMToken';
                  //       final fcmtoken = ftoken;
                  //       prefs.setString(key1, fcmtoken);
                  //       print('FToken $ftoken');
                  //       final key2 = 'UserId';
                  //       final UserId = '${widget.value}';
                  //       prefs.setString(key2, UserId);
                  //       // this.alertmsg = data['desc'];
                  //       this.alertmsg = "Verified successfully";
                  //       this.snackbarmethod();
                  //       Future.delayed(const Duration(milliseconds: 2000), () {
                  //         // Navigator.push(
                  //         //     context,
                  //         //     MaterialPageRoute(
                  //         //         builder: (context) => Sqlite()));
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => TabsPage(
                  //                 openTab: 0,
                  //               ),
                  //             ));
                  //       });
                  //     }
                  //   } else {
                  //     setState(() {
                  //       isLoading = false;
                  //     });
                  //     this.alertmsg = data['desc'];
                  //     this.snackbarmethod();
                  //   }
                  //   // print(contactList);
                  // } else {
                  //   print("Connection Fail");
                  //   setState(() {
                  //     isLoading = false;
                  //   });
                  // }
                },
                textColor: Colors.white,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // color: Colors.blue,
                // textColor: Colors.white,
                child: Text(
                  lan == "Zg"
                      ? Rabbit.uni2zg("အတည်ပြုပါ (Verify)")
                      : "အတည်ပြုပါ (Verify)",
                  // "အတည်ပြုပါ (Verify)",
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
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
          //   child: Container(
          //     width: 90.0,
          //     child: RaisedButton(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(5.0),
          //       ),
          //       onPressed: () async {
          //         setState(() {
          //           isLoading = true;
          //         });
          //         String url =
          //             "http://52.187.13.89:8080/tracemyanmar/module001/serviceRegisterTraceMyanmar/register";
          //         Map<String, String> headers = {
          //           "Content-type": "application/json"
          //         };
          //         String json = '{ "phoneNo": "' +
          //             "${widget.value}" +
          //             '","otp": "' +
          //             myController.text +
          //             '"}';
          //         http.Response response =
          //             await http.post(url, headers: headers, body: json);
          //         int statusCode = response.statusCode;
          //         if (statusCode == 200) {
          //           String body = response.body;
          //           print(body);
          //           var data = jsonDecode(body);
          //           if (data["code"] == "0000") {
          //             setState(() {
          //               isLoading = false;
          //             });
          //             if (data['desc'] == "Your Otp is wrong.") {
          //               this.alertmsg = data['desc'];
          //               this.snackbarmethod();
          //             } else {
          //               final prefs = await SharedPreferences.getInstance();
          //               final key1 = 'FCMToken';
          //               final fcmtoken = ftoken;
          //               prefs.setString(key1, fcmtoken);
          //               print('FToken $ftoken');
          //               final key2 = 'UserId';
          //               final UserId = '${widget.value}';
          //               prefs.setString(key2, UserId);
          //               this.alertmsg = data['desc'];
          //               this.snackbarmethod();
          //               Future.delayed(const Duration(milliseconds: 2000), () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => Sqlite()));
          //               });
          //             }
          //           } else {
          //             setState(() {
          //               isLoading = false;
          //             });
          //             this.alertmsg = data['desc'];
          //             this.snackbarmethod();
          //           }
          //           // print(contactList);
          //         } else {
          //           print("Connection Fail");
          //           setState(() {
          //             isLoading = false;
          //           });
          //         }
          //       },
          //       color: Colors.blue,
          //       textColor: Colors.white,
          //       child: Container(
          //         width: checklang == "Eng" ? 120 : 200,
          //         height: 40.0,
          //         child: Center(
          //             child: Text(checklang == "Eng" ? textEng[0] : textMyan[0],
          //                 style: TextStyle(
          //                   fontSize: 17,
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.w300,
          //                 ))),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          registerbody,
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
              'OTP',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
        body: isLoading ? bodyProgress : registerbody);
  }
}
