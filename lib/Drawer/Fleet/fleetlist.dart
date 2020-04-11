import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'fleetdetail.dart';

class FleetList extends StatefulWidget {
  @override
  _FleetListState createState() => _FleetListState();
}

class _FleetListState extends State<FleetList> {
  String uu = '';
  var d = [];
  var dd = [];
  int index;
  String checklang = '';
  List textMyan = ["မှတ်​စု စာရင်းများ", "ဖုန်းနံပါတ်း "];
  List textEng = ["Fleet List", "Phone No:"];
  var _start;
  Timer timer;
  var dbHelper;
  @override
  void initState() {
    super.initState();
    checkLanguage();
    _fetchfleep();
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

  _fetchfleep() async {
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('UserId');
    String url =
        "http://52.187.13.89:8080/tracemyanmar/module001/service004/getAllFleepList";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "phneno": "' + uu + '"}';
    print(json);
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body.toString());
      // print(data);
      if (data['msgCode'] == "0000") {
        setState(() {
          d = data['data'];
        });
      }
      // print(d);
      // print(d.length);
      // print(d[0]["phoneno"]);
      // for(var i=0;i<d.length;i++){
      //   index=d[i]["fleepno"].toString().indexOf("|");
      //   if(index==-1){
      //     dd=d[i]["fleepno"];
      //   }else{
      //     dd=d[i]["fleepno"].substring(0,index);
      //   }
      // }
      // print(dd);
    } else {
      print("Connection Fail");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          checklang == "Eng" ? textEng[0] : textMyan[0],
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: d.length,
        itemBuilder: (context, i) {
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "ID: " + d[i]["fleepno"],
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                    checklang == "Eng"
                        ? textEng[1]
                        : textMyan[1] + d[i]["phoneno"],
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FleetDetail(
                                  phoneno: d[i]["phoneno"],
                                  fleepno: d[i]["fleepno"],
                                  depaturedatetime: d[i]["depaturedatetime"],
                                  fromLocation: d[i]["fromLocation"],
                                  arrivaldatetime: d[i]["arrivaldatetime"],
                                  tolocation: d[i]["tolocation"],
                                  remark: d[i]["remark"],
                                )));
                  },
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
