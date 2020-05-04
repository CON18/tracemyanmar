import 'dart:async';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:TraceMyanmar/QR/generateqr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fleetdetail.dart';
import 'fleetlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Fleet extends StatefulWidget {
  @override
  _FleetState createState() => _FleetState();
}

class _FleetState extends State<Fleet> {
  final TextEditingController _text1 = new TextEditingController();
  final TextEditingController _text2 = new TextEditingController();
  final TextEditingController _text3 = new TextEditingController();
  final TextEditingController _text4 = new TextEditingController();
  final TextEditingController _text5 = new TextEditingController();
  var data;
  String _date1 = "Not set";
  String _time1 = "Not set";
  String _date2 = "Not set";
  String _time2 = "Not set";
  String uu = '';
  bool success = false;
  String typeValue = '';
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  String checklang = '';
  List textMyan = [
    // လမ်း‌ကြောင်း
    "မှတ်ပုံတင် (Register)",
    "ID",
    "အမျိုးအစား",
    "စတင်သည့် ​နေ့ရက်​/အချိန်​",
    "မှ",
    "​​ပြီးဆုံးသည့် ​နေ့ရက်​/အချိန်​",
    "သို့",
    "အ​ကြောင်းအရာ",
    "ပယ်ဖျက်မည်",
    "သိမ်းဆည်းမည်",
    "QR ထုတ်​မည်​"
  ];
  List textEng = [
    // လမ်း‌ကြောင်း
    "မှတ်ပုံတင် (Register)",
    "ID",
    "Type:",
    "Departure Date Time",
    "From:",
    "Arrival Date Time",
    "To:",
    "Remark",
    "Cancel",
    "Save",
    "QR Generate"
  ];

  var _start;
  Timer timer;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    checkLanguage();
    getstorage();
    // dbHelper = DBHelper();
    // _checkAndstartTrack();
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  checkLanguage() async {
    // final prefs = await SharedPreferences.getInstance();
    // checklang = prefs.getString("Lang");
    // if (checklang == "" || checklang == null || checklang.length == 0) {
    // checklang = "Eng";
    // } else {
    checklang = "Myanmar";
    // }

    setState(() {});
  }

  getstorage() async {
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('UserId');
    print(uu);
  }

