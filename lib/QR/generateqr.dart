import 'dart:ui';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Generateqr extends StatefulWidget {
  final userid;
  final String skey;
  final String rid;

  Generateqr({Key key, this.userid, this.skey, this.rid}) : super(key: key);
  @override
  _CashInConfirmState createState() => _CashInConfirmState();
}

class _CashInConfirmState extends State<Generateqr> {
  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  String res, id, user;
  void initState() {
    super.initState();
    getinfo();
  }

  getinfo() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String name = prefs.getString('name');
    id = userID;
    user = name;
    setState(() {
      _dataString =
          '{"skey":"' + "${widget.skey}" + '","rid":"' + "${widget.rid}" + '"}';
      _inputErrorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        //Application Bar
        elevation: 2.0,
        backgroundColor: Colors.blue,
        title: new Center(
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
                width: 300,
                height: 50,
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 5.0,
                  splashColor: Colors.red,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Sqlite()));
                  },
                  child: new Text(
                    "CLOSE",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
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
