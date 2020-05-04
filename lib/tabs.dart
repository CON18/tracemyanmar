import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:TraceMyanmar/Drawer/drawer.dart';
import 'package:TraceMyanmar/Intro/TC.dart';
import 'package:TraceMyanmar/Intro/about.dart';
import 'package:TraceMyanmar/contact/contact_list.dart';
import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/news.dart';
import 'package:TraceMyanmar/notification/noti_list.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tracking/bgd_tracking.dart';
import 'package:TraceMyanmar/version_history.dart';
import 'package:TraceMyanmar/version_update.dart';
import 'package:TraceMyanmar/webview_info.dart';
import 'package:device_id/device_id.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter/widgets.dart';
import 'package:version/version.dart';

JsonEncoder encoder = new JsonEncoder.withIndent("     ");

class TabsPage extends StatefulWidget {
  final int openTab;
  // final String chatkey;
  TabsPage({
    Key key,
    @required this.openTab,
    //   @required this.chatkey
  }) : super(key: key);
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> with TickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static const _kFontFam = 'MyFlutterApp';
  static const _kFontPkg = null;
  static const IconData globe =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData th =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  FirebaseAnalytics analytics = FirebaseAnalytics();
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final String url =
      // "https://play.google.com/store/apps/details?id=com.mit.TraceMyanmar2020&hl=en";
      "https://play.google.com/store/apps/details?id=mm.org.mcf.app001&fbclid=IwAR2RrRWNckJRWiZfdTBz2y2mnjMOMHtOJpPvS7NI_i1LE-GLczFYg-x3vno";
  String checklang = '';
  List textMyan = [];
  List textEng = [];
  var dbHelper;
  var deviceId;
  var location;
  var _syncstart;
  var _start;
  var lan;

  int startInterval = 0;
  Timer submitTimer;

  int syncInterval = 0;
  Timer syncTimer;

  int locDistance = 0;

  var showNoti = "0";

  double calDisc(lat1, lon1, lat2, lon2) {
    final Distance distance = new Distance();
    var meter = distance(new LatLng(double.parse(lat1), double.parse(lon1)),
        new LatLng(double.parse(lat2), double.parse(lon2)));
    return meter;
  }

  @override
  void initState() {
    super.initState();
    textMyan = [
      "GPS Check In",
      "QR Check In",
      "တင်ပို့ပါ",
      "ဗားရှင်း " + version
    ];
    textEng = ["GPS Check In", "QR Check In", "Submit", "Version " + version];
    checklang = "Myanmar";
    _tabController = new TabController(vsync: this, length: 5);
    _tabController.index = widget.openTab;
    // onTabTapped(1);
    _getDeviceId();
    _getCurrentLocation();
    dbHelper = DBHelper();

    someMethod();
    analyst();
    _checkNewVersion();
    setState(() {
      _getSession();
    });
  }

  @override
  void dispose() {
    submitTimer.cancel();
    syncTimer.cancel();
    _tabController.dispose();
    super.dispose();
  }

  convertDateTime24hrs() {
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
    var time = new DateFormat.Hms().format(now);

    var dt = yr + "-" + mn + "-" + dy + " " + time;
    return dt;
  }

  _getSession() async {
    print("GS >>");

    deviceId = await DeviceId.getID;
    final prefs = await SharedPreferences.getInstance();
    var fcmToken = prefs.getString("fcmToken") ?? "";

    if (fcmToken == "") {
      _firebaseMessaging.getToken().then((token) {
        print("TOKEN >> " + token.toString());
        // token = token;
        prefs.setString("fcmToken", token.toString());
        getnewSession(token);
        // var chkAlt = prefs.getString("mohsData") ?? "0";
        // if (chkAlt == "1") {
        //   print("TTT1>>");
        // _getversion(token);
        // }
      });
    } else {
      // print("Token already exist >> $tok");
      getnewSession(fcmToken);
    }

    // var sk = prefs.getString("getsessionkey") ?? "";
    // var si = prefs.getString("getsessionid") ?? "";
  }

