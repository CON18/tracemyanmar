import 'dart:convert';
import 'package:TraceMyanmar/LoginandRegister/register.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final mynameController = TextEditingController();
  final myController = TextEditingController();
  bool _validate = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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
  void initState() {
    super.initState();
    checkLanguage();
    getlocation();
  }

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
                  keyboardType: TextInputType.number,
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
                    hintText: "မိုဘိုင်းဖုန်းနံပါတ် ( Mobile Phone Number)",                    
                    errorText: _validate ? "Please Fill Phone No" : null,
                    errorStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        wordSpacing: 1),
                    hintStyle: TextStyle(
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
              child: RaisedButton(
                shape: new CircleBorder(),
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
                    if (phoneNo.indexOf("7") == 0 && phoneNo.length == 9) {
                      phoneNo = '+959' + this.phoneNo;
                    } else if (phoneNo.indexOf("9") == 0 &&
                        phoneNo.length == 9) {
                      phoneNo = '+959' + phoneNo;
                    } else if (phoneNo.indexOf("+") != 0 &&
                        phoneNo.indexOf("7") != 0 &&
                        phoneNo.indexOf("9") != 0 &&
                        (phoneNo.length == 8 ||
                            phoneNo.length == 9 ||
                            phoneNo.length == 7)) {
                      this.phoneNo = '+959' + this.phoneNo;
                    } else if (phoneNo.indexOf("09") == 0 &&
                        (phoneNo.length == 10 ||
                            phoneNo.length == 11 ||
                            phoneNo.length == 9)) {
                      phoneNo = '+959' + phoneNo.substring(2);
                    } else if (phoneNo.indexOf("959") == 0 &&
                        (phoneNo.length == 11 ||
                            phoneNo.length == 12 ||
                            phoneNo.length == 10)) {
                      phoneNo = '+959' + phoneNo.substring(3);
                    }
                  });
                  myController.text = phoneNo;
                  if (myController.text == "" || myController.text == null) {
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    String url =
                        "http://52.187.13.89:8080/tracemyanmar/module001/serviceRegisterTraceMyanmar/checkRegister";
                    Map<String, String> headers = {
                      "Content-type": "application/json"
                    };
                    String json = '{ "phoneNo": "' + myController.text + '"}';
                    http.Response response =
                        await http.post(url, headers: headers, body: json);
                    int statusCode = response.statusCode;
                    if (statusCode == 200) {
                      String body = response.body;
                      print(body);
                      data = jsonDecode(body);
                      if (data["code"] == "0000") {
                        setState(() {
                          isLoading = false;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        final key1 = 'FCMToken';
                        final fcmtoken = ftoken;
                        prefs.setString(key1, fcmtoken);
                        print('FToken $ftoken');
                        this.alertmsg = data['desc'];
                        this.snackbarmethod();
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Register(value: myController.text)));
                        });
                      } else if (data["code"] == "0001") {
                        setState(() {
                          isLoading = false;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        final key1 = 'FCMToken';
                        final fcmtoken = ftoken;
                        prefs.setString(key1, fcmtoken);
                        print('FToken $ftoken');
                        final key2 = 'UserId';
                        final UserId = myController.text;
                        prefs.setString(key2, UserId);
                        this.alertmsg = data['desc'];
                        this.snackbarmethod();
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Sqlite(value: myController.text)));
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        this.alertmsg = data['desc'];
                        this.snackbarmethod();
                      }
                    } else {
                      print("Connection Fail");
                      setState(() {
                        this.alertmsg = data['desc'];
                        this.snackbarmethod();
                        // isLoading = false;
                      });
                    }
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
              checklang == "Eng" ? textEng[0] : textMyan[0],
              // 'စီစစ်ခြင်း (Verify)',
              style: TextStyle(
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
