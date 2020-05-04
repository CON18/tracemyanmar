import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/version_history.dart';
import 'package:device_id/device_id.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var lan;
  // bool checkAlt = false;
  var labconfirmed = "0";
  var lastupdatedtime = "0";
  var totaldeath = "0";
  var totalpui = "0";
  var totalrecovered = "0";
  var totaltested = "0";

  var deviceId;
  Timer timer11;

  // double a = 223423432342342332342342342342343235234523451345.0;
  // int b;

  var urlAry = [
    {
      "url":
          "https://services7.arcgis.com/AB2LoFxJT2bJUJYC/arcgis/rest/services/CaseCount_With_Cases_150420/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22Tested%22%2C%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=true",
      "name": "totaltested"
    },
    {
      "url":
          "https://services7.arcgis.com/AB2LoFxJT2bJUJYC/arcgis/rest/services/CaseCount_With_Cases_150420/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22PUI%22%2C%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=true",
      "name": "totalpui"
    },
    {
      "url":
          "https://services7.arcgis.com/AB2LoFxJT2bJUJYC/arcgis/rest/services/CaseCount_With_Cases_150420/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22Recovered%22%2C%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=true",
      "name": "totalrecovered"
    },
    {
      "url":
          "https://services7.arcgis.com/AB2LoFxJT2bJUJYC/arcgis/rest/services/CaseCount_With_Cases_150420/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22death%22%2C%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=true",
      "name": "totaldeath"
    },
    {
      "url":
          "https://services7.arcgis.com/AB2LoFxJT2bJUJYC/arcgis/rest/services/CaseCount_With_Cases_150420/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22confirmed%22%2C%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=true",
      "name": "labconfirmed"
    },
  ];

  @override
  void initState() {
    super.initState();

    const oneSecond = const Duration(seconds: 5);
    timer11 = Timer.periodic(
        oneSecond,
        (Timer t) => setState(() {
              _checkNew();
            }));

    bg.BackgroundGeolocation.onLocation(_onLocation);

    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);

    bg.BackgroundGeolocation.start().then((bg.State state) {
      bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
        // print('[changePace] success $isMoving');
        // prefs.setString("changePace", "true");
      }).catchError((e) {
        print('[changePace] ERROR: ' + e.code.toString());
      });
    }).catchError((e) {
      print('[start] ERROR: ' + e.code.toString());
      bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
        // print('[changePace] success $isMoving');
      }).catchError((e) {
        print('[changePace] ERROR1: ' + e.code.toString());
      });
    });

    someMethod();
    _setData();
    // _getSession();

    analyst();
  }

  @override
  void dispose() {
    timer11.cancel();
    // syncTimer.cancel();
    super.dispose();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'Map_Request',
      parameters: <String, dynamic>{
        // 'string': myController.text,
      },
    );
  }

  Future get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future get _localFile async {
    final path = await _localPath;
    return File('$path/qcList.txt');
  }

  Future writeReadList(list) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(list);
  }

  // Future readL() async {
  //   try {
  //     final file = await _localFile;

  //     // Read the file
  //     String rl = await file.readAsString();

  //     return rl;
  //   } catch (e) {
  //     // If we encounter an error, return 0
  //     return 0;
  //   }
  // }

  // getRead() async {
  //   readL().then((res) {
  //     var ab = json.decode(res);
  //     print("RES >> $res" + ab[0].toString());
  //   });
  // }

  void _onLocation(bg.Location location) async {
    // locCount = locCount + 1;
    // print('[location] >>>> ' + location.toString());
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    // print('PRO CHG EVE >>> $event');
    setState(() {
      // _content = encoder.convert(event.toMap());
      // trackingArray.add(_content);
    });
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
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

  _checkNew() async {
    final prefs = await SharedPreferences.getInstance();
    for (var c = 0; c < urlAry.length; c++) {
      // print("URL >> " + urlAry[c]["url"]);
      http.get(urlAry[c]["url"], headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((res) {
        var result = json.decode(res.body);
        // print("RESS >> $result");
        var ress = result["features"];
        var val = ress[0]["attributes"]["value"];

        if (urlAry[c]["name"] == "totaltested") {
          var totaltested = prefs.getString("totaltested") ?? "0";
          if (totaltested != val.toString()) {
            _addData();
          }
        }
        if (urlAry[c]["name"] == "totalpui") {
          var totalpui = prefs.getString("totalpui") ?? "0";
          if (totalpui != val.toString()) {
            _addData();
          }
        }
        if (urlAry[c]["name"] == "totalrecovered") {
          var totalrecovered = prefs.getString("totalrecovered") ?? "0";
          if (totalrecovered != val.toString()) {
            _addData();
          }
        }
        if (urlAry[c]["name"] == "totaldeath") {
          var totaldeath = prefs.getString("totaldeath") ?? "0";
          if (totaldeath != val.toString()) {
            _addData();
          }
        }
        if (urlAry[c]["name"] == "labconfirmed") {
          var labconfirmed = prefs.getString("labconfirmed") ?? "0";
          if (labconfirmed != val.toString()) {
            _addData();
          }
        }
      }).catchError((Object error) async {
        print("ON ERROR >>");
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", "ERROR ON BD TRACKING " + error);
        setState(() {
          labconfirmed = prefs.getString("labconfirmed") ?? "0";
          lastupdatedtime = prefs.getString("lastupdatedtime") ?? "0";
          totaldeath = prefs.getString("totaldeath") ?? "0";
          totalpui = prefs.getString("totalpui") ?? "0";
          totalrecovered = prefs.getString("totalrecovered") ?? "0";
          totaltested = prefs.getString("totaltested") ?? "0";
        });
      });
    }

    // final prefs = await SharedPreferences.getInstance();
    // final url =
    //     'https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/getmohsdata';

    // var body = jsonEncode({});

    // http.post(Uri.encodeFull(url), body: body, headers: {
    //   "Accept": "application/json",
    //   "content-type": "application/json"
    // }).then((res) {
    //   // var result = json.decode(res.body);
    //   var result = json.decode(utf8.decode(res.bodyBytes));
    //   var resStatus = result['code'];
    //   // print("RES >> $result");
    //   if (resStatus == "0000") {
    //     // print("0000 >>>");
    //     setState(() {
    //       // var a;

    //       var lt = prefs.getString("lastupdatedtime") ?? "0";
    //       if (lt != result['lastupdatedtime'].toString()) {
    //         labconfirmed = result['labconfirmed'].toString();
    //         lastupdatedtime = result['lastupdatedtime'].toString();
    //         totaldeath = result['totaldeath'].toString();
    //         totalpui = result['totalpui'].toString();
    //         totalrecovered = result['totalrecovered'].toString();
    //         totaltested = result['totaltested'].toString();
    //         prefs.setString("mohsData", "0");
    //         prefs.setString("labconfirmed", result['labconfirmed'].toString());
    //         prefs.setString(
    //             "lastupdatedtime", result['lastupdatedtime'].toString());
    //         prefs.setString("totaldeath", result['totaldeath'].toString());
    //         prefs.setString("totalpui", result['totalpui'].toString());
    //         prefs.setString(
    //             "totalrecovered", result['totalrecovered'].toString());
    //         prefs.setString("totaltested", result['totaltested'].toString());
    //       } else {
    //         //no change
    //         print("NO CHANGES");
    //       }
    //     });
    //   } else {
    //     print("Other >>");
    //   }
    // }).catchError((Object error) async {
    //   print("ON ERROR >>");
    // });
  }

  convertDateTime() {
    DateTime now = DateTime.now();
    var yr = DateFormat.y().format(now);
    var mn = DateFormat.M().format(now);
    if (mn.length == 1) {
      mn = "0" + mn;
    }
    var dy = DateFormat.d().format(now);
    if (dy.length == 1) {
      dy = "0" + dy;
    }
    var time = new DateFormat.jm().format(now);
    var dt = dy + "-" + mn + "-" + yr + " " + time;
    return dt;
  }


  _setData() async {
    // final prefs = await SharedPreferences.getInstance();
    // List ary = [
    //   {"no": "100"},
    //   {"no": "101"}
    // ];
    // prefs.setStringList("testdata", ary);
    final prefs = await SharedPreferences.getInstance();
    var chkAlt = prefs.getString("mohsData") ?? "0";
    if (chkAlt == "1") {
      print("MOHS1111 >>>>>>>");

      // final url = url2 + '/module001/serviceRegisterTraceMyanmar/getmohsdata';
      // final url =
      //     "https://services7.arcgis.com/AB2LoFxJT2bJUJYC/arcgis/rest/services/CaseCount_With_Cases_150420/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22Tested%22%2C%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=true";

      // var body = jsonEncode({});

      _addData();
    } else {
      print("MOHS000 >>>>>>>");
      setState(() {
        labconfirmed = prefs.getString("labconfirmed") ?? "0";
        lastupdatedtime = prefs.getString("lastupdatedtime") ?? "0";
        totaldeath = prefs.getString("totaldeath") ?? "0";
        totalpui = prefs.getString("totalpui") ?? "0";
        totalrecovered = prefs.getString("totalrecovered") ?? "0";
        totaltested = prefs.getString("totaltested") ?? "0";
      });
    }
  }

  Future<bool> popped() {
    // DateTime now = DateTime.now();
    // if (current == null || now.difference(current) > Duration(seconds: 2)) {
    //   current = now;
    //   Fluttertoast.showToast(
    //     msg: "Press back Again To exit !",
    //     toastLength: Toast.LENGTH_SHORT,
    //   );
    //   return Future.value(false);
    // } else {
    Fluttertoast.cancel();
    return Future.value(true);
    // }
  }

  _addData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("mohsData", "0");
    for (var c = 0; c < urlAry.length; c++) {
      print("URL >> " + urlAry[c]["url"]);
      http.get(urlAry[c]["url"], headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((res) {
        var result = json.decode(res.body);
        print("RESS >> $result");
        var ress = result["features"];
        var val = ress[0]["attributes"]["value"];
        if (urlAry[c]["name"] == "totaltested") {
          totaltested = val.toString();
          prefs.setString("totaltested", val.toString());
        }
        if (urlAry[c]["name"] == "totalpui") {
          totalpui = val.toString();
          prefs.setString("totalpui", val.toString());
        }
        if (urlAry[c]["name"] == "totalrecovered") {
          totalrecovered = val.toString();
          prefs.setString("totalrecovered", val.toString());
        }
        if (urlAry[c]["name"] == "totaldeath") {
          totaldeath = val.toString();
          prefs.setString("totaldeath", val.toString());
        }
        if (urlAry[c]["name"] == "labconfirmed") {
          labconfirmed = val.toString();
          prefs.setString("labconfirmed", val.toString());
        }
        var date = convertDateTime();
        prefs.setString("lastupdatedtime", date.toString());
        lastupdatedtime = date.toString();
      }).catchError((Object error) async {
        print("ON ERROR >>");
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", "ERROR ON BD TRACKING " + error);
        setState(() {
          labconfirmed = prefs.getString("labconfirmed") ?? "0";
          lastupdatedtime = prefs.getString("lastupdatedtime") ?? "0";
          totaldeath = prefs.getString("totaldeath") ?? "0";
          totalpui = prefs.getString("totalpui") ?? "0";
          totalrecovered = prefs.getString("totalrecovered") ?? "0";
          totaltested = prefs.getString("totaltested") ?? "0";
        });
      });
    }
  }

  _openUrl() async {
    var url =
        // "https://mohs.gov.mm/Main/content/publication/2019-ncov?fbclid=IwAR0H_MN_Vj3tXxDFeoBpLrqWQjTZ6C2MbP52X_tSy1jm6PTx0ozozLmqF2c";
        "https://www.mohs.gov.mm/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onRefresh() async {
    print("REFRESH >>");
    await Future.delayed(Duration(milliseconds: 1000));
    final url = url2 + '/module001/serviceRegisterTraceMyanmar/getmohsdata';

    var body = jsonEncode({});
    final prefs = await SharedPreferences.getInstance();
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((res) {
      // var result = json.decode(res.body);
      var result = json.decode(utf8.decode(res.bodyBytes));
      var resStatus = result['code'];
      print("RES >> $result");
      if (resStatus == "0000") {
        print("0000 >>>");
        setState(() {
          // var a;
          // prefs.setString("mohsData", "0");
          // prefs.setString("labconfirmed", result['labconfirmed'].toString());
          // prefs.setString("lastupdatedtime", result['lastupdatedtime'].toString());
          // prefs.setString("totaldeath", result['totaldeath'].toString());
          // prefs.setString("totalpui", result['totalpui'].toString());
          // prefs.setString("totalrecovered", result['totalrecovered'].toString());
          // prefs.setString("totaltested", result['totaltested'].toString());
          labconfirmed = result['labconfirmed'].toString();
          lastupdatedtime = result['lastupdatedtime'].toString();
          totaldeath = result['totaldeath'].toString();
          totalpui = result['totalpui'].toString();
          totalrecovered = result['totalrecovered'].toString();
          totaltested = result['totaltested'].toString();
          prefs.setString("labconfirmed", result['labconfirmed'].toString());
          prefs.setString(
              "lastupdatedtime", result['lastupdatedtime'].toString());
          prefs.setString("totaldeath", result['totaldeath'].toString());
          prefs.setString("totalpui", result['totalpui'].toString());
          prefs.setString(
              "totalrecovered", result['totalrecovered'].toString());
          prefs.setString("totaltested", result['totaltested'].toString());
        });
      } else {
        // print("Other >>");
        // setState(() {
        //   labconfirmed = prefs.getString("labconfirmed") ?? "0";
        //   lastupdatedtime = prefs.getString("lastupdatedtime") ?? "0";
        //   totaldeath = prefs.getString("totaldeath") ?? "0";
        //   totalpui = prefs.getString("totalpui") ?? "0";
        //   totalrecovered = prefs.getString("totalrecovered") ?? "0";
        //   totaltested = prefs.getString("totaltested") ?? "0";
        // });
      }
    }).catchError((Object error) async {
      print("ON ERROR >>");
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString("errorLog", "ERROR ON BD TRACKING " + error);
      // setState(() {
      //   labconfirmed = prefs.getString("labconfirmed") ?? "0";
      //   lastupdatedtime = prefs.getString("lastupdatedtime") ?? "0";
      //   totaldeath = prefs.getString("totaldeath") ?? "0";
      //   totalpui = prefs.getString("totalpui") ?? "0";
      //   totalrecovered = prefs.getString("totalrecovered") ?? "0";
      //   totaltested = prefs.getString("totaltested") ?? "0";
      // });
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        key: _scaffoldkey,
        // body: WebViewContainer(key: webViewKey),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          // header: WaterDropHeader(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Column(
                children: <Widget>[
                  // Card(child:
                  ListTile(
                    leading: Container(
                      // width: 100,
                      // height: 100,
                      child: Image.asset("assets/mohs_qr.png"),
                    ),
                    title: Text(
                      "Coronavirus Disease 2019",
                      style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      // "",
                      lan == "Zg"
                          ? Rabbit.uni2zg(
                              "လတ်တလောအသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါ")
                          : "လတ်တလောအသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါ",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.red[900],
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                      ),
                    ),
                  ),
                  // ),
                  SizedBox(
                    height: 15.0,
                  ),

                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text("COVID-19 Surveillance Dashboard (MM)",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            )),
                      )
                    ],
                  ),
                  //First Row
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        // height: 100.0,
                        decoration: BoxDecoration(
                          // border: Border(
                          //   top: BorderSide(width: 3.0, color: Colors.white60),
                          // ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 0.1),
                                blurRadius: 15)
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                lan == "Zg"
                                    ? Rabbit.uni2zg(
                                        "ဓာတ်ခွဲစစ်ဆေးသူ\nစုစုပေါင်း")
                                    : "ဓာတ်ခွဲစစ်ဆေးသူ\nစုစုပေါင်း",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              // new Container(
                              //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                              //     height: 2.0,
                              //     width: 35.0,
                              //     color: Colors.pink[200]),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                totaltested,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.lightBlue[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        // height: 100.0,
                        decoration: BoxDecoration(
                          // border: Border(
                          //   top: BorderSide(width: 3.0, color: Colors.white60),
                          // ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 0.1),
                                blurRadius: 15)
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                lan == "Zg"
                                    ? Rabbit.uni2zg("ပိုးတွေ့\nပြန်လည်သက်သာ")
                                    : "ပိုးတွေ့\nပြန်လည်သက်သာ",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              // new Container(
                              //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                              //     height: 2.0,
                              //     width: 35.0,
                              //     color: Colors.pink[200]),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                totalrecovered,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  //Second Row
                  // SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        // height: 100.0,
                        decoration: BoxDecoration(
                          // border: Border(
                          //   top: BorderSide(width: 3.0, color: Colors.white60),
                          // ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 0.1),
                                blurRadius: 15)
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                lan == "Zg"
                                    ? Rabbit.uni2zg(
                                        "စောင့်ကြည့်လူနာ\nစုစုပေါင်း")
                                    : "စောင့်ကြည့်လူနာ\nစုစုပေါင်း",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              // new Container(
                              //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                              //     height: 2.0,
                              //     width: 35.0,
                              //     color: Colors.pink[200]),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                totalpui,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.lightBlue[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        // height: 100.0,
                        decoration: BoxDecoration(
                          // border: Border(
                          //   top: BorderSide(width: 3.0, color: Colors.white60),
                          // ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 0.1),
                                blurRadius: 15)
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                lan == "Zg"
                                    ? Rabbit.uni2zg("ပိုးတွေ့\nသေဆုံးလူနာ")
                                    : "ပိုးတွေ့\nသေဆုံးလူနာ",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              // new Container(
                              //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                              //     height: 2.0,
                              //     width: 35.0,
                              //     color: Colors.pink[200]),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                totaldeath,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  //Third Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        // height: 80.0,
                        decoration: BoxDecoration(
                          // border: Border(
                          //   top: BorderSide(width: 3.0, color: Colors.white60),
                          // ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 0.1),
                                blurRadius: 15)
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                lan == "Zg"
                                    ? Rabbit.uni2zg("ပိုးတွေ့စုစုပေါင်း")
                                    : "ပိုးတွေ့စုစုပေါင်း",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              // new Container(
                              //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                              //     height: 2.0,
                              //     width: 35.0,
                              //     color: Colors.pink[200]),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                labconfirmed,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: lastupdatedtime == "0"
                            ? Text(
                                "Offline",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.lightBlue),
                              )
                            : Text(
                                "Last updated on $lastupdatedtime",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.lightBlue),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    decoration: BoxDecoration(
                      // border: Border(
                      //   top: BorderSide(width: 3.0, color: Colors.white60),
                      // ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 0.1),
                            blurRadius: 15)
                      ],
                      // color: Colors.lightBlue,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      child: RaisedButton(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5.0),
                        // ),
                        color: Colors.blue,
                        onPressed: () async {
                          // _getCurrentLocation();
                          _openUrl();
                        },
                        child: Text(
                          "MOHS Website",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
