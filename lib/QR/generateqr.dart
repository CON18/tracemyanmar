import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:ui';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Generateqr extends StatefulWidget {
  final userid;
  final String skey;
  final String rid;
  final String remark;

  Generateqr({
    Key key,
    this.userid,
    this.skey,
    this.rid,
    this.remark,
  }) : super(key: key);
  @override
  _CashInConfirmState createState() => _CashInConfirmState();
}

class _CashInConfirmState extends State<Generateqr> {
  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  String res, id, user;

  var _start;
  Timer timer;
  var dbHelper;

  void initState() {
    super.initState();
    getinfo();
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

  getinfo() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String name = prefs.getString('name');
    id = userID;
    user = name;
    setState(() {
      _dataString = '{"skey":"' +
          "${widget.skey}" +
          '","rid":"' +
          "${widget.rid}" +
          '","remark":"' +
          "${widget.remark}" +
          '"}';
      _inputErrorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        //Application Bar
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Colors.blue,
        title: new Container(
          child: new Text(
            'QR',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
      body: new Form(
        key: globalKey,
        child: new ListView(
          children: <Widget>[
            Center(
              child: new Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
            ),
            SizedBox(height: 30.0),
            Center(
                child:
                    Text('${widget.userid}', style: TextStyle(fontSize: 17.0))),
            SizedBox(height: 20.0),
            Center(
                child: Text('${widget.rid}', style: TextStyle(fontSize: 17.0))),
            SizedBox(height: 30.0),
            Center(
                child: RepaintBoundary(
              child: QrImage(
                data: _dataString,
                backgroundColor: Colors.white,
                size: 300,
                gapless: true,
              ),
            )),
            SizedBox(height: 25.0),
            Center(
              child: Container(
                width: 250,
                height: 40,
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 5.0,
                  splashColor: Colors.red,
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Sqlite()));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabsPage(
                            openTab: 0,
                          ),
                        ));
                  },
                  child: new Text(
                    "CLOSE",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