  getnewSession(fcmToken) async {
    final prefs = await SharedPreferences.getInstance();
    var gsk = prefs.getString("getsessionkey") ?? "";
    var gsi = prefs.getString("getsessionid") ?? "";
    if (gsk == "" || gsi == "") {
      // if (sk == "" || si == "") {
      // snackbarmethod1("GET SESSION >>" + deviceId.toString());
      setState(() {
        String url =
            // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/getsession";
            // "http://sawsawsharservice.azurewebsites.net/module001/serviceRegisterTraceMyanmar/getsession";
            // "https://sssuat.azurewebsites.net/module001/serviceRegisterTraceMyanmar/getsession";
            // "http://uatsssverify.azurewebsites.net/module001/serviceRegisterTraceMyanmar/getsession";
            url2 + "/module001/serviceRegisterTraceMyanmar/getnewsession";
        // "http://52.187.13.89:8080/tracemyanmar/module001/service004/saveUser";
        var body;
        // if (curUserId == null) {
        //   body = jsonEncode(
        //       {"uuid": deviceId, "fcmtoken": fcmToken, "phoneno": ""});
        // } else {
        var ltime = convertDateTime24hrs();
        body = jsonEncode(
            {"uuid": deviceId, "fcmtoken": fcmToken, "localtime": ltime});
        // }
        snackbarmethod1("BODY >> " + body.toString());
        // print("SE BODY >> " + body.toString());
        http.post(url, body: body, headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        }).then((dynamic res) async {
          var result = json.decode(utf8.decode(res.bodyBytes));
          var resStatus = result['desc'];
          var sKey = result['key'];
          var sId = result['sessionid'];
          print("CODE >> " + sKey.toString() + "|" + sId.toString());
          // snackbarmethod1("CODE $sKey | $sId");
          if (resStatus == 'Success') {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString("getsessionkey", sKey);
            prefs.setString("getsessionid", sId);
            var chkAlt = prefs.getString("getversion") ?? "0";
            // snackbarmethod1("MD1 >> $chkAlt");
            if (chkAlt == "1") {
              print("TTT>>");
              _getversion(fcmToken);
            }
          }
        });
      });
    } else {
      print("NONEED>> $gsk | $gsi");
      var chkAlt = prefs.getString("getversion") ?? "0";
      // snackbarmethod1("MD >> $chkAlt");
      if (chkAlt == "1") {
        print("TTT>>");
        _getversion(fcmToken);
      }
    }
  }

  _getversion(fcmToken) async {
    // snackbarmethod1("AAA");
    String url = url2 + "/module001/serviceRegisterTraceMyanmar/getversion";

    final prefs = await SharedPreferences.getInstance();
    var userPhone = prefs.getString("UserId") ?? "";
    var ltime = convertDateTime24hrs();
    var gsk = prefs.getString("getsessionkey") ?? "";
    var gsi = prefs.getString("getsessionid") ?? "";
    var body = jsonEncode({
      "uuid": deviceId.toString(),
      "phoneno": userPhone.toString(),
      "sessionid": gsi.toString(),
      "hash": gsk.toString(),
      "fcmtoken": fcmToken.toString(),
      "localtime": ltime.toString(),
      "version": version.toString()
    });
    print("GV BDY >> " + body.toString());
    // snackbarmethod1(body.toString());
    http.post(url, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) async {
      print("ResponseGV >> " + res.toString());
      var result = json.decode(utf8.decode(res.bodyBytes));
      var resStatus = result['code'];
      setState(() {
        prefs.setInt("submitinterval", int.parse(result['submitinterval']));
        prefs.setInt("datainterval", int.parse(result['datainterval']));
        prefs.setInt("meter", int.parse(result['meter']));
        prefs.setInt("retention", int.parse(result['retention']));
        prefs.setInt("keytype", int.parse(result['keytype']));

        startInterval = int.parse(result['submitinterval']);
        // startInterval = 180;
        // syncInterval = int.parse(result['datainterval'].toString());
        syncInterval = 120;
        locDistance = int.parse(result['meter'].toString());
        print("DATAINTERVAL >> $syncInterval");
        // snackbarmethod1("datainterval $syncInterval");
        _checkTimer();
        _checkAutoSync();

        _syncList("0");
      });

      if (resStatus == '0000') {
        //0000
      } else {
        getnewSession(fcmToken);
      }
      prefs.setString("getversion", "0");
    });
  }

  analyst() async {
    await analytics.logEvent(
      name: 'Tabs_Request',
      parameters: <String, dynamic>{
        // 'string': myController.text,
      },
    );
  }

  _checkNewVersion() async {
    Version currentVersion = new Version(v1, v2, v3);

    final prefs = await SharedPreferences.getInstance();
    var bt = prefs.getInt("buildType") ?? 0;
    if (bt == 0) {
      // final prefs = await SharedPreferences.getInstance();
      prefs.setInt("buildType", 0);
      http.get(
          "https://www.sawsawshar.gov.mm//module001/serviceRegister/getVersion",
          // "http://uatsssverify.azurewebsites.net/module001/serviceRegister/getVersion/",
          // url2 + "/module001/serviceRegister/getVersion",
          // "http://cloud169.temp.domains/~va2uwycr/module001/serviceRegister/getVersion/",
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          }).then((dynamic res) async {
        var result = json.decode(utf8.decode(res.bodyBytes));
        var resStatus = result['version'];
        print("Version 111 >> " + resStatus.toString());
        setState(() {
          Version latestVersion = Version.parse(resStatus);

          if (latestVersion > currentVersion) {
            showNoti = "1";
          } else {
            showNoti = "0";
          }

          // if (resStatus == version) {
          //   // checkNewVersion = false;
          //   showNoti = "0";
          // } else {
          //   // checkNewVersion = true;
          //   // versionNo = resStatus;
          //   showNoti = "1";
          // }
        });
      }).catchError((Object error) async {
        // checkNewVersion = true;
        // versionNo = "x.x.xx";
        // showNoti = "1";
      });
    }
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

