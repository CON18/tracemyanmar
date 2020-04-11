import 'dart:convert';
import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:TraceMyanmar/tabs.dart';
import 'package:flutter/material.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  final String value;

  Register({Key key, this.value}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final myController = TextEditingController();
  var ftoken;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  bool isLoading = false;
  String checklang = '';
  List textMyan = ["ဝင်မည်"];
  // List textMyan = [""];
  List textEng = ["Ok"];
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

  var _start;
  Timer timer;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    checkLanguage();

    dbHelper = DBHelper();
    _checkAndstartTrack();
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
                hintText: "OTP",
                hintStyle: TextStyle(
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
                shape: new CircleBorder(),
                elevation: 5,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String url =
                      "http://52.187.13.89:8080/tracemyanmar/module001/serviceRegisterTraceMyanmar/register";
                  Map<String, String> headers = {
                    "Content-type": "application/json"
                  };
                  String json = '{ "phoneNo": "' +
                      "${widget.value}" +
                      '","otp": "' +
                      myController.text +
                      '"}';
                  http.Response response =
                      await http.post(url, headers: headers, body: json);
                  int statusCode = response.statusCode;
                  if (statusCode == 200) {
                    String body = response.body;
                    print(body);
                    var data = jsonDecode(body);
                    if (data["code"] == "0000") {
                      setState(() {
                        isLoading = false;
                      });
                      if (data['desc'] == "Your Otp is wrong.") {
                        // this.alertmsg = data['desc'];
                        this.alertmsg = "Incorrect OTP";
                        this.snackbarmethod();
                      } else {
                        final prefs = await SharedPreferences.getInstance();
                        final key1 = 'FCMToken';
                        final fcmtoken = ftoken;
                        prefs.setString(key1, fcmtoken);
                        print('FToken $ftoken');
                        final key2 = 'UserId';
                        final UserId = '${widget.value}';
                        prefs.setString(key2, UserId);
                        // this.alertmsg = data['desc'];
                        this.alertmsg = "Verified successfully";
                        this.snackbarmethod();
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Sqlite()));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TabsPage(
                                  openTab: 0,
                                ),
                              ));
                        });
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      this.alertmsg = data['desc'];
                      this.snackbarmethod();
                    }
                    // print(contactList);
                  } else {
                    print("Connection Fail");
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Container(
                  width: 55.0,
                  height: 55.0,

                  //   child: Center(
                  //       child: Text(checklang=="Eng" ? textEng[0] : textMyan[0],
                  //           style: TextStyle(
                  //             fontSize: 17,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w300,
                  //           ))),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 40,
                  ),

                  // child: Image.asset('assets/circle.png'),
                ),
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
