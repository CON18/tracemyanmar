import 'dart:async';
import 'dart:convert';
import 'package:TraceMyanmar/Drawer/Profile/profile_view.dart';
import 'package:TraceMyanmar/country_township/townships.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProfile extends StatefulWidget {
  final String userid;
  final String username;

  NewProfile({Key key, this.userid, this.username}) : super(key: key);
  @override
  _NewProfileState createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final myController = TextEditingController();
  final mynameController = TextEditingController();
  final nrcController = TextEditingController();

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
    "ဖုန်းနံပါတ်",
    "အမည်",
    "တိုင်း/ ပြည်နယ် ရွေးချယ်ပါ",
    "ခရိုင် ရွေးချယ်ပါ",
    "မြို့နယ် ရွေးချယ်ပါ",
    "ပြင်ဆင်မည်",
    "မှတ်ပုံတင်"
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

  @override
  void initState() {
    super.initState();

    checkLanguage();
    divisionamount = divisionList[0];
    districtamount = districtList[0];
    townshipamount = townshipList[0];
    myController.text = "${widget.userid}";
    mynameController.text = "${widget.username}";
    if (myController.text == "null") {
      myController.text = "";
    } else {
      myController.text = "${widget.userid}";
    }
    if (mynameController.text == "null") {
      mynameController.text = "";
    } else {
      mynameController.text = "${widget.username}";
    }

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
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      var location = "${position.latitude}, ${position.longitude}";
      print("location >>> $location");

      DateTime now = DateTime.now();
      var curDT = new DateFormat.yMd().add_jm().format(now);

      Employee e =
          Employee(int.parse(widget.userid), location, curDT, "", "", "Auto");
      dbHelper.save(e);

      final prefs = await SharedPreferences.getInstance();
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

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 1),
    ));
  }

  getstorage() async {
    final prefs = await SharedPreferences.getInstance();
    final key3 = 'UserName';
    final username = mynameController.text;
    prefs.setString(key3, username);
  }

  update() async {
    String url =
        "http://52.187.13.89:8080/tracemyanmar/module001/serviceRegisterTraceMyanmar/updateRegister";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phoneNo": "' +
        "+959951063763" +
        '", "division":"' +
        divisionamount +
        '", "district":"' +
        districtamount +
        '", "township":"' +
        townshipamount +
        '" }';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = response.body;
      print(body);
      var data = jsonDecode(body);
      setState(() {
        if (data['code'] == "0000") {
          this.alertmsg = data['desc'];
          this.snackbarmethod();
          getstorage();
          Future.delayed(const Duration(milliseconds: 1000), () {
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
          });
        } else {
          this.alertmsg = data['desc'];
          this.snackbarmethod();
        }

        // Navigator.pop(context);
      });
    } else {
      print("Connection Fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
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
              print("BACK");
              setState(() {
                update();
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
      body: SingleChildScrollView(
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
                      labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
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
                      labelText: checklang == "Eng" ? textEng[2] : textMyan[2],
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
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
                        checklang == "Eng" ? textEng[3] : textMyan[3],
                        style: TextStyle(
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
                            child: new Text(item),
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
                        checklang == "Eng" ? textEng[4] : textMyan[4],
                        style: TextStyle(
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
                      items: districtList.map((item) {
                        // date1 = item['startdate'];
                        return new DropdownMenuItem(
                          child: Container(
                            width: 200,
                            child: new Text(item),
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
                        checklang == "Eng" ? textEng[5] : textMyan[5],
                        textAlign: TextAlign.left,
                        style: TextStyle(
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
                      items: townshipList.map((item) {
                        // date1 = item['startdate'];
                        return new DropdownMenuItem(
                          child: Container(
                            width: 200,
                            child: new Text(item),
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
                // new RaisedButton(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                //   onPressed: () async {
                //     update();
                //   },
                //   color: Colors.blue,
                //   textColor: Colors.white,
                //   child: Container(
                //     width: 120.0,
                //     height: 38.0,
                //     child: Center(
                //         // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
                //         child:
                //             Text(checklang == "Eng" ? textEng[6] : textMyan[6],
                //                 style: TextStyle(
                //                   fontSize: 16,
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.w300,
                //                 ))),
                //   ),
                // ),
                // SizedBox(
                //   height: 15.0,
                // )
              ],
            ),
          ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
