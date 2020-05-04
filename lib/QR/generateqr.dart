import 'dart:async';

import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
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
    analyst();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'GenerateQR_Request',
      parameters: <String, dynamic>{
        // 'string': myController.text,
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    // timer1.cancel();
    super.dispose();
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
      key: _scaffoldkey,
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
