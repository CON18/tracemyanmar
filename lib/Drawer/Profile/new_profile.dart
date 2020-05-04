import 'dart:async';
import 'dart:convert';
import 'package:TraceMyanmar/Drawer/Profile/profile_view.dart';
import 'package:TraceMyanmar/country_township/townships.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:device_id/device_id.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProfile extends StatefulWidget {
  final String userid;
  // final String username;

  NewProfile({Key key, this.userid
      // , this.username
      })
      : super(key: key);
  @override
  _NewProfileState createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final myController = TextEditingController();
  final mynameController = TextEditingController();
  final nrcController = TextEditingController();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String divisionamount = '';
  String districtamount = '';
  String townshipamount = '';
  String alertmsg = "";
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  List districtList = ["-"];

  List townshipList = ["-"];

  String checklang = '';
  List textMyan = [
    // "ကိုယ်ပိုင်အချက်အလက် (",
    "ကိုယ်ရေးအချက်အလက် (Profile)",
    "ဖုန်းနံပါတ် (Phone No)",
    "အမည် (Name)",
    "တိုင်း/ ပြည်နယ် (Division)",
    "ခရိုင် (District)",
    "မြို့နယ် (Township)",
    // "ပြင်ဆင်မည် (Update)",
    "သိမ်းဆည်း (Save)",
    "မှတ်ပုံတင် (NRC)"
    // နံပါတ်
  ];
  List textEng = [
    "Profile",
    "Phone No",
    "Name",
    "Please Select Division",
    "Please Select District",
    "Please Select Township",
    "Update",
    "NRC"
  ];

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
    setState(() {});
  }

  String qrText;
  var _start;
  Timer timer;
  var dbHelper;
  var lan;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    checkLanguage();
    divisionamount = divisionList[0];
    districtamount = districtList[0];
    townshipamount = townshipList[0];

    // dbHelper = DBHelper();
    // _checkAndstartTrack();
    someMethod();
    analyst();

    _setDDT();
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
      name: 'Profile_Request',
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

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 1),
    ));
  }

  // getstorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key3 = 'UserName';
  //   final username = mynameController.text;
  //   prefs.setString(key3, username);
  // }

  _setDDT() async {
    deviceId = await DeviceId.getID;
    final prefs = await SharedPreferences.getInstance();
    var div = prefs.getString("division") ?? "-";
    var dis = prefs.getString("district") ?? "-";
    var tow = prefs.getString("township") ?? "-";
    var nrc = prefs.getString("nrc") ?? "";
    var name = prefs.getString("UserName") ?? "";

    myController.text = "${widget.userid}";

    // if (name == "" || nrc == "" || div == "-" || dis == "-" || tow == "-") {
    if (name == "") {
      //Get from server
      isLoading = true;

      String url = url2 + "/module001/service004/getProfile";

      var body = jsonEncode(
          // {"phoneNo": , "otp": myController.text}
          {
            "phoneno": widget.userid,
            "uuid": deviceId,
          });
      // snackbarmethod1("BY >>  " + body);
      http.post(Uri.encodeFull(url), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((dynamic res) async {
        print("Response >> " + res.toString());
        var result = json.decode(utf8.decode(res.bodyBytes));
        var resStatus = result['code'];
        // snackbarmethod1(result['code'].toString());
        if (resStatus == '0000') {
          setState(() {
            mynameController.text = result['name'];
            nrcController.text = result['nrc'];
            if (result['division'] == "") {
              div = "-";
            } else {
              div = result['division'];
            }
            if (result['district'] == "") {
              dis = "-";
            } else {
              dis = result['district'];
            }
            if (result['township'] == "") {
              tow = "-";
            } else {
              tow = result['township'];
            }
            // print("DDD >> " + div + dis + tow);
            // snackbarmethod1("DDD >> " + div + dis + tow);
            // districtList = ["-"];
            // districtamount = "-";
            // townshipList = ["-"];
            // townshipamount = "-";

            prefs.setString("division", div);
            prefs.setString("district", dis);
            prefs.setString("township", tow);
            prefs.setString("nrc", result['nrc']);
            prefs.setString("UserName", result['name']);

            if (div != "-") {
              divisionamount = div;
              if (dis != "-") {
                setState(() {
                  for (var i = 0; i < allDisList.length; i++) {
                    List div = allDisList[i][divisionamount];
                    if (div != null) {
                      for (var j = 0; j < div.length; j++) {
                        districtList.add(div[j]);
                      }
                    }
                  }
                  districtamount = dis;
                  if (tow != "-") {
                    setState(() {
                      for (var i = 0; i < allTowList.length; i++) {
                        List div = allTowList[i][districtamount];
                        if (div != null) {
                          for (var j = 0; j < div.length; j++) {
                            townshipList.add(div[j]);
                          }
                        }
                      }
                      townshipamount = tow;
                    });
                  }
                });
              }
            }
            isLoading = false;
          });
        }
      }).catchError((Object error) async {
        print("ON ERROR >>");
        setState(() {
          isLoading = false;
        });
      });
    } else {
      // Already exist profile data
      nrcController.text = nrc;
      mynameController.text = name;
      if (myController.text == "null") {
        myController.text = "";
      } else {
        myController.text = "${widget.userid}";
      }
      if (mynameController.text == "null") {
        mynameController.text = "";
      } else {
        mynameController.text = name;
      }

      if (div != "-") {
        divisionamount = div;
        if (dis != "-") {
          setState(() {
            for (var i = 0; i < allDisList.length; i++) {
              List div = allDisList[i][divisionamount];
              if (div != null) {
                for (var j = 0; j < div.length; j++) {
                  districtList.add(div[j]);
                }
              }
            }
            districtamount = dis;
            if (tow != "-") {
              setState(() {
                for (var i = 0; i < allTowList.length; i++) {
                  List div = allTowList[i][districtamount];
                  if (div != null) {
                    for (var j = 0; j < div.length; j++) {
                      townshipList.add(div[j]);
                    }
                  }
                }
                townshipamount = tow;
              });
            }
          });
        }
      }
    }

    // divisionamount = "ကယား";

    // setState(() {
    //   for (var i = 0; i < allDisList.length; i++) {
    //     List div = allDisList[i][divisionamount];
    //     if (div != null) {
    //       for (var j = 0; j < div.length; j++) {
    //         districtList.add(div[j]);
    //       }
    //     }
    //   }
    //   districtamount = "လွိုင်ကော်";
    //   setState(() {
    //     for (var i = 0; i < allTowList.length; i++) {
    //       List div = allTowList[i][districtamount];
    //       if (div != null) {
    //         for (var j = 0; j < div.length; j++) {
    //           townshipList.add(div[j]);
    //         }
    //       }
    //     }
    //     townshipamount = "ဖရူဆိုး";
    //   });
    // });
  }

  update(val) async {
    print("DIV >> " + divisionamount.toString());
    print("DIS >> " + districtamount.toString());
    print("TOWN >> " + townshipamount.toString());

    setState(() {
      if (val == "S") {
        isLoading = true;
      }
    });

    String url =
        // "http://52.187.13.89:8080/tracemyanmar/module001/serviceRegisterTraceMyanmar/updateRegister";
        // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/updateRegister";
        // "http://uatsssverify.azurewebsites.net/module001/service004/saveProfile";
        url2 + "/module001/service004/saveProfile";

    var body = jsonEncode(
        // {"phoneNo": , "otp": myController.text}
        {
          "phoneno": "${myController.text}",
          "name": mynameController.text,
          "nrc": nrcController.text,
          "uuid": deviceId,
          "division": divisionamount,
          "district": districtamount,
          "township": townshipamount
        });
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) async {
      print("Response >> " + res.toString());
      var result = json.decode(utf8.decode(res.bodyBytes));
      var resStatus = result['code'];
      if (resStatus == '0000') {
        // desc
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("division", divisionamount.toString());
        prefs.setString("district", districtamount.toString());
        prefs.setString("township", townshipamount.toString());
        prefs.setString("nrc", nrcController.text.toString());
        prefs.setString("UserName", mynameController.text.toString());

        if (val == "S") {
          this.alertmsg = result['desc'];
          this.snackbarmethod();
        }

        // getstorage();

        // Future.delayed(const Duration(milliseconds: 1000), () {
        // var route = new MaterialPageRoute(
        //     builder: (BuildContext context) => new Sqlite());
        // Navigator.of(context).push(route);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TabsPage(
                openTab: 0,
              ),
            ));
        // });
      } else {
        this.alertmsg = result['desc'];
        this.snackbarmethod();
      }
    });

    // Map<String, String> headers = {"Content-type": "application/json"};
    // String json = '{"phoneNo": "' +
    //     // "+959951063763" +
    //     "${myController.text}" +
    //     '", "division":"' +
    //     divisionamount +
    //     '", "district":"' +
    //     districtamount +
    //     '", "township":"' +
    //     townshipamount +
    //     '" }';
    // print("JSON >> " + json.toString());
    // http.Response response = await http.post(url, headers: headers, body: json);
    // int statusCode = response.statusCode;
    // print(statusCode);
    // if (statusCode == 200) {
    //   String body = response.body;
    //   print(body);
    //   var data = jsonDecode(body);
    //   print("DATA>>  " + data.toString());
    //   // setState(() {
    //   if (data['code'] == "0000") {
    //     final prefs = await SharedPreferences.getInstance();
    //     prefs.setString("division", divisionamount.toString());
    //     prefs.setString("district", districtamount.toString());
    //     prefs.setString("township", townshipamount.toString());

    //     if (val == "S") {
    //       this.alertmsg = data['desc'];
    //       this.snackbarmethod();
    //     }

    //     getstorage();
    //     // Future.delayed(const Duration(milliseconds: 1000), () {
    //     // var route = new MaterialPageRoute(
    //     //     builder: (BuildContext context) => new Sqlite());
    //     // Navigator.of(context).push(route);
    //     Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => TabsPage(
    //             openTab: 0,
    //           ),
    //         ));
    //     // });
    //   } else {
    //     this.alertmsg = data['desc'];
    //     this.snackbarmethod();
    //   }

    //   // Navigator.pop(context);
    //   // });
    // } else {
    //   print("Connection Fail");
    // }
  }

  @override
  Widget build(BuildContext context) {
    var profileBody = SingleChildScrollView(
      // key: _formKey,
      child: new Container(
        // height: checklang == "Eng" ? 750 : 790,
        padding: EdgeInsets.all(8.0),
        child:
            // Stack(
            //   children: [
            Card(
          elevation: 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Column(
                  //   children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10.0),
                  //   child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(60.0),
                  //       child: (Image.asset('assets/user-icon.png',
                  //           width: 110.0, height: 110.0))),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: 110.0,
                      height: 110.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.lightBlueAccent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0, 5),
                              blurRadius: 25)
                        ],
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/user-icon.png"),
                      ),
                    ),
                  )

                  //   ],
                  // ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: Container(
                    child: TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  controller: myController,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                    // labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                    labelText:
                        lan == "Zg" ? Rabbit.uni2zg(textMyan[1]) : textMyan[1],
                    hasFloatingPlaceholder: true,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                        fontSize: 16,
                        color: Colors.black,
                        height: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.lightBlueAccent, width: 1.0),
                    ),
                    // borderSide: BorderSide(
                    //     color: Colors.lightBlue[100], width: 1.0)
                    // ),
                    fillColor: Colors.grey,
                  ),
                )),
              ),
              // Divider(height: 20),
              // SizedBox(height: 10,),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: Container(
                    child: TextFormField(
                  controller: mynameController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                    // labelText: checklang == "Eng" ? textEng[2] : textMyan[2],
                    labelText:
                        lan == "Zg" ? Rabbit.uni2zg(textMyan[2]) : textMyan[2],
                    hasFloatingPlaceholder: true,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                        fontSize: 16,
                        color: Colors.black,
                        height: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.lightBlueAccent, width: 1.0),
                    ),
                    fillColor: Colors.grey,
                  ),
                )),
              ),
              //NRC
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: Container(
                    child: TextFormField(
                  controller: nrcController,
                  autofocus: false,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                    // labelText: checklang == "Eng" ? textEng[2] : textMyan[2],
                    labelText:
                        lan == "Zg" ? Rabbit.uni2zg(textMyan[7]) : textMyan[7],
                    hasFloatingPlaceholder: true,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                        fontSize: 16,
                        color: Colors.black,
                        height: 0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.lightBlueAccent, width: 1.0),
                    ),
                    fillColor: Colors.grey,
                  ),
                )),
              ),
              // Divider(height: 20),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              //   child: Container(
              //       child: TextFormField(
              //     controller: nrcController,
              //     style: TextStyle(
              //         color: Colors.grey, fontWeight: FontWeight.w300),
              //     decoration: InputDecoration(
              //       labelText: checklang == "Eng" ? textEng[7] : textMyan[7],
              //       hasFloatingPlaceholder: true,
              //       labelStyle: TextStyle(
              //           fontSize: 16, color: Colors.black, height: 0),
              //       fillColor: Colors.grey,
              //     ),
              //   )),
              // ),
              // Divider(height: 20),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: new Text(
                      // checklang == "Eng" ? textEng[3] : textMyan[3],
                      lan == "Zg" ? Rabbit.uni2zg(textMyan[3]) : textMyan[3],
                      style: TextStyle(
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: SizedBox(
                  height: 60.0,
                  child: new DropdownButton<String>(
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w300),
                    isExpanded: true,
                    items: divisionList.map((item) {
                      // date1 = item['startdate'];
                      return new DropdownMenuItem(
                        child: Container(
                          width: 200,
                          child: new Text(
                            lan == "Zg" ? Rabbit.uni2zg(item) : item,
                            style: TextStyle(
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu"),
                          ),
                        ),
                        value: item.toString(),
                      );
                    }).toList(),
                    onChanged: (newvalue) {
                      // startDate.text = date1;
                      divisionamount = newvalue;
                      print("division " + divisionamount);
                      districtList = ["-"];
                      districtamount = "-";
                      townshipList = ["-"];
                      townshipamount = "-";
                      // districtList.clear();
                      setState(() {
                        for (var i = 0; i < allDisList.length; i++) {
                          List div = allDisList[i][divisionamount];
                          if (div != null) {
                            for (var j = 0; j < div.length; j++) {
                              districtList.add(div[j]);
                            }
                          }
                        }
                      });
                      setState(() {});
                    },
                    value: divisionamount.toString(),
                    underline: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Divider(
              //   height: 20,
              // ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: new Text(
                      // checklang == "Eng" ? textEng[4] : textMyan[4],
                      lan == "Zg" ? Rabbit.uni2zg(textMyan[4]) : textMyan[4],
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: SizedBox(
                  height: 60.0,
                  child: new DropdownButton<String>(
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w300),
                    isExpanded: true,
                    items: districtList.map((item) {
                      // date1 = item['startdate'];
                      return new DropdownMenuItem(
                        child: Container(
                          width: 200,
                          child: new Text(
                            lan == "Zg" ? Rabbit.uni2zg(item) : item,
                            style: TextStyle(
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu"),
                          ),
                        ),
                        value: item.toString(),
                      );
                    }).toList(),
                    onChanged: (newvalue) {
                      // startDate.text = date1;
                      districtamount = newvalue;
                      print("division " + districtamount);
                      townshipList = ["-"];
                      townshipamount = "-";
                      // districtList.clear();
                      setState(() {
                        for (var i = 0; i < allTowList.length; i++) {
                          List div = allTowList[i][districtamount];
                          if (div != null) {
                            for (var j = 0; j < div.length; j++) {
                              townshipList.add(div[j]);
                            }
                          }
                        }
                      });
                      setState(() {});
                    },
                    value: districtamount.toString(),
                    underline: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Divider(
              //   height: 20,
              // ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: new Text(
                      // checklang == "Eng" ? textEng[5] : textMyan[5],
                      lan == "Zg" ? Rabbit.uni2zg(textMyan[5]) : textMyan[5],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: SizedBox(
                  height: 60.0,
                  child: new DropdownButton<String>(
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w300),
                    isExpanded: true,
                    items: townshipList.map((item) {
                      // date1 = item['startdate'];
                      return new DropdownMenuItem(
                        child: Container(
                          width: 200,
                          child: new Text(
                            lan == "Zg" ? Rabbit.uni2zg(item) : item,
                            style: TextStyle(
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu"),
                          ),
                        ),
                        value: item.toString(),
                      );
                    }).toList(),
                    onChanged: (newvalue) {
                      // startDate.text = date1;
                      townshipamount = newvalue;
                      print("division " + townshipamount);
                      setState(() {});
                    },
                    value: townshipamount.toString(),
                    underline: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Divider(height: 20),
              SizedBox(
                height: 20.0,
              ),
              new RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () async {
                  update("S");
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Container(
                  // width: 120.0,
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 38.0,
                  child: Center(
                      // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
                      child: Text(
                          // checklang == "Eng" ? textEng[6] : textMyan[6],
                          lan == "Zg"
                              ? Rabbit.uni2zg(textMyan[6])
                              : textMyan[6],
                          style: TextStyle(
                            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ))),
                ),
              ),
              SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
        //   ],
        // ),
      ),
    );
    var loadingCir = new Container(
      child: new Stack(
        children: <Widget>[
          profileBody,
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
        title: Text(
          lan == "Zg" ? Rabbit.uni2zg(textMyan[0]) : textMyan[0],
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18.0,
              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu"),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: Builder(builder: (BuildContext context) {
          return new GestureDetector(
            onTap: () {
              print("BACK");
              setState(() {
                update("B");
              });

              // var tt = "Refresh";
              // Navigator.pop(context);
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
        // leading: new Container(),
      ),
      body: isLoading ? loadingCir : profileBody,
    );
  }
}