  _savefleep() async {
    // String url = "http://103.101.18.229:8080/TraceService/module001/service004/saveFleep";
    String url =
        "https://service.mcf.org.mm/tracemyanmar/module001/service004/saveFleep";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "phoneNo": "' +
        '$uu' +
        '","fleepNo": "' +
        _text1.text +
        "|" +
        typeValue +
        '","depatureDateTime": "' +
        _date1 +
        "|" +
        _time1 +
        '","fromLocation": "' +
        _text3.text +
        '","arrivalDateTime": "' +
        _date2 +
        "|" +
        _time2 +
        '","toLocation": "' +
        _text4.text +
        '", "remark": "' +
        _text5.text +
        '","t1": "' +
        typeValue +
        '" }';
    print(json);
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      data = jsonDecode(body.toString());
      print(data);
      if (data['code'] == "0000") {
        alertmsg = data['desc'];
        this.snackbarmethod();
        final prefs = await SharedPreferences.getInstance();
        final keyskey = 'SysKey';
        final syskey = data['skey'];
        prefs.setString(syskey, keyskey);
        final keyfleetno = 'FleetNo';
        final fleetno = data['fleetNo'];
        prefs.setString(fleetno, keyfleetno);
        // _text1.text = "";
        // _text3.text = "";
        // _text4.text = "";
        // _text5.text = "";
        // _date1 = "Not set";
        // _time1 = "Not set";
        // _date2 = "Not set";
        // _time2 = "Not set";
        success = true;
        setState(() {});
      } else {
        alertmsg = data['desc'];
        this.snackbarmethod();
      }
    } else {
      print("Connection Fail");
      setState(() {});
    }
  }

  final FocusNode _txt1Focus = FocusNode();
  final FocusNode _txt2Focus = FocusNode();
  final FocusNode _txt3Focus = FocusNode();
  final FocusNode _txt4Focus = FocusNode();
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    _txt1Focus.dispose();
    _txt2Focus.dispose();
    _txt3Focus.dispose();
    _txt4Focus.dispose();
  }

  final List<String> _dropdownType = [
    "",
    "လေကြောင်း",
    "ရထား",
    "ဘတ်စ်ကား",
    "လိုင်းကား",
    "အငှားကား",
    "ဆိုက်ကား",
    "အခြား"
  ];

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final fleetno = new TextField(
      style: TextStyle(fontWeight: FontWeight.w300),
      controller: _text1,
      decoration: InputDecoration(
          labelText: "ID",
          labelStyle:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
      focusNode: _txt1Focus,
      onSubmitted: (value) {
        _txt1Focus.unfocus();
        _txt2Focus.requestFocus();
      },
    );
    final type = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(5.0)),
        Text(
          checklang == "Eng" ? textEng[2] : textMyan[2],
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        Container(
          height: 50,
          child: DropdownButton(
            items: _dropdownType
                .map((value) => DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    ))
                .toList(),
            onChanged: (String value) {
              typeValue = value;
              print("division " + typeValue);
              setState(() {});
            },
            value: typeValue.toString(),
            style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
            isExpanded: true,
            hint: Text('Please Choose type'),
          ),
        ),
      ],
    );
    final departure = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          checklang == "Eng" ? textEng[3] : textMyan[3],
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
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
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    print('confirm $date');
                    _date1 = '${date.day} - ${date.month} - ${date.year}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                            " $_date1",
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
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    print('confirm $time');
                    _time1 = '${time.hour} : ${time.minute} : ${time.second}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
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
                            " $_time1",
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
      ],
    );
    final arrival = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          checklang == "Eng" ? textEng[5] : textMyan[5],
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
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
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    print('confirm $date');
                    _date2 = '${date.day} - ${date.month} - ${date.year}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                            " $_date2",
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
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    print('confirm $time');
                    _time2 = '${time.hour} : ${time.minute} : ${time.second}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
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
                            " $_time2",
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
      ],
    );
    final fromdepart = new TextField(
      controller: _text3,
      style: TextStyle(fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        labelText: checklang == "Eng" ? textEng[4] : textMyan[4],
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 17,
                color: Colors.black,
                height: 0,
                fontWeight: FontWeight.w700,
              )
            : TextStyle(
                fontSize: 16,
                color: Colors.black,
                height: 0,
                fontWeight: FontWeight.w700),
      ),
      focusNode: _txt2Focus,
      onSubmitted: (value) {
        _txt2Focus.unfocus();
        _txt3Focus.requestFocus();
      },
    );
    final toarrive = new TextField(
      controller: _text4,
      style: TextStyle(fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        labelText: checklang == "Eng" ? textEng[6] : textMyan[6],
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 17,
                color: Colors.black,
                height: 0,
                fontWeight: FontWeight.w700)
            : TextStyle(
                fontSize: 16,
                color: Colors.black,
                height: 0,
                fontWeight: FontWeight.w700),
      ),
      focusNode: _txt3Focus,
      onSubmitted: (value) {
        _txt3Focus.unfocus();
        _txt4Focus.requestFocus();
      },
    );
    final remark = new TextField(
      controller: _text5,
      // minLines: 2,
      // maxLength: 5,
      keyboardType: TextInputType.multiline,
      style: TextStyle(fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        labelText: checklang == "Eng" ? textEng[7] : textMyan[7],
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 17,
                color: Colors.black,
                height: 0,
                fontWeight: FontWeight.w700)
            : TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 0,
                fontWeight: FontWeight.w700),
      ),
      focusNode: _txt4Focus,
      onSubmitted: (value) {
        _txt4Focus.unfocus();
      },
    );

    // final cancelbutton = new RaisedButton(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(5.0),
    //   ),
    //   onPressed: () async {
    //     Navigator.pop(context);
    //   },
    //   color: Colors.grey[300],
    //   textColor: Colors.white,
    //   child: Container(
    //     width: 120.0,
    //     height: 38.0,
    //     child: Center(
    //         child: Text(checklang == "Eng" ? textEng[8] : textMyan[8],
    //             style: TextStyle(
    //               fontSize: 17,
    //               color: Colors.black,
    //               fontWeight: FontWeight.w300,
    //             ))),
    //   ),
    // );

    final qrgenerate = IgnorePointer(
      ignoring: success ? false : true,
      child: new RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Generateqr(
                        userid: uu,
                        skey: data['skey'],
                        rid: data['fleetNo'],
                        remark: _text5.text,
                      )));
        },
        color: success ? Colors.blue : Colors.grey,
        textColor: Colors.white,
        child: Center(
            child: Text(checklang == "Eng" ? textEng[10] : textMyan[10],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );
    final fleepbutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () async {
        _savefleep();
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Container(
        // width: 120.0,
        height: 38.0,
        child: Center(
            child: Text(checklang == "Eng" ? textEng[9] : textMyan[9],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          checklang == "Eng" ? textEng[0] : textMyan[0],
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16.5),
        ),
        centerTitle: true,
        // actions: <Widget>[
        //   PopupMenuButton<int>(
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         value: 1,
        //         child: Text("Fleet List"),
        //       ),
        //       // PopupMenuItem(
        //       //   value: 2,
        //       //   child: Text("Fleet Detail"),
        //       // ),
        //     ],
        //     // initialValue: 2,
        //     onCanceled: () {
        //       print("You have canceled the menu.");
        //     },
        //     onSelected: (value) {
        //       print("value:$value");
        //       if (value == 1) {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => FleetList()),
        //         );
        //       }
        //       // else if (value == 2) {
        //       //   Navigator.push(
        //       //       context,
        //       //       MaterialPageRoute(
        //       //           builder: (context) => FleetDetail(
        //       //                 phoneno: "",
        //       //                 fleepno: _text1.text + "|" + typeValue,
        //       //                 depaturedatetime: _date1 + "|" + _time1,
        //       //                 fromLocation: _text3.text,
        //       //                 arrivaldatetime: _date2 + "|" + _time2,
        //       //                 tolocation: _text4.text,
        //       //                 remark: _text5.text,
        //       //               )));
        //       // }
        //     },
        //     // icon: Icon(Icons.list),
        //   ),
        // ],
      ),
      body: new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10),
              // height: 380,
              height: 750,
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
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                      child: departure,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: fromdepart,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                      child: arrival,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: toarrive,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: remark,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.99,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            // child: cancelbutton,
                            child: qrgenerate,
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: fleepbutton,
                          )
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // new Container(
                    //   padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    //   child: qrgenerate,
                    // ),
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