//-->>For sync timer
  _checkAutoSync() async {
    final prefs = await SharedPreferences.getInstance();
    int val = prefs.getInt("autoSyncTimer") ?? 0;

    if (val == 0) {
      _syncstart = syncInterval;
      countDownSaveForSync();
    } else {
      _syncstart = val.toString();
      countDownSaveForSync();
    }
  }

  countDownSaveForSync() {
    print("START >> $_syncstart");
    const oneSec = const Duration(seconds: 1);
    syncTimer = Timer.periodic(
      oneSec,
      (Timer t) => setState(
        () {
          if (_syncstart == 0) {
            // _getCurrentLocationForTrack();
            // sendData();
            _syncList("1");
            syncTimer.cancel();
          } else {
            _syncstart = int.parse(_syncstart.toString()) - 1;
            savesyncTimer();
            // print("Sec>>" + _start.toString());
          }
          // print("CD11 >> " + _syncstart.toString());
        },
      ),
    );
  }

  savesyncTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("autoSyncTimer", _syncstart);
  }

  //-->>End for sync timer
  //-->>For submitting timer
  _checkTimer() async {
    final prefs = await SharedPreferences.getInstance();
    int val = prefs.getInt("timer") ?? 0;

    if (val == 0) {
      _start = startInterval;
      countDownSave();
    } else {
      _start = val.toString();
      countDownSave();
    }
  }

  countDownSave() {
    print("START >> $_start");
    const oneSec = const Duration(seconds: 1);
    submitTimer = Timer.periodic(
      oneSec,
      (Timer t) => setState(
        () {
          if (_start == 0) {
            // _getCurrentLocationForTrack();
            sendData1();
            submitTimer.cancel();
          } else {
            _start = int.parse(_start.toString()) - 1;
            saveTimer();
            // print("Sec>>" + _start.toString());
          }

          // if (_start == 10) {
          //   _syncList("1");
          // }
          // print("CD >> " + _start.toString());
        },
      ),
    );
  }

  saveTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("timer", _start);
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    var hr = parts[0].padLeft(2, '0');
    var hours;

    if (hr == "24") {
      hours = "00";
    } else if (hr == "25") {
      hours = "01";
    } else if (hr == "26") {
      hours = "02";
    } else if (hr == "27") {
      hours = "03";
    } else if (hr == "28") {
      hours = "04";
    } else if (hr == "29") {
      hours = "05";
    } else if (hr == "30") {
      hours = "06";
    } else {
      hours = hr;
    }
    return '${hours}:${parts[1].padLeft(2, '0')}:00';
  }

  sendData1() async {
    // print("DATE >> $dt");
    // snackbarmethod1("Loading...");
    final prefs = await SharedPreferences.getInstance();
    var ph = prefs.getString('UserId');
    var setList = [];
    setList = await dbHelper.getEmployees();
    // setState(() {});
    var data = [];
    var comTime;
    for (var i = 0; i < setList.length; i++) {
      // print("AAA >> ${setList[i].location}");
      if (setList[i].location == null || setList[i].location == "") {
      } else {
        if (setList[i].color.toString() == "0") {
          if (i == 0) {
            comTime = setList[i].time.toString();
          } else {
            comTime = setList[i - 1].time.toString();
          }

          var ii1 = comTime.indexOf('T');
          var yr1 = comTime.substring(0, 4);
          var mn1 = comTime.substring(5, 7);
          var dy1 = comTime.substring(8, 10);
          var hr1 = comTime.substring(ii1 + 1, ii1 + 3);
          var mi1 = comTime.substring(ii1 + 4, ii1 + 6);
          final coTime = DateTime(int.parse(yr1), int.parse(mn1),
              int.parse(dy1), int.parse(hr1), int.parse(mi1));

          var ii = setList[i].time.toString().indexOf('T');
          var yr = setList[i].time.toString().substring(0, 4);
          var mn = setList[i].time.toString().substring(5, 7);
          var dy = setList[i].time.toString().substring(8, 10);
          var hr = setList[i].time.toString().substring(ii + 1, ii + 3);
          var mi = setList[i].time.toString().substring(ii + 4, ii + 6);
          final gcTime = DateTime(int.parse(yr), int.parse(mn), int.parse(dy),
              int.parse(hr), int.parse(mi));

          var duration = gcTime.difference(coTime).inMinutes.toString();

          var index = setList[i].location.toString().indexOf(',');
          // [{"mid":null,"did":"4e2f63299f46aa50","mhash":"","dhash":"","timestamp":"2020-04-13","duration":1.0,"lat":22.909595,"lng":96.4212117,"source":"TraceMyanmar","eventname":null,"location":"22.909595, 96.4212117","remark":"","contact":"","contacttype":"GPS"}]
          // print("DATE >> " + setList[i].time.toString());
          // var timestamp = setList[i].time.toString().substring(0, 10);
          // print("timestamp>> $timestamp");
          data.add({
            "mid": ph,
            "did": deviceId,
            "mhash": deviceId,
            "dhash": "",
            "timestamp": setList[i].time.toString(),
            "duration": double.parse(duration),
            "lat": double.parse(
                setList[i].location.toString().substring(0, index)),
            "lng": double.parse(
                setList[i].location.toString().substring(index + 1)),
            "source": submitSource,
            "eventname": setList[i].rid,
            "location": setList[i].location,
            "remark": setList[i].remark.toString(),
            "contact": "",
            "contacttype": "GPS"
            // "time": setList[i].time
          });
        }
      }
    }
    //http://192.168.205.137:8081/IonicDemoService/module001/service005/saveUser

    // final url = 'https://api.mcf.org.mm/api/people_history/insertmany';
    // final url = 'http://uattrackingapi.azurewebsites.net/api/people_history/insertmany';
    final url = url1 + "/api/people_history/insertmany";
    var body = jsonEncode(data);
    print("BDY >> " + body);
    if (body == "[]") {
      _start = startInterval;
      countDownSave();
    } else {
      http.post(Uri.encodeFull(url), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((res) {
        var result = json.decode(res.body);
        print("RES >> $result");
        if (result == 0) {
          for (var i = 0; i < setList.length; i++) {
            // print("AAA 111 >> ${setList[i].id}");
            if (setList[i].location == null ||
                setList[i].location == "" ||
                setList[i].color.toString() == "1") {
            } else {
              // print("BBB >>>>");
              Employee e = Employee(
                  int.parse(setList[i].id.toString()),
                  setList[i].location,
                  setList[i].time,
                  setList[i].rid,
                  "1",
                  setList[i].remark);
              dbHelper.update(e);
            }
          }
          // this.snackbarmethod1("Submitted  Successfully.");
          setState(() {
            _start = startInterval;
            countDownSave();
          });

          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => TabsPage(
          //         openTab: 1,
          //       ),
          //     ));
        } else {
          this.snackbarmethod1("Can not submit");
        }
      }).catchError((Object error) async {
        print("ON ERROR 222 >>");
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", error);
        _start = startInterval;
        countDownSave();
      });
    }
  }
  //-->>End for submitting timer

  _syncList(String check) async {
    int count = await bg.BackgroundGeolocation.count;
    if (count == 0) {
      // util.Dialog.alert(context, "Sync", "Database is empty");
      // return;
      if (check == "1") {
        _syncstart = syncInterval;
        countDownSaveForSync();
      } else {
        // snackbarmethod1("No movement");
      }
    } else {
      // // _getLastLatLong() async {
      // var lLat;
      // var lLong;

      // var allLists = await dbHelper.getEmployees();
      // // print("L-leng 11 >> " + allLists.toString());
      // // print("L-leng >> " + allLists.length.toString());
      // if (allLists.length != 0) {
      //   for (final list in allLists) {
      //     if (list.location.toString() == "null" || list.location == "") {
      //     } else {
      //       var index = list.location.toString().indexOf(',');
      //       lLat = list.location.toString().substring(0, index);
      //       lLong = list.location.toString().substring(index + 1);

      bg.BackgroundGeolocation.sync().then((List records) async {
        print('[sync] success >> ' + records.toString());
        // var samLoc = '';
        final prefs = await SharedPreferences.getInstance();
        var count = 0;
        var convGetToMin = 0;
        var di = prefs.getInt("datainterval") ?? 60;
        var datainterval = int.parse(di.toString()) / 60;
        for (var i = 0; i < records.length; i++) {
          print("List loop >> " + records[i]["coords"]["latitude"].toString());
          var lat = records[i]["coords"]["latitude"].toString();
          var long = records[i]["coords"]["longitude"].toString();
          var loc = lat + ", " + long;
          var timestamp = records[i]["timestamp"].toString();

          var index = timestamp.toString().indexOf('T');
          // // var yr = timestamp.toString().substring(0, 4);
          // // var mn = timestamp.toString().substring(5, 7);
          // // var dy = timestamp.toString().substring(8, 10);
          var hr = timestamp.toString().substring(index + 1, index + 3);
          var mi = timestamp.toString().substring(index + 4, index + 6);
          // print("AT >> " + yr.toString() + mn.toString() + dy.toString());
          TimeOfDay testDate =
              TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
          int testDateInMinutes = testDate.hour * 60 + testDate.minute;
          // print("TD >> " + testDateInMinutes.toString());
          int ct = testDateInMinutes + 390;
          var mct = durationToString(ct);
          // print("MyCurTime >> " + mct);
          // // // var hrr = mct.substring(0, 2);
          // // // var mii = mct.substring(3, 5);

          // var cvtDate = formatTimeOfDay(int.parse(yr), int.parse(mn),
          //     int.parse(dy), int.parse(hrr), int.parse(mii));
          DateTime now = DateTime.now();
          var yr = DateFormat.y().format(now);
          var mn = DateFormat.M().format(now);
          var dy = DateFormat.d().format(now);
          if (mn.toString().length == 1) {
            mn = "0" + mn.toString();
          }
          // var dy = DateFormat.d().format(now);
          if (dy.toString().length == 1) {
            dy = "0" + dy.toString();
          }

          var cvtDate = yr + "-" + mn + "-" + dy + "T" + mct;
          // print("AA >> " + cvtDate.toString());

          var chklat =
              records[i]["coords"]["latitude"].toString().substring(0, 7);
          var chklong =
              records[i]["coords"]["longitude"].toString().substring(0, 7);
          var chkLoc = chklat + ", " + chklong;
          print("chkLoc >> " + chkLoc);

          var lastLat = prefs.getString("last-lat") ?? "";
          var lastLong = prefs.getString("last-long") ?? "";

          // final prefs = await SharedPreferences.getInstance();
          // var gtime = prefs.getString("last-time") ?? "";
          // convGetToMin = 0;
          // if (gtime != "") {
          //   var ghr = gtime.toString().substring(0, 2);
          //   var gmi = gtime.toString().substring(3, 5);
          //   TimeOfDay getTime =
          //       TimeOfDay(hour: int.parse(ghr), minute: int.parse(gmi));
          //   convGetToMin = getTime.hour * 60 + getTime.minute;
          // }

          // TimeOfDay nowTime =
          //     TimeOfDay(hour: int.parse(hr), minute: int.parse(mi));
          // int convNowToMin = nowTime.hour * 60 + nowTime.minute;
          // snackbarmethod1("COMPARE TIME >> " +
          //     ct.toString() +
          //     "||" +
          //     convGetToMin.toString());
          // var ctime = convGetToMin + 3;
          // if (ct < ctime) {
          //   // if (ct == convGetToMin) {
          //   // snackbarmethod1("Close Interval!");
          //   if (i == 0) {
          //     convGetToMin = ct;
          //   }
          // } else {
          // if (ct < (convGetToMin + datainterval)) {
          // snackbarmethod1("Close Interval!");
          if (i == 0) {
            convGetToMin = ct;
            // }
          } else {
            // prefs.setString("last-time", gtime);
            if (ct == (convGetToMin + datainterval)) {
              convGetToMin = ct;
              // snackbarmethod1(
              //     "Compare time >> " + ct.toString() + "::" + ctime.toString());

              if (lastLat == '' ||
                  lastLat == null ||
                  lastLong == "" ||
                  lastLong == null) {
                Employee e =
                    Employee(null, loc, cvtDate, "Checked In", "0", "Auto");
                dbHelper.save(e);
                count += 1;
                prefs.setString("last-lat", lat);
                prefs.setString("last-long", long);
              } else {
                double di = calDisc(lastLat, lastLong, lat, long);
                if (di > locDistance) {
                  Employee e =
                      Employee(null, loc, cvtDate, "Checked In", "0", "Auto");
                  dbHelper.save(e);
                  count += 1;
                  prefs.setString("last-lat", lat);
                  prefs.setString("last-long", long);
                  // syncDataWithDis += "$count" + "{" + lat + ", " + long + "}";
                  lastLat = lat;
                  lastLong = long;
                }
              }
            }
          }
          // if (samLoc == chkLoc) {
          // } else {
          //   Employee e =
          //       Employee(null, loc, cvtDate, "Checked In", "0", "Auto");
          //   dbHelper.save(e);
          //   samLoc = chkLoc;
          //   count += 1;
          // }
        }
        if (count == 0) {
          // snackbarmethod1("No movement");
        } else {
          snackbarmethod1(count.toString() + " location(s)");
        }
        if (check == "1") {
          _syncstart = syncInterval;
          countDownSaveForSync();
        }
        // if (this.mounted) {
        setState(() {});
        // }

        // bg.BackgroundGeolocation.playSound(
        //     util.Dialog.getSoundId("MESSAGE_SENT"));
      }).catchError((dynamic error) async {
        // util.Dialog.alert(context, "Sync", error.toString());
        print('[sync] ERROR: $error');
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", "ERROR FROM TABS >> " + error);
      });
      //   }
      // }
      // print("Last lat/long >> " + lLat.toString() + lLong.toString());
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString("last-lat", lLat);
      // prefs.setString("last-long", lLong);
    }

    // }
  }

  _getCurrentLocation() async {
    // setState(() {});
    try {
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // final Geolocator geolocator = Geolocator()
      //   ..forceAndroidLocationManager = true;
      // var position = await geolocator.getLastKnownPosition(
      //     desiredAccuracy: LocationAccuracy.best);
      print("location >>> $location");
      location = "${position.latitude}, ${position.longitude}";
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("fist-loc", location);
      // latt = "${position.latitude}";
      // longg = "${position.longitude}";

      // setState(() {});
      // print(_locationMessage);
      // print(formattedDate);
    } on Exception catch (_) {
      print('never reached');
    }
  }

  _getDeviceId() async {
    deviceId = await DeviceId.getID;
    print(deviceId);
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  snackbarmethod2(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      backgroundColor: Colors.orange.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  // convertDateTime(){
  //   DateTime now = DateTime.now();
  //   var yr = DateFormat.y().format(now);
  //   var mn = DateFormat.M().format(now);
  //   if (mn.length == 1) {
  //     mn = "0" + mn;
  //   }
  //   var dy = DateFormat.d().format(now);
  //   if (dy.length == 1) {
  //     dy = "0" + dy;
  //   }
  //   var time = new DateFormat.jm().format(now);
  //   var dt = yr + "-" + mn + "-" + dy + " " + time;
  //   return dt;
  // }

  sendData() async {
    final prefs = await SharedPreferences.getInstance();
    var ph = prefs.getString('UserId');
    var setList = [];
    setList = await dbHelper.getEmployees();
    // setState(() {});
    var data = [];
    var comTime;
    for (var i = 0; i < setList.length; i++) {
      // print("AAA >> ${setList[i].location}");
      if (setList[i].location == null || setList[i].location == "") {
      } else {
        if (setList[i].color.toString() == "0") {
          if (i == 0) {
            comTime = setList[i].time.toString();
          } else {
            comTime = setList[i - 1].time.toString();
          }

          var ii1 = comTime.indexOf('T');
          var yr1 = comTime.substring(0, 4);
          var mn1 = comTime.substring(5, 7);
          var dy1 = comTime.substring(8, 10);
          var hr1 = comTime.substring(ii1 + 1, ii1 + 3);
          var mi1 = comTime.substring(ii1 + 4, ii1 + 6);
          final coTime = DateTime(int.parse(yr1), int.parse(mn1),
              int.parse(dy1), int.parse(hr1), int.parse(mi1));

          var ii = setList[i].time.toString().indexOf('T');
          var yr = setList[i].time.toString().substring(0, 4);
          var mn = setList[i].time.toString().substring(5, 7);
          var dy = setList[i].time.toString().substring(8, 10);
          var hr = setList[i].time.toString().substring(ii + 1, ii + 3);
          var mi = setList[i].time.toString().substring(ii + 4, ii + 6);
          final gcTime = DateTime(int.parse(yr), int.parse(mn), int.parse(dy),
              int.parse(hr), int.parse(mi));

          var duration = gcTime.difference(coTime).inMinutes.toString();

          var index = setList[i].location.toString().indexOf(',');
          // [{"mid":null,"did":"4e2f63299f46aa50","mhash":"","dhash":"","timestamp":"2020-04-13","duration":1.0,"lat":22.909595,"lng":96.4212117,"source":"TraceMyanmar","eventname":null,"location":"22.909595, 96.4212117","remark":"","contact":"","contacttype":"GPS"}]
          // print("DATE >> " + setList[i].time.toString());
          // var timestamp = setList[i].time.toString().substring(0, 10);
          // print("ts>> $gcTime , $coTime");
          print("timestamp>> $duration");
          data.add({
            "mid": ph,
            "did": deviceId,
            "mhash": deviceId,
            "dhash": "",
            "timestamp": setList[i].time.toString(),
            "duration": double.parse(duration),
            "lat": double.parse(
                setList[i].location.toString().substring(0, index)),
            "lng": double.parse(
                setList[i].location.toString().substring(index + 1)),
            "source": submitSource,
            "eventname": setList[i].rid,
            "location": setList[i].location,
            "remark": setList[i].remark.toString(),
            "contact": "",
            "contacttype": "GPS"
            // "time": setList[i].time
          });
        }
      }
    }
    //http://192.168.205.137:8081/IonicDemoService/module001/service005/saveUser
    // final url = "https://api.mcf.org.mm/api/people_history/insertmany";
    final url = url1 + "/api/people_history/insertmany";
    // final url = 'http://uattrackingapi.azurewebsites.net/api/people_history/insertmany';
    var body = jsonEncode(data);
    print("BDY >> " + body);
    if (body == "[]") {
    } else {
      snackbarmethod1("Loading...");
    }
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((res) {
      var result = json.decode(res.body);
      print("RES >> $result");
      if (result == 0) {
        for (var i = 0; i < setList.length; i++) {
          // print("AAA 111 >> ${setList[i].id}");
          if (setList[i].location == null ||
              setList[i].location == "" ||
              setList[i].color.toString() == "1") {
          } else {
            // print("BBB >>>>");
            Employee e = Employee(
                int.parse(setList[i].id.toString()),
                setList[i].location,
                setList[i].time,
                setList[i].rid,
                "1",
                setList[i].remark);
            dbHelper.update(e);
          }
        }
        this.snackbarmethod1("Submitted  Successfully.");
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TabsPage(
                  openTab: 2,
                ),
              ));
        });
      } else {
        this.snackbarmethod1("Can not submit");
      }
    }).catchError((Object error) {
      print("ON ERROR 111 >>" + error.toString());
      if (body == "[]") {
      } else {
        snackbarmethod1("Internet connection error");
      }

      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString("errorLog", "ERROR FROM TABS >> " + error);
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        sendData();
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: Colors.blue.shade300),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0),
      // ),
      backgroundColor: Colors.white,
      content: Text(
        // "ဆက်လက်ဆာင်ရွက်ပါ (Confirm)",
        lan == "Zg"
            ? Rabbit.uni2zg("ဆက်လက်ဆောင်ရွက်ပါ (Confirm)")
            : "ဆက်လက်ဆောင်ရွက်ပါ (Confirm)",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _openURL() async {
    final prefs = await SharedPreferences.getInstance();
    var bt = prefs.getInt("buildType") ?? 0;
    if (bt == 1) {
      if (Platform.isAndroid) {
        // Android-specific code
        print("Android");
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } else if (Platform.isIOS) {
        // iOS-specific code
        print("iOS");
        // _openApp();
      }
    }
  }

  Future<bool> popped() {
    // DateTime now = DateTime.now();
    // if (current == null || now.difference(current) > Duration(seconds: 2)) {
    // current = now;
    Fluttertoast.showToast(
      msg: "Press back Again To exit !",
      toastLength: Toast.LENGTH_SHORT,
    );
    return Future.value(false);
    // } else {
    //   Fluttertoast.cancel();
    //   return Future.value(true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    // onWillPop: () => popped(),
    // child:
    return new Scaffold(
      key: _scaffoldkey,
      // appBar: new AppBar(
      //   title: new Text("MIT"),
      //   bottom: new TabBar(
      //     tabs: <Tab>[
      //       new Tab(
      //         text: "Messages",
      //         icon: new Icon(Icons.message),
      //       ),
      //       new Tab(
      //         text: "Contacts",
      //         icon: new Icon(Icons.contacts),
      //       ),
      //     ],
      //     controller: _tabController,
      //   ),
      // ),
      appBar: AppBar(
        // key: _scaffoldKey,
        centerTitle: true,
        title: Text(
          // "Saw Saw Shar",
          "Saw Saw Shar",
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        bottom: new PreferredSize(
          preferredSize: new Size(60.0, 60.0),
          child: new Container(
            // width: 200.0,
            child: new TabBar(
              // indicator: CircleTabIndicator(color: Colors.red, radius: 3),
              indicatorColor: Colors.white,
              indicatorSize: TabBarTheme.of(context).indicatorSize,
              // indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              // unselectedLabelColor: Colors.white,
              tabs: [
                Container(
                  height: 60,
                  child: new Tab(
                    // icon: new Icon(Icons.home),
                    icon: showNoti == "0"
                        ? Icon(Icons.home)
                        : Container(
                            width: 30,
                            height: 30,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.home,
                                  // color: Colors.black,
                                  size: 30,
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffc32c37),
                                        border: Border.all(
                                            color: Colors.white, width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Center(
                                        child: Text(
                                          homeNoti,
                                          // _counter.toString(),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
//                     text: '''   မူလ
// (Home)''',
                    // text: '''မူလ (Home)''',
                  ),
                ),
                Container(
                  height: 60,
                  child: new Tab(
                    icon: new Icon(
                      th,
                      size: 19,
                    ),
                    //         text: '''သွားခဲ့သောနေရာများ
                    // (List)''',
                    // text: '''သွားခဲ့သောနေရာများ (List)''',
                  ),
                ),
                Container(
                  height: 60,
                  child: new Tab(
                    icon: new Icon(globe),
//                     text: '''   မူလ
// (Home)''',
                    // text: '''မူလ (Home)''',
                  ),
                ),
                Container(
                  height: 60,
                  child: new Tab(
                    icon: new Icon(
                      Icons.notifications,
                      // size: 19,
                    ),
                    //         text: '''သွားခဲ့သောနေရာများ
                    // (List)''',
                    // text: '''သွားခဲ့သောနေရာများ (List)''',
                  ),
                ),
                Container(
                  height: 60,
                  child: new Tab(
                    icon: new Icon(
                      Icons.phone,
                      // size: 19,
                    ),
                    //         text: '''သွားခဲ့သောနေရာများ
                    // (List)''',
                    // text: '''သွားခဲ့သောနေရာများ (List)''',
                  ),
                ),
                
              ],

              controller: _tabController,
            ),
          ),
        ),
        backgroundColor: Colors.lightBlue,
        // leading: new Container(
        //   child: IconButton(
        //       icon: new Icon(
        //         Icons.menu,
        //         color: Colors.white,
        //       ),
        //       onPressed: () => _scaffoldKey.currentState.openDrawer()),
        // ),
        leading: Builder(builder: (BuildContext context) {
          return new GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
              // timer.cancel();
            },
            child: new Container(
              child: IconButton(
                icon: new Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),

        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child:
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    Text("Version " + version,
                        // checklang == "Eng"
                        //     ? textEng[3] + " (Version)"
                        //     : textMyan[3] + " (Version)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        )),
                //     Text(" (Version)",
                //         style: TextStyle(
                //             fontWeight: FontWeight.w400,
                //             color: Colors.black)),
                //   ],
                // ),
              ),
              PopupMenuItem(
                value: 2,
                child:
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    Text(
                  // checklang == "Eng"
                  //     ? textEng[2] + " (Submit)"
                  //     : textMyan[2] + " (Submit)",
                  lan == "Zg"
                      ? Rabbit.uni2zg(textMyan[2] + " (Submit)")
                      : textMyan[2] + " (Submit)",
                  style: TextStyle(
                      fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                //   Text(
                //     " (Submit)",
                //     style: TextStyle(
                //         fontWeight: FontWeight.w400,
                //         color: Colors.black),
                //   ),
                // ],
                // )
              ),

              //
              PopupMenuItem(
                value: 3,
                child: Text(
                    // checklang == "Eng"
                    //     ? textEng[3] + " (Version)"
                    //     : textMyan[3] + " (Version)",
                    // "ဆက်သွယ်ရန် (Contact)",
                    lan == "Zg"
                        ? Rabbit.uni2zg("ဆက်သွယ်ရန် (Contact)")
                        : "ဆက်သွယ်ရန် (Contact)",
                    style: TextStyle(
                        fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ),
              PopupMenuItem(
                value: 4,
                child: Text(
                    // checklang == "Eng"
                    //     ? textEng[3] + " (Version)"
                    //     : textMyan[3] + " (Version)",
                    "Terms & Condition",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black)),
              ),
              PopupMenuItem(
                value: 5,
                child: Text(
                    // checklang == "Eng"
                    //     ? textEng[3] + " (Version)"
                    //     : textMyan[3] + " (Version)",
                    "About",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black)),
              ),
              // PopupMenuItem(
              //   value: 6,
              //   child: Text(
              //       // checklang == "Eng"
              //       //     ? textEng[3] + " (Version)"
              //       //     : textMyan[3] + " (Version)",
              //       "Check upadte",
              //       style: TextStyle(
              //           fontWeight: FontWeight.w400, color: Colors.black)),
              // ),
            ],
            // initialValue: 2,
            onCanceled: () {
              print("You have canceled the menu.");
            },
            onSelected: (value) {
              print("value:$value");
              if (value == 1) {
                setState(() {
                  _openURL();
                });
              }
              if (value == 2) {
                // isUpdating = false;
                setState(() {
                  showAlertDialog(context);
                });
              }
              if (value == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactUs(),
                    ));
              }
              if (value == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TCPage(
                      check: "1",
                    ),
                  ),
                );

                // snackbarmethod1(
                //     "ယခု app ကို ကျန်းမာရေးနှင့် အားကစားဝန်ကြီးဌာနမှ ထုတ်ဝေပါသည်");
              }
              if (value == 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => About(),
                  ),
                );
              }
              if (value == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersionUpdate(),
                  ),
                );
              }
            },
            // icon: Icon(Icons.list),
          ),
        ],
      ),
      drawer: Drawerr(),
      body: new TabBarView(
        // physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          BackgroundTracking(),
          //  WebviewInfo(),
          Sqlite(),
          News(),
          NotiList(),
          ContactUs(),
          
        ],
        controller: _tabController,
      ),
      // floatingActionButton: [...]
      // ),
    );
  }
}

// class CircleTabIndicator extends Decoration {
//   final BoxPainter _painter;

//   CircleTabIndicator({@required Color color, @required double radius})
//       : _painter = _CirclePainter(color, radius);

//   @override
//   BoxPainter createBoxPainter([onChanged]) => _painter;
// }

// class _CirclePainter extends BoxPainter {
//   final Paint _paint;
//   final double radius;

//   _CirclePainter(Color color, this.radius)
//       : _paint = Paint()
//           ..color = color
//           ..isAntiAlias = true;

//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
//     final Offset circleOffset =
//         offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
//     canvas.drawCircle(circleOffset, radius, _paint);
//   }
// }
