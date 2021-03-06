import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FleetDetail extends StatefulWidget {
  final String phoneno;
  final String fleepno;
  final String depaturedatetime;
  final String fromLocation;
  final String arrivaldatetime;
  final String tolocation;
  final String remark;

  FleetDetail(
      {Key key,
      this.phoneno,
      this.fleepno,
      this.depaturedatetime,
      this.fromLocation,
      this.arrivaldatetime,
      this.tolocation,
      this.remark})
      : super(key: key);
  @override
  _FleetDetailState createState() => _FleetDetailState();
}

class _FleetDetailState extends State<FleetDetail> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _text1 = new TextEditingController();
  final TextEditingController _text2 = new TextEditingController();
  final TextEditingController _text3 = new TextEditingController();
  final TextEditingController _text4 = new TextEditingController();
  final TextEditingController _text5 = new TextEditingController();
  final TextEditingController _text6 = new TextEditingController();
  final TextEditingController _text7 = new TextEditingController();
  final TextEditingController _text8 = new TextEditingController();
  var date_1="";
  var date_2="";
  var date1="";
  var time1="";
  var date2="";
  var time2="";
  var index1;
  var index2;
  var index3;
  String checklang = '';
  List textMyan = ["အမျိုးအစား","ထွက်​ခွာသည့် ​နေ့ရက်​/အချိန်​","မှ","​ရောက်​ရှိသည့် ​နေ့ရက်​/အချိန်​","သို့","အ​ကြောင်းအရာ"];
  List textEng = ["Type:","Departure Date Time","From:","Arrival Date Time","To:","Remark"];
var _start;
  Timer timer;
  var dbHelper;
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
    _text1.text=widget.fleepno;
    _text2.text=widget.depaturedatetime;
    _text3.text=widget.fromLocation;
    _text4.text=widget.arrivaldatetime;
    _text5.text=widget.tolocation;
    _text6.text=widget.remark;
    
    setState(() {
      date_1=_text2.text;
      index1 = date_1.toString().indexOf('|');
      date1=date_1.toString().substring(0,index1);
      time1=date_1.toString().substring(index1+1);
      date_2=_text4.text;
      index2 = date_2.toString().indexOf('|');
      date2=date_2.toString().substring(0,index2);
      time2=date_2.toString().substring(index2+1);
      index3 = _text1.text.toString().indexOf('|');
      if(index3 == -1){
        _text7.text=_text1.text.toString();
        _text8.text=" ";
      }else{
        _text7.text=_text1.text.toString().substring(0,index3);
        _text8.text=_text1.text.toString().substring(index3+1);
      }
    });

    dbHelper = DBHelper();
    _checkAndstartTrack();
    
  }


  
  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  _checkAndstartTrack() async {
    final result = await Geolocator().isLocationServiceEnabled();
    if (result == false) {
      snackbarmethod1("Please turn on GPS.");
    } else {
      GeolocationStatus result1 =
          await Geolocator().checkGeolocationPermissionStatus();

      print("RESULT >>> " + result1.toString());
      if (result1.toString() == "GeolocationStatus.denied") {
        //ask permission
        final position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        // location = "${position.latitude}, ${position.longitude}";
        // latt = "${position.latitude}";
        // longg = "${position.longitude}";
      } else {
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
    }
  }

  @override
  void dispose() {
    timer.cancel();
    // timer1.cancel();
    super.dispose();
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
      // _start = startInterval;
      countDownSave();
    } on Exception catch (_) {
      print('never reached');
    }
    // });
  }


  @override
  Widget build(BuildContext context) {
    final fleetno = new TextField(
      controller: _text7,
      style: TextStyle(fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          labelText: "ID:",
          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
          ),
      readOnly: true,
    );
    final type = new TextField(
      controller: _text8,
      style: TextStyle(fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          labelText: checklang=="Eng" ? textEng[0] : textMyan[0],
          labelStyle: TextStyle(height: 0,color: Colors.black,fontWeight: FontWeight.w600)
          ),
      readOnly: true,
    );
    final depaturedatetime = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text(checklang=="Eng" ? textEng[1] : textMyan[1],style: TextStyle(fontWeight: FontWeight.w600),),
                SizedBox(
                  height: 10,
                ),
                Container(
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                      //   DatePicker.showDatePicker(context,
                      //       theme: DatePickerTheme(
                      //         containerHeight: 210.0,
                      //       ),
                      //       showTitleActions: true,
                      //       minTime: DateTime(2000, 1, 1),
                      //       maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                      //     print('confirm $date');
                      //     _date1 = '${date.year} - ${date.month} - ${date.day}';
                      //     setState(() {});
                      //   }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$date1",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        // DatePicker.showTimePicker(context,
                        //     theme: DatePickerTheme(
                        //       containerHeight: 210.0,
                        //     ),
                        //     showTitleActions: true, onConfirm: (time) {
                        //   print('confirm $time');
                        //   _time1 = '${time.hour} : ${time.minute} : ${time.second}';
                        //   setState(() {});
                        // }, currentTime: DateTime.now(), locale: LocaleType.en);
                        // setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$time1",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    )
                  ],
                ),
              )
              ],);
    final fromLocation = new TextField(
      controller: _text3,
      decoration: InputDecoration(
          labelText: checklang=="Eng" ? textEng[2] : textMyan[2],
          labelStyle: TextStyle(height: 0,color: Colors.black,fontWeight: FontWeight.w600)
          ),
      readOnly: true,
    );

    final arrivaldatetime = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text(checklang=="Eng" ? textEng[3] : textMyan[3],style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(
                  height: 10,
                ),
                Container(
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                      //   DatePicker.showDatePicker(context,
                      //       theme: DatePickerTheme(
                      //         containerHeight: 210.0,
                      //       ),
                      //       showTitleActions: true,
                      //       minTime: DateTime(2000, 1, 1),
                      //       maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                      //     print('confirm $date');
                      //     _date1 = '${date.year} - ${date.month} - ${date.day}';
                      //     setState(() {});
                      //   }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$date2",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        // DatePicker.showTimePicker(context,
                        //     theme: DatePickerTheme(
                        //       containerHeight: 210.0,
                        //     ),
                        //     showTitleActions: true, onConfirm: (time) {
                        //   print('confirm $time');
                        //   _time1 = '${time.hour} : ${time.minute} : ${time.second}';
                        //   setState(() {});
                        // }, currentTime: DateTime.now(), locale: LocaleType.en);
                        // setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$time2",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    )
                  ],
                ),
              )
              ],);

    final tolocation = new TextField(
      controller: _text5,
      style: TextStyle(fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          labelText: checklang=="Eng" ? textEng[4] : textMyan[4],
          labelStyle: TextStyle(height: 0,color: Colors.black,fontWeight: FontWeight.w600)
          ),
      readOnly: true,
    );
    final remark = new TextField(
      controller: _text6,
      style: TextStyle(fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          labelText: checklang=="Eng" ? textEng[5] : textMyan[5],
          labelStyle: TextStyle(height: 0,color: Colors.black,fontWeight: FontWeight.w600)
          ),
      readOnly: true,
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("ID : ${_text7.text}",style: TextStyle(fontWeight: FontWeight.w300),),
        centerTitle: true,
      ),
      
      body: new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.only(left: 10,top:5,right: 10),
              // height: 380,
              height: MediaQuery.of(context).size.height*0.89,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: fleetno,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: type,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 20),
                      child: depaturedatetime,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: fromLocation,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 20),
                      child: arrivaldatetime,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: tolocation,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: remark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}