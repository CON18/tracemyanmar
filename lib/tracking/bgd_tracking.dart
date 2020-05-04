import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:TraceMyanmar/FB/Test/1/111.dart';
import 'package:TraceMyanmar/FB/Test/1/2/2222.dart';
import 'package:TraceMyanmar/FB/Test/1/2/3/3333.dart';
import 'package:TraceMyanmar/FB/Test/1/2/3/4/4444.dart';
import 'package:TraceMyanmar/FB/Test/1/2/3/4/5/5555.dart';
import 'package:TraceMyanmar/contact/contact_list.dart';
import 'package:TraceMyanmar/conv_datetime.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:crypto/crypto.dart';
import 'package:device_id/device_id.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:TraceMyanmar/version_history.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

JsonEncoder encoder = new JsonEncoder.withIndent("     ");

class BackgroundTracking extends StatefulWidget {
  @override
  _BackgroundTrackingState createState() => _BackgroundTrackingState();
}

class _BackgroundTrackingState extends State<BackgroundTracking> {
  String checklang;
  var dbHelper;
  String deviceId;
  String location = "";
  String latt = "";
  String longg = "";
  List textMyan = ["GPS Check In", "QR Check In"];
  List textEng = ["GPS Check In", "QR Check In"];
  String righttime;
  final formKey = new GlobalKey<FormState>();
  int curUserId;
  String rid;

  var isLoading = true;

  bool checkAlt = false;

  int contactCount = 0;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();

  double calDisc(lat1, lon1, lat2, lon2) {
    final Distance distance = new Distance();
    var meter = distance(new LatLng(double.parse(lat1), double.parse(lon1)),
        new LatLng(double.parse(lat2), double.parse(lon2)));
    return meter;
  }

  bool trackingCheck = false;
  // Timer timer;
  // Timer timer1;

  // bool _trackStatus;
  // bool _isMoving;
  // String _content;

  int saveCount = 0;

  List trackingArray = [];
  List testArray = [];
  var _start;
  var _syncstart;

  var todayDate;

  Timer timer;
  Timer syncTimer;
  DateTime current;

  bool checkNewVersion = false;
  String versionNo = '';

  var lan;
  var altTime = "";
  var altDate = "";

  @override
  void initState() {
    super.initState();
    // chkTracking();
    analyst();

    _syncList("0");

    _checkNewVersion();
    someMethod();
    _getAlert();
    // _getSession();
    // bg.BackgroundGeolocation.onLocation(_onLocation);
    // // bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    // // bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    // bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    // // bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

    // // 2.  Configure the plugin
    // // bg.BackgroundGeolocation.ready(bg.Config(

    // //         // desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    // //         // distanceFilter: 10.0,
    // //         // // stopOnTerminate: false,
    // //         // // startOnBoot: true,
    // //         // // debug: true,
    // //         // autoSync: true,
    // //         // logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    // //         // // reset: true,
    // //         // // enableTimestampMeta: true,
    // //         // notificationTitle: "TraceMM",
    // //         // notificationText: "location"
    // //         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    // //         distanceFilter: 10.0,
    // //         stopOnTerminate: false,
    // //         startOnBoot: true,
    // //         debug: true,
    // //         logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    // //         notificationTitle: "Saw Saw Shar",
    // //         notificationText: "Movement",
    // //         reset: true))
    // //     .then((bg.State state) {
    // // setState(() {
    // // bg.BackgroundGeolocation.start();
    // bg.BackgroundGeolocation.start().then((bg.State state) {
    //   // print('[start] success >> ' + state.enabled.toString());
    //   // // //   // final prefs = await SharedPreferences.getInstance();
    //   // // //   // var cp = prefs.getString("changePace") ?? "false";
    //   // // //   // if (cp == "false") {
    //   bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
    //     print('[changePace] success $isMoving');
    //     // prefs.setString("changePace", "true");
    //     // _syncList();
    //   }).catchError((e) {
    //     print('[changePace] ERROR: ' + e.code.toString());
    //   });
    //   // // //   // } else {
    //   // // //   //   _syncList();
    //   // // //   // }
    // }).catchError((e) {
    //   print('[start] ERROR: ' + e.code.toString());
    //   bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
    //     print('[changePace] success $isMoving');
    //   }).catchError((e) {
    //     print('[changePace] ERROR1: ' + e.code.toString());
    //   });
    // });

    // trackingCheck = state.enabled;
    // _isMoving = state.isMoving;
    // });
    // });

    // saveRef();
    checkLanguage();
    dbHelper = DBHelper();
    // isUpdating = false;
    // refreshList();
    _getDeviceId();
    gettime();
    _getLastLatLong();
    _getCurrentLocation();
    // _checkTimer();
    // _checkAutoSync();
  }

  @override
  void dispose() {
    // setState(() {
    // timer.cancel();
    // syncTimer.cancel();
    // });

    // timer1.cancel();
    super.dispose();
  }

  // _getSession() async {
  //   print("GS >>");

  //   deviceId = await DeviceId.getID;
  //   final prefs = await SharedPreferences.getInstance();
  //   var fcmToken = prefs.getString("fcmToken") ?? "";
  //   var userPhone = prefs.getString("UserId") ?? "";

  //   // var sk = prefs.getString("getsessionkey") ?? "";
  //   // var si = prefs.getString("getsessionid") ?? "";

  //   var chkAlt = prefs.getString("altPermission") ?? "0";
  //   if (chkAlt == "1") {
  //     // if (sk == "" || si == "") {
  //     // snackbarmethod1("GET SESSION >>" + deviceId.toString());
  //     setState(() {
  //       String url =
  //           // "https://service.mcf.org.mm/module001/serviceRegisterTraceMyanmar/getsession";
  //           // "http://sawsawsharservice.azurewebsites.net/module001/serviceRegisterTraceMyanmar/getsession";
  //           // "https://sssuat.azurewebsites.net/module001/serviceRegisterTraceMyanmar/getsession";
  //           // "http://uatsssverify.azurewebsites.net/module001/serviceRegisterTraceMyanmar/getsession";
  //           url2 + "/module001/serviceRegisterTraceMyanmar/getsession";
  //       // "http://52.187.13.89:8080/tracemyanmar/module001/service004/saveUser";
  //       var body;
  //       // if (curUserId == null) {
  //       //   body = jsonEncode(
  //       //       {"uuid": deviceId, "fcmtoken": fcmToken, "phoneno": ""});
  //       // } else {
  //       body = jsonEncode(
  //           {"uuid": deviceId, "fcmtoken": fcmToken, "phoneno": userPhone});
  //       // }
  //       // snackbarmethod1("BODY >> " + body.toString());
  //       // print("SE BODY >> " + body.toString());
  //       http.post(url, body: body, headers: {
  //         "Accept": "application/json",
  //         "content-type": "application/json"
  //       }).then((dynamic res) async {
  //         print("Response >> " + res.toString());
  //         var result = json.decode(utf8.decode(res.bodyBytes));
  //         var resStatus = result['desc'];
  //         var sKey = result['key'];
  //         var sId = result['sessionid'];
  //         print("CODE >> " + resStatus.toString());
  //         if (resStatus == 'Success') {
  //           final prefs = await SharedPreferences.getInstance();
  //           prefs.setString("getsessionkey", sKey);
  //           prefs.setString("getsessionid", sId);
  //         }
  //       });
  //     });
  //   } else {
  //     // print("NONEED>>");
  //   }
  // }

  analyst() async {
    await analytics.logEvent(
      name: 'Home_Request',
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
            print("Update is available >>");
            checkNewVersion = true;
            versionNo = resStatus;
          } else {
            print("No Update >>");
            checkNewVersion = false;
          }

          // if (resStatus == version) {
          //   checkNewVersion = false;
          // } else {
          //   checkNewVersion = true;
          //   versionNo = resStatus;
          // }
        });
      }).catchError((Object error) async {
        checkNewVersion = true;
        versionNo = "x.x.xx";
      });
    }
  }

  // void _onLocation(bg.Location location) async {
  //   // locCount = locCount + 1;
  //   print('[location] >>>> ' + location.toString());
  // }

  // void _onProviderChange(bg.ProviderChangeEvent event) {
  //   // print('PRO CHG EVE >>> $event');
  //   setState(() {
  //     // _content = encoder.convert(event.toMap());
  //     // trackingArray.add(_content);
  //   });
  // }

  _getAlert() async {
    // var key = utf8.encode('sss@2020');
    // var bytes = utf8.encode("foobar");

    // var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    // var digest = hmacSha256.convert(bytes);

    // print("HMAC digest as bytes: ${digest.bytes}");
    // print("HMAC digest as hex string: $digest");

    final prefs = await SharedPreferences.getInstance();
    var chkAlt = prefs.getString("altPermission") ?? "0";
    if (chkAlt == "1") {
      setState(() {
        checkAlt = true;
      });

      // final url = 'https://api.mcf.org.mm/api/values';
      final url = url1 + "/api/values";
      // final url = "http://uattrackingapi.azurewebsites.net/api/values";

      var body =
          jsonEncode({"a": aaa + ccc, "s": bbb + ddd + eee, "d": deviceId});

      http.post(Uri.encodeFull(url), body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((res) {
        var result = json.decode(res.body);
        print("RES >> $result");
        if (result == 0) {
          print("0000 >>>");
          setState(() {
            contactCount = result;
            checkAlt = false;

            final now = new DateTime.now();
            // altTime = DateFormat.yMd().add_jm().format(now); //"6:00 AM"
            altTime = DateFormat.jm().format(now); //"6:00 AM"
            altDate = DateFormat.yMd().format(now);
            prefs.setString("altPermission", "0");
            prefs.setString("altTime", altTime.toString());
            prefs.setString("altDate", altDate.toString());
          });
        } else {
          print("Other >>");
          setState(() {
            final now = new DateTime.now();
            var dd = DateFormat.yMd().format(now);
            contactCount = result;
            checkAlt = false;
            altTime = prefs.getString("altTime") ?? "12:00 AM";
            altDate = prefs.getString("altDate") ?? dd;
          });
        }
      }).catchError((Object error) async {
        print("ON ERROR >>");
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", "ERROR ON BD TRACKING " + error);
        setState(() {
          checkAlt = false;
          final now = new DateTime.now();
          var dd = DateFormat.yMd().format(now);
          checkAlt = false;
          altTime = prefs.getString("altTime") ?? "12:00 AM";
          altDate = prefs.getString("altDate") ?? dd;
        });
      });
    } else {
      setState(() {
        checkAlt = false;
        final now = new DateTime.now();
        var dd = DateFormat.yMd().format(now);
        checkAlt = false;
        altTime = prefs.getString("altTime") ?? "12:00 AM";
        altDate = prefs.getString("altDate") ?? dd;
      });
    }
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
    // return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}:00';
  }

  // String formatTimeOfDay(year, month, day, hr, mi) {
  //   //  final now = new DateTime.now();
  //   final dt = DateTime(year, month, day, hr, mi);
  //   final format = DateFormat.yMd().add_jm(); //"6:00 AM"
  //   return format.format(dt);
  // }
  // formatTimeOfDay(year, month, day, hr, mi) {
  //   // DateTime now = DateTime.now();
  //   // var yr = DateFormat.y().format(now);
  //   // var mn = DateFormat.M().format(now);
  //   // print("FORMAT111 >> ");
  //   final dt = DateTime(year, month, day, hr, mi);

  //   if (month.toString().length == 1) {
  //     month = "0" + month.toString();
  //   }
  //   // var dy = DateFormat.d().format(now);
  //   if (day.toString().length == 1) {
  //     day = "0" + day.toString();
  //   }

  //   final format = DateFormat.yMd().add_jm().format(dt);
  //   var time = format.toString().substring(10, format.length);

  //   var rt = year.toString() +
  //       "-" +
  //       month.toString() +
  //       "-" +
  //       day.toString() +
  //       " " +
  //       time.toString();
  //   return rt;
  // }

  _syncList(String check) async {
    final prefs = await SharedPreferences.getInstance();
    var locDistance = prefs.getInt("meter") ?? 0;
    int count = await bg.BackgroundGeolocation.count;
    if (count == 0) {
      // util.Dialog.alert(context, "Sync", "Database is empty");
      // return;
      if (check == "1") {
        // _syncstart = syncInterval;
        // countDownSaveForSync();
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
          //       Employee(curUserId, loc, cvtDate, "Checked In", "0", "Auto");
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
          // _syncstart = syncInterval;
          // countDownSaveForSync();
        }
        setState(() {});
        // bg.BackgroundGeolocation.playSound(
        //     util.Dialog.getSoundId("MESSAGE_SENT"));
      }).catchError((dynamic error) async {
        // util.Dialog.alert(context, "Sync", error.toString());
        print('[sync] ERROR: $error');
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", "ERROR FROM BG TRACKING >> " + error);
      });
    }
    //     }
    //   }
    // }
  }

  // _checkAndstartTrack() async {
  //   final result = await Geolocator().isLocationServiceEnabled();
  //   if (result == false) {
  //     snackbarmethod1("Please turn on GPS.");
  //   } else {
  //     GeolocationStatus result1 =
  //         await Geolocator().checkGeolocationPermissionStatus();

  //     print("RESULT >>> " + result1.toString());
  //     if (result1.toString() == "GeolocationStatus.denied") {
  //       //ask permission
  //       final position = await Geolocator()
  //           .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //       location = "${position.latitude}, ${position.longitude}";
  //       latt = "${position.latitude}";
  //       longg = "${position.longitude}";
  //     } else {
  //       final prefs = await SharedPreferences.getInstance();
  //       var chkT = prefs.getString("chk_tracking") ?? "0";
  //       if (chkT == "0") {
  //         //tracking off
  //       } else {
  //         //tracking on
  //         final prefs = await SharedPreferences.getInstance();
  //         int val = prefs.getInt("timer") ?? 0;

  //         if (val == 0) {
  //         } else {
  //           _start = val.toString();
  //           countDownSave();
  //         }
  //       }
  //     }
  //   }
  // }

  // //-->>For sync timer
  // _checkAutoSync() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   int val = prefs.getInt("autoSyncTimer") ?? 0;

  //   if (val == 0) {
  //     // _syncstart = syncInterval;
  //     // countDownSaveForSync();
  //   } else {
  //     _syncstart = val.toString();
  //     countDownSaveForSync();
  //   }
  // }

  // countDownSaveForSync() {
  //   print("START >> $_syncstart");
  //   const oneSec = const Duration(seconds: 1);
  //   syncTimer = Timer.periodic(
  //     oneSec,
  //     (Timer t) => setState(
  //       () {
  //         if (_syncstart == 0) {
  //           // _getCurrentLocationForTrack();
  //           // sendData();
  //           // _syncList("1")
  //           syncTimer.cancel();
  //         } else {
  //           _syncstart = int.parse(_syncstart.toString()) - 1;
  //           savesyncTimer();
  //           // print("Sec>>" + _start.toString());
  //         }
  //         print("CD11 >> " + _syncstart.toString());
  //       },
  //     ),
  //   );
  // }

  // savesyncTimer() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("autoSyncTimer", _syncstart);
  // }

  // //-->>End for sync timer
  // //-->>For submitting timer
  // _checkTimer() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   int val = prefs.getInt("timer") ?? 0;

  //   if (val == 0) {
  //     _start = startInterval;
  //     countDownSave();
  //   } else {
  //     _start = val.toString();
  //     countDownSave();
  //   }
  // }

  // countDownSave() {
  //   print("START >> $_start");
  //   const oneSec = const Duration(seconds: 1);
  //   timer = Timer.periodic(
  //     oneSec,
  //     (Timer t) => setState(
  //       () {
  //         if (_start == 0) {
  //           // _getCurrentLocationForTrack();
  //           sendData();
  //           timer.cancel();
  //         } else {
  //           _start = int.parse(_start.toString()) - 1;
  //           saveTimer();
  //           // print("Sec>>" + _start.toString());
  //         }

  //         if (_start == 10) {
  //           _syncList("1");
  //         }
  //         print("CD >> " + _start.toString());
  //       },
  //     ),
  //   );
  // }

  // saveTimer() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("timer", _start);
  // }

  // sendData() async {
  //   // print("DATE >> $dt");
  //   // snackbarmethod1("Loading...");
  //   final prefs = await SharedPreferences.getInstance();
  //   var ph = prefs.getString('UserId');
  //   var setList = [];
  //   setList = await dbHelper.getEmployees();
  //   // setState(() {});
  //   var data = [];
  //   var comTime;
  //   for (var i = 0; i < setList.length; i++) {
  //     // print("AAA >> ${setList[i].location}");
  //     if (setList[i].location == null || setList[i].location == "") {
  //     } else {
  //       if (setList[i].color.toString() == "0") {
  //         if (i == 0) {
  //           comTime = setList[i].time.toString();
  //         } else {
  //           comTime = setList[i - 1].time.toString();
  //         }

  //         var ii1 = comTime.indexOf('T');
  //         var yr1 = comTime.substring(0, 4);
  //         var mn1 = comTime.substring(5, 7);
  //         var dy1 = comTime.substring(8, 10);
  //         var hr1 = comTime.substring(ii1 + 1, ii1 + 3);
  //         var mi1 = comTime.substring(ii1 + 4, ii1 + 6);
  //         final coTime = DateTime(int.parse(yr1), int.parse(mn1),
  //             int.parse(dy1), int.parse(hr1), int.parse(mi1));

  //         var ii = setList[i].time.toString().indexOf('T');
  //         var yr = setList[i].time.toString().substring(0, 4);
  //         var mn = setList[i].time.toString().substring(5, 7);
  //         var dy = setList[i].time.toString().substring(8, 10);
  //         var hr = setList[i].time.toString().substring(ii + 1, ii + 3);
  //         var mi = setList[i].time.toString().substring(ii + 4, ii + 6);
  //         final gcTime = DateTime(int.parse(yr), int.parse(mn), int.parse(dy),
  //             int.parse(hr), int.parse(mi));

  //         var duration = gcTime.difference(coTime).inMinutes.toString();

  //         var index = setList[i].location.toString().indexOf(',');
  //         // [{"mid":null,"did":"4e2f63299f46aa50","mhash":"","dhash":"","timestamp":"2020-04-13","duration":1.0,"lat":22.909595,"lng":96.4212117,"source":"TraceMyanmar","eventname":null,"location":"22.909595, 96.4212117","remark":"","contact":"","contacttype":"GPS"}]
  //         // print("DATE >> " + setList[i].time.toString());
  //         // var timestamp = setList[i].time.toString().substring(0, 10);
  //         // print("timestamp>> $timestamp");
  //         data.add({
  //           "mid": ph,
  //           "did": deviceId,
  //           "mhash": deviceId,
  //           "dhash": "",
  //           "timestamp": setList[i].time.toString(),
  //           "duration": double.parse(duration),
  //           "lat": double.parse(
  //               setList[i].location.toString().substring(0, index)),
  //           "lng": double.parse(
  //               setList[i].location.toString().substring(index + 1)),
  //           "source": submitSource,
  //           "eventname": setList[i].rid,
  //           "location": setList[i].location,
  //           "remark": setList[i].remark.toString(),
  //           "contact": "",
  //           "contacttype": "GPS"
  //           // "time": setList[i].time
  //         });
  //       }
  //     }
  //   }
  //   //http://192.168.205.137:8081/IonicDemoService/module001/service005/saveUser

  //   // final url =
  //   //     'http://uattrackingapi.azurewebsites.net/api/people_history/insertmany';
  //   final url = url1 + "/api/people_history/insertmany";
  //   var body = jsonEncode(data);
  //   print("BDY >> " + body);
  //   if (body == "[]") {
  //     _start = startInterval;
  //     countDownSave();
  //   } else {
  //     http.post(Uri.encodeFull(url), body: body, headers: {
  //       "Accept": "application/json",
  //       "content-type": "application/json"
  //     }).then((res) {
  //       var result = json.decode(res.body);
  //       print("RES >> $result");
  //       if (result == 0) {
  //         for (var i = 0; i < setList.length; i++) {
  //           // print("AAA 111 >> ${setList[i].id}");
  //           if (setList[i].location == null ||
  //               setList[i].location == "" ||
  //               setList[i].color.toString() == "1") {
  //           } else {
  //             // print("BBB >>>>");
  //             Employee e = Employee(
  //                 int.parse(setList[i].id.toString()),
  //                 setList[i].location,
  //                 setList[i].time,
  //                 setList[i].rid,
  //                 "1",
  //                 setList[i].remark);
  //             dbHelper.update(e);
  //           }
  //         }
  //         // this.snackbarmethod1("Submitted  Successfully.");
  //         setState(() {
  //           _start = startInterval;
  //           countDownSave();
  //         });

  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => TabsPage(
  //                 openTab: 2,
  //               ),
  //             ));
  //       } else {
  //         this.snackbarmethod1("Can not submit");
  //       }
  //     }).catchError((Object error) async {
  //       print("ON ERROR >>");
  //       _start = startInterval;
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("errorLog", "ERROR FROM BG TRACKING >> " + error);
  //       countDownSave();
  //     });
  //   }
  // }
  // //-->>End for submitting timer

  // _getCurrentLocationForTrack() async {
  //   //auto check in location

  //   // setState(() async {
  //   //tracking on
  //   try {
  //     final position = await Geolocator()
  //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //     var location = "${position.latitude}, ${position.longitude}";
  //     print("location >>> $location");

  //     // DateTime now = DateTime.now();
  //     // var curDT = new DateFormat.yMd().add_jm().format(now);
  //     var curDT = convertDateTime();

  //     Employee e =
  //         Employee(curUserId, location, curDT, "Checked In", "", "Auto");
  //     dbHelper.save(e);

  //     final prefs = await SharedPreferences.getInstance();
  //     int c = prefs.getInt("saveCount") ?? 0;
  //     final prefs1 = await SharedPreferences.getInstance();
  //     int r = c + 1;
  //     prefs1.setInt("saveCount", r);
  //     setState(() {
  //       saveCount = r;
  //     });
  //     print("Save --->>>>");
  //     _start = startInterval;
  //     countDownSave();
  //   } on Exception catch (_) {
  //     print('never reached');
  //   }
  //   // });
  // }

  // chkTracking() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var chkT = prefs.getString("chk_tracking") ?? "0";

  //   if (chkT == "0") {
  //     setState(() {
  //       trackingCheck = true;
  //       // saveCount = prefs.getInt("saveCount") ?? 0;
  //       // final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("chk_tracking", "true");
  //       prefs.setInt("timer", startInterval);
  //       _start = startInterval;
  //       // countDownSave();
  //       _checkAndstartTrack();
  //     });
  //     // _isMoving = false;
  //     // _content = '';
  //   } else if (chkT == "true") {
  //     trackingCheck = true;
  //     final prefs = await SharedPreferences.getInstance();
  //     int val = prefs.getInt("timer") ?? 0;

  //     if (val == 0) {
  //       _start = startInterval;
  //       countDownSave();
  //     } else {
  //       _start = val.toString();
  //       countDownSave();
  //     }
  //   } else {
  //     setState(() {
  //       trackingCheck = false;
  //     });
  //   }
  // }

  // int locCount = 0;
  // void _onLocation(bg.Location location) {
  //   locCount = locCount + 1;
  //   print('[location] >>>> $locCount - $location');
  //   // String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
  //   setState(() {
  //     _content = encoder.convert(location.toMap());

  //     trackingArray.add(_content);
  //     // _odometer = odometerKM;
  //   });
  // }

  // void _onProviderChange(bg.ProviderChangeEvent event) {
  //   // print('PRO CHG EVE >>> $event');
  //   setState(() {
  //     _content = encoder.convert(event.toMap());
  //     // trackingArray.add(_content);
  //   });
  // }

  _getLastLatLong() async {
    var lLat;
    var lLong;

    var allLists = await dbHelper.getEmployees();
    // print("L-leng 11 >> " + allLists.toString());
    // print("L-leng >> " + allLists.length.toString());
    if (allLists.length != 0) {
      for (final list in allLists) {
        if (list.location.toString() == "null" || list.location == "") {
        } else {
          var index = list.location.toString().indexOf(',');
          lLat = list.location.toString().substring(0, index);
          lLong = list.location.toString().substring(index + 1);
        }
      }
      print("Last lat/long >> " + lLat.toString() + lLong.toString());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("last-lat", lLat);
      prefs.setString("last-long", lLong);
    }
  }

  _getCurrentLocation() async {
    // initState() {}
    //Get last check in location

    // setState(() {});

    bg.BackgroundGeolocation.getCurrentPosition(
            // persist: false, // <-- do not persist this location
            // desiredAccuracy: 0, // <-- desire best possible accuracy
            // timeout: 30000, // <-- wait 30s before giving up.
            // samples: 3 // <-- sample 3 location before selecting best.
            )
        .then((bg.Location locc) {
      // print('[getCurrentPosition] - $location');
      print("CUR LOC >> " + locc.coords.latitude.toString());
      setState(() {
        // curseclat = location.coords.latitude.toString();
        // curseclong = location.coords.longitude.toString();
        location =
            "${locc.coords.latitude.toString()}, ${locc.coords.longitude.toString()}";

        print("location >>> $location");
        latt = "${locc.coords.latitude}";
        longg = "${locc.coords.longitude}";
      });
    });
    // try {
    //   final position = await Geolocator()
    //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //   // final Geolocator geolocator = Geolocator()
    //   //   ..forceAndroidLocationManager = true;
    //   // var position = await geolocator.getLastKnownPosition(
    //   //     desiredAccuracy: LocationAccuracy.best);
    //   // print("location >>> $location");
    //   location = "${position.latitude}, ${position.longitude}";
    //   print("location >>> $location");
    //   latt = "${position.latitude}";
    //   longg = "${position.longitude}";

    //   // DateTime now = DateTime.now();
    //   // var curDT = new DateFormat.yMd().add_jm().format(now);
    //   // var param = [
    //   //   {
    //   //     "datetime": curDT,
    //   //     "lat": curLat,
    //   //     "long": curLong,
    //   //     "location": location
    //   //   }
    //   // ];
    //   // testArray.add(param);

    //   setState(() {});
    // } on Exception catch (_) {
    //   print('never reached');
    //   location = "";
    // }
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  _getDeviceId() async {
    deviceId = await DeviceId.getID;
    print(deviceId);
  }

  gettime() async {
    var now = new DateTime.now();
    print(now);
    DateTime now1 = DateTime.now();
    todayDate = new DateFormat.yMd().format(now1);
    print("TODAY >> " + todayDate.toString());
    setState(() {});
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

  validate() async {
    // print("CurUserId >>" + remark.toString());
    final prefs = await SharedPreferences.getInstance();
    var locDistance = prefs.getInt("meter") ?? 0;
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
        location = "${position.latitude}, ${position.longitude}";
        latt = "${position.latitude}";
        longg = "${position.longitude}";
      } else {
        if (location == null) {
          // this.snackbarmethod1("Location not accessible.");
          // _alertCheckIn();
          setState(() {
            // DateTime now = DateTime.now();
            // righttime = new DateFormat.yMd().add_jm().format(now);
            righttime = convertDateTime();

            //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
          });
          formKey.currentState.save();

          // } else {
          print("2222");

          Employee e = Employee(curUserId, null, righttime, "", "0", "");
          dbHelper.save(e);

          _getLastLatLong();
          setState(() {});
          // }
          // clearName();
          // refreshList();
          setState(() {
            rid = "Checked In";
          });

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabsPage(
                  openTab: 2,
                ),
              ));
        } else if (formKey.currentState.validate()) {
          // if (location == "") {
          //   final position = await Geolocator()
          //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          //   // final Geolocator geolocator = Geolocator()
          //   //   ..forceAndroidLocationManager = true;
          //   // var position = await geolocator.getLastKnownPosition(
          //   //     desiredAccuracy: LocationAccuracy.best);
          //   print("location >>> $location");
          //   location = "${position.latitude}, ${position.longitude}";
          //   latt = "${position.latitude}";
          //   longg = "${position.longitude}";
          // }

          setState(() {
            // DateTime now = DateTime.now();
            // righttime = new DateFormat.yMd().add_jm().format(now);
            righttime = convertDateTime();

            //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
          });
          formKey.currentState.save();
          // if (isUpdating) {
          //   print("11111111");
          //   // if (location == null) {
          //   // Employee e =
          //   //     Employee(curUserId, "L, L", righttime, rid, color, remark);
          //   // dbHelper.update(e);

          //   // } else {
          //   Employee e =
          //       Employee(curUserId, location, righttime, rid, color, remark);
          //   dbHelper.update(e);
          //   // }

          //   setState(() {
          //     isUpdating = false;
          //   });
          // } else {
          // print("2222");
          // if (location == null) {
          //   Employee e = Employee(curUserId, "L, L", righttime, rid, color, "");
          //   dbHelper.save(e);
          // } else {
          final prefs = await SharedPreferences.getInstance();
          var lastLat = prefs.getString("last-lat") ?? "";
          var lastLong = prefs.getString("last-long") ?? "";

          if (lastLat == '' ||
              lastLat == null ||
              lastLong == "" ||
              lastLong == null) {
            print("LLL>>");
            // snackbarmethod1("You check in here last time.");
            Employee e = Employee(curUserId, location, righttime, rid, "0", "");
            dbHelper.save(e);
          } else {
            print("LLL1111>>");
            double di = calDisc(lastLat, lastLong, latt, longg);
            if (di > locDistance) {
              Employee e =
                  Employee(curUserId, location, righttime, rid, "0", "");
              dbHelper.save(e);

              prefs.setString("last-lat", latt);
              prefs.setString("last-long", longg);
              // syncDataWithDis += "$count" + "{" + lat + ", " + long + "}";
              // lastLat = lat;
              // lastLong = long;
            }
          }
          // }

          // color = "1";
          // this.alertmsg = "Check In Successfully!";
          // this.snackbarmethod();
          // _getLastLatLong();
          // setState(() {});
          // }
          // clearName();
          // refreshList();
          setState(() {
            rid = "Checked In";
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabsPage(
                  openTab: 2,
                ),
              ));
        }
      }
    }
  }

  // Future scanBarcodeNormal() async {
  //   String barcodeScanRes = "";
  //   try {
  //     barcodeScanRes = await scanner.scan();
  //     if (barcodeScanRes != null) {
  //       if (barcodeScanRes.substring(0, 1) == "{") {
  //         print(barcodeScanRes);
  //         // var route = new MaterialPageRoute(
  //         //     builder: (BuildContext context) =>
  //         //         new Sqlite());
  //         // Navigator.of(context).push(route);
  //         var scanresult = jsonDecode(barcodeScanRes);
  //         rid = scanresult["rid"];

  //         // remark = scanresult["remark"];
  //         // print("RMK >> " + remark.toString());
  //         validate();
  //         setState(() {});
  //       } else {
  //         print("haha");
  //       }
  //     } else {
  //       scanBarcodeNormal();
  //     }
  //     setState(() {
  //       // _scanBarcode = barcodeScanRes;
  //       // print(_scanBarcode);
  //       // alertmsg = _scanBarcode;
  //       snackbarmethod1(barcodeScanRes);

  //       // this._method1();
  //     });
  //     // } on PlatformException catch(ex){
  //     //   if(ex.code == BarcodeScanner.CameraAccessDenied){
  //     //     setState(() {
  //     //       alertmsg = "The permission was denied.";
  //     //     });
  //     //   }else{
  //     //     setState(() {
  //     //       alertmsg = "unknown error ocurred $ex";
  //     //     });
  //     //   }
  //   } on FormatException {
  //     setState(() {
  //       // alertmsg = "Scan canceled, try again !";
  //       // print(alertmsg);
  //       snackbarmethod1("Scan canceled, try again !");
  //     });
  //   } catch (e) {
  //     // alertmsg = "Unknown error $e";
  //     // snackbarmethod1("Unknown error $e");
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString("errorLog", "ERROR FROM BG TRACKING >> " + e);
  //   }
  //   print(barcodeScanRes);
  //   // this._method1();
  // }

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

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 13.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            // _getCurrentLocation();
                            // trackingCheck ? Container() : validate();
                            validate();
                            setState(() {});
                          },
                          child: Text(
                            // isUpdating
                            //     ? 'UPDATE'
                            //     : checklang == "Eng" ? textEng[0] :
                            // textMyan[0],
                            lan == "Zg"
                                ? Rabbit.uni2zg(textMyan[0])
                                : textMyan[0],
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   width: 20.0,
                // ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.47,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 13.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue,
                      // trackingCheck ? Colors.grey : Colors.blue,
                      onPressed: () {
                        setState(() {
                          // trackingCheck ? Container() :
                          // scanBarcodeNormal();
                        });
                      },
                      child: Text(
                        // checklang == "Eng" ? textEng[1] : textMyan[1],
                        lan == "Zg" ? Rabbit.uni2zg(textMyan[1]) : textMyan[1],
                        style: TextStyle(
                            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       scanBarcodeNormal();
                //     });
                //   },
                //   child: Image.asset(
                //     "assets/scan.png",
                //     width: 40.0,
                //     height: 40.0,
                //     color: Colors.blue,
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  _openNewVersionURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        key: _scaffoldkey,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                // Container(
                //   width: 200,
                //   height: 200,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     // border: Border.all(
                //     //   color: Colors.white,
                //     //   width: 0,
                //     // ),
                //     boxShadow: [
                //       BoxShadow(
                //           color: Colors.grey.withOpacity(0.5),
                //           offset: Offset(0, 5),
                //           blurRadius: 25)
                //     ],
                //     color: Colors.white,
                //   ),
                //   padding: EdgeInsets.all(20.0),
                //   child: CircleAvatar(
                //       backgroundColor: Colors.transparent,
                //       backgroundImage: AssetImage("assets/play-button.png")),
                // ),
                checkNewVersion
                    ? SizedBox(
                        height: 20.0,
                      )
                    : Container(),
                checkNewVersion
                    ? Card(
                        color: Colors.lightBlue,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.10,
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.arrow_downward,
                                          // color: Colors.white
                                          color: Colors.red[800],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "New Version Update",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  // color: Colors.red[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                            SizedBox(height: 10.0),
                                            Text(
                                              "Version $versionNo is now available.",
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  // color: Colors.red[600],
                                                  fontSize: 16.0),
                                            )
                                          ],
                                        ),
                                      ),
                                      // Container(
                                      //   width: MediaQuery.of(context).size.width * 0.10,
                                      //   padding: EdgeInsets.only(left: 5),
                                      //   child: Icon(Icons.remove_circle,
                                      //       color: Colors.white),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 13.0),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            color: Colors.blue[200],
                                            onPressed: () async {
                                              // _getCurrentLocation();
                                              setState(() {
                                                _openNewVersionURL(
                                                    "https://www.sawsawshar.gov.mm");
                                              });
                                            },
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 13.0),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            color: Colors.blue[200],
                                            onPressed: () async {
                                              // _getCurrentLocation();
                                              setState(() {
                                                checkNewVersion = false;
                                              });
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      )
                    : Container(),
                checkNewVersion
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox(
                        height: 90.0,
                      ),
                Container(
                    height: 150,
                    // width: 100,
                    decoration: BoxDecoration(
                        // shape: BoxShape.rectangle,
                        // border: Border.all(
                        //   color: Colors.white,
                        //   width: 5,
                        // ),
                        // boxShadow: [
                        //   BoxShadow(
                        //       color: Colors.grey.withOpacity(0.5),
                        //       offset: Offset(0, 5),
                        //       blurRadius: 25)
                        // ],
                        ),
                    //   child: CircleAvatar(
                    //       backgroundColor: Colors.blue,
                    //       backgroundImage: AssetImage("assets/start1.png")),
                    // ),
                    child: Image.asset("assets/tm-logo.png")),
                SizedBox(
                  height: 10.0,
                ),
//               TraceMyanmar မှ ကြိုဆိုပါသည်။
// Welcome to Trace Myanmar.
                Text(
                  "Saw Saw Shar",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  // "မှ ကြိုဆိုပါသည်။",
                  lan == "Zg"
                      ? Rabbit.uni2zg("မှ ကြိုဆိုပါသည်။")
                      : "မှ ကြိုဆိုပါသည်။",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Welcome to Saw Saw Shar.",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "$version",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    // color: Colors.blue
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                checkAlt
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, left: 0.0),
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                    : contactCount == 0
                        ? Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Text(
                                  // "12:00AM $todayDate အထိ COVID-19 ရောဂါ ဖြစ်ပွားသူများနှင့် ထိတွေ့မှု မတွေ့ရှိရပါ။",
                                  lan == "Zg"
                                      ? Rabbit.uni2zg(
                                          // 12:00AM
                                          "$altTime $altDate အထိ COVID-19 ရောဂါ\n ဖြစ်ပွားသူများနှင့် ထိတွေ့မှု မတွေ့ရှိရပါ။")
                                      : "$altTime $altDate အထိ COVID-19 ရောဂါ\n ဖြစ်ပွားသူများနှင့် ထိတွေ့မှု မတွေ့ရှိရပါ။",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Card(
                            elevation: 5,
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Text(
                                  // "12:00AM $todayDate အထိ COVID-19 ရောဂါ ဖြစ်ပွားသူများနှင့် ထိတွေ့မှု မတွေ့ရှိရပါ။",
                                  lan == "Zg"
                                      ? Rabbit.uni2zg(
                                          // 12:00AM
                                          "$altTime $altDate အထိ COVID-19 ရောဂါ\n ဖြစ်ပွားသူများနှင့် ($contactCount) ကြိမ်ထိတွေ့မှုရှိခဲ့ပါသည်။")
                                      : "$altTime $altDate အထိ COVID-19 ရောဂါ\n ဖြစ်ပွားသူများနှင့် ($contactCount) ကြိမ်ထိတွေ့မှုရှိခဲ့ပါသည်။",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                  ),
                                ),
                              ),
                            ),
                          ),

                // Card(
                //   elevation: 5,
                //   child: Padding(
                //     padding: const EdgeInsets.all(3.0),
                //     child: Container(
                //       width: MediaQuery.of(context).size.width * 0.70,
                //       child: Text(
                //         "**** အထိ COVID-19 ရောဂါဖြစ်ပွားသူများနှင် (၅) ကြိမ်ထိတွေ့မှုရှိပါသည်။",
                //         textAlign: TextAlign.center,
                //         style: TextStyle(fontSize: 18.0, color: Colors.red),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 15,
                ),
                // ** အထိ COVID-19 ရောဂါဖြစ်ပွားသူများနှင် (၅) ကြိမ်ထိတွေ့မှုရှိပါသည်။
                // // // GestureDetector(
                // // //   onTap: () async {
                // // //     if (trackingCheck == true) {
                // // //       // bg.BackgroundGeolocation.stop().then((bg.State state) {
                // // //       //   // print('[stop] success: $state');
                // // //       //   // Reset odometer.
                // // //       //   bg.BackgroundGeolocation.setOdometer(0.0);

                // // //       setState(() {
                // // //         //     bg.BackgroundGeolocation.changePace(false)
                // // //         //         .then((bool isMoving) {
                // // //         //       // print('[changePace] success $isMoving');
                // // //         //     }).catchError((e) {
                // // //         //       print('[changePace] ERROR: ' + e.code.toString());
                // // //         //     });
                // // //         trackingCheck = false;
                // // //       });
                // // //       final prefs = await SharedPreferences.getInstance();
                // // //       prefs.setString("chk_tracking", "0");
                // // //       prefs.setInt("timer", 0);
                // // //       prefs.setInt("saveCount", 0);
                // // //       setState(() {
                // // //         saveCount = 0;
                // // //       });
                // // //       timer.cancel();
                // // //       //     // _odometer = '0.0';
                // // //       //     // trackingCheck = state.enabled;
                // // //       //     // _isMoving = state.isMoving;
                // // //       //   });

                // // //     } else {
                // // //       //-----------
                // // //       // bg.BackgroundGeolocation.start().then((bg.State state) {
                // // //       //   // print('[start] success >> ' + state.enabled.toString());

                // // //       //     // trackingCheck = state.enabled;
                // // //       //     // _isMoving = state.isMoving;
                // // //       //     bg.BackgroundGeolocation.changePace(true)
                // // //       //         .then((bool isMoving) {
                // // //       //       // print('[changePace] success $isMoving');
                // // //       //     }).catchError((e) {
                // // //       //       print('[changePace] ERROR: ' + e.code.toString());
                // // //       //     });
                // // //       setState(() {
                // // //         trackingCheck = true;
                // // //       });

                // // //       final prefs = await SharedPreferences.getInstance();
                // // //       prefs.setString("chk_tracking", "true");
                // // //       prefs.setInt("timer", startInterval);
                // // //       _start = startInterval;
                // // //       countDownSave();
                // // //       //   });

                // // //     }
                // // //   },
                // // //   child: Container(
                // // //       height: 100,
                // // //       width: 100,
                // // //       decoration: BoxDecoration(
                // // //         shape: BoxShape.rectangle,
                // // //         border: Border.all(
                // // //           color: Colors.white,
                // // //           width: 5,
                // // //         ),
                // // //         boxShadow: [
                // // //           BoxShadow(
                // // //               color: Colors.grey.withOpacity(0.5),
                // // //               offset: Offset(0, 5),
                // // //               blurRadius: 25)
                // // //         ],
                // // //       ),
                // // //       //   child: CircleAvatar(
                // // //       //       backgroundColor: Colors.blue,
                // // //       //       backgroundImage: AssetImage("assets/start1.png")),
                // // //       // ),
                // // //       child: trackingCheck
                // // //           ? Image.asset("assets/stop1.png")
                // // //           : Image.asset("assets/start1.png")),
                // // // ),
                // // // SizedBox(
                // // //   height: 30.0,
                // // // ),
                // // // trackingCheck
                // // //     ? Column(
                // // //         children: <Widget>[
                // // //           Container(
                // // //               width: MediaQuery.of(context).size.width * 0.70,
                // // //               child: RichText(
                // // //                 textAlign: TextAlign.center,
                // // //                 text: TextSpan(
                // // //                   text:
                // // //                       'သွားရောက်သောနေရာများမှတ်သားခြင်းကို ရပ်လိုပါက ',
                // // //                   style: TextStyle(color: Colors.black),
                // // //                   children: <TextSpan>[
                // // //                     TextSpan(
                // // //                       text: 'STOP',
                // // //                       style: TextStyle(
                // // //                         color: Colors.black,
                // // //                         // fontWeight: FontWeight.bold,
                // // //                       ),
                // // //                     ),
                // // //                     TextSpan(text: ' ကို နှိပ်ပါ။'),
                // // //                   ],
                // // //                 ),
                // // //               )
                // // //               // Text(
                // // //               //   "သွားရောက်သောနေရာများကိုမှတ်သားစေလိုပါက  START ကို နှိပ်ပါ။",
                // // //               //   textAlign: TextAlign.center,
                // // //               //   style: TextStyle(
                // // //               //       color: Colors.black,
                // // //               //       fontWeight: FontWeight.bold),
                // // //               // ),
                // // //               ),
                // // //           SizedBox(
                // // //             height: 10.0,
                // // //           ),
                // // //           Container(
                // // //               width: MediaQuery.of(context).size.width * 0.70,
                // // //               child: RichText(
                // // //                 textAlign: TextAlign.center,
                // // //                 text: TextSpan(
                // // //                   text: 'Press ',
                // // //                   style: TextStyle(color: Colors.black),
                // // //                   children: <TextSpan>[
                // // //                     TextSpan(
                // // //                       text: 'STOP',
                // // //                       style: TextStyle(
                // // //                         color: Colors.black,
                // // //                         // fontWeight: FontWeight.bold,
                // // //                       ),
                // // //                     ),
                // // //                     TextSpan(
                // // //                         text:
                // // //                             ' button to stop tracing your locations.'),
                // // //                   ],
                // // //                 ),
                // // //               )),
                // // //           // Container(
                // // //           //     width: MediaQuery.of(context).size.width * 0.70,
                // // //           //     child: Text(
                // // //           //       " START button to trace your locations.",
                // // //           //       textAlign: TextAlign.center,
                // // //           //       style: TextStyle(color: Colors.black),
                // // //           //     )),
                // // //         ],
                // // //       )
                // // //     : Column(
                // // //         children: <Widget>[
                // // //           // Container(
                // // //           //     width: MediaQuery.of(context).size.width * 0.70,
                // // //           //     child: Text(
                // // //           //       "သွားရောက်သောနေရာများမှတ်သားခြင်းကို ရပ်လိုပါက STOP ကို နှိပ်ပါ။",
                // // //           //       textAlign: TextAlign.center,
                // // //           //       style: TextStyle(
                // // //           //           color: Colors.black,
                // // //           //           fontWeight: FontWeight.bold),
                // // //           //     )),
                // // //           Container(
                // // //               width: MediaQuery.of(context).size.width * 0.70,
                // // //               child: RichText(
                // // //                 textAlign: TextAlign.center,
                // // //                 text: TextSpan(
                // // //                   text:
                // // //                       'သွားရောက်သောနေရာများကို မှတ်သားစေလိုပါက ',
                // // //                   style: TextStyle(color: Colors.black),
                // // //                   children: <TextSpan>[
                // // //                     TextSpan(
                // // //                       text: 'START',
                // // //                       style: TextStyle(
                // // //                         color: Colors.black,
                // // //                         // fontWeight: FontWeight.bold,
                // // //                       ),
                // // //                     ),
                // // //                     TextSpan(text: ' ကို နှိပ်ပါ။'),
                // // //                   ],
                // // //                 ),
                // // //               )),
                // // //           SizedBox(
                // // //             height: 10.0,
                // // //           ),
                // // //           Container(
                // // //               width: MediaQuery.of(context).size.width * 0.70,
                // // //               child: RichText(
                // // //                 textAlign: TextAlign.center,
                // // //                 text: TextSpan(
                // // //                   text: 'Press ',
                // // //                   style: TextStyle(color: Colors.black),
                // // //                   children: <TextSpan>[
                // // //                     TextSpan(
                // // //                       text: 'START',
                // // //                       style: TextStyle(
                // // //                         color: Colors.black,
                // // //                         // fontWeight: FontWeight.bold,
                // // //                       ),
                // // //                     ),
                // // //                     TextSpan(
                // // //                         text: ' button to trace your locations.'),
                // // //                   ],
                // // //                 ),
                // // //               )),
                // // //           // Container(
                // // //           //     width: MediaQuery.of(context).size.width * 0.70,
                // // //           //     child: Text(
                // // //           //       "Press STOP button to stop tracing your locations.",
                // // //           //       textAlign: TextAlign.center,
                // // //           //       style: TextStyle(color: Colors.black),
                // // //           //     )),
                // // //         ],
                // // //       ),
                // // // SizedBox(
                // // //   height: 20.0,
                // // // ),
                // // // saveCount == 0
                // // //     ? Container()
                // // //     : Container(
                // // //         child: Text(
                // // //           "[" + saveCount.toString() + "]",
                // // //           textAlign: TextAlign.center,
                // // //           style: TextStyle(
                // // //               fontWeight: FontWeight.bold, fontSize: 18.0),
                // // //         ),
                // // //       )
                // Container(child: Text('$_content')),
                // Container(
                //   child: Text(
                //     'Array to save/upload',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.70,
                //   child: Text('$testArray'),
                // )
                // Text("သွားရောက်သောနေရာများမှတ်သားခြင်းကို ရပ်လိုပါက  Stop ကိုနှိပ်ပါ။")
              ],
            ),
          ),
        ),
      ),
      // persistentFooterButtons: <Widget>[form()],
      // persistentFooterButtons: <Widget>[
      //   GestureDetector(
      //     onTap: () {
      //       print("GO Contact");
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => ContactUs(),
      //           ));
      //     },
      //     child: Container(
      //       width: MediaQuery.of(context).size.width * 0.95,
      //       child: new Text(
      //         'ဆက်သွယ်ရန် (Contact)',
      //         overflow: TextOverflow.visible,
      //         textAlign: TextAlign.center,
      //         style: new TextStyle(
      //             color: Colors.lightBlue,
      //             fontSize: 15.0,
      //             fontWeight: FontWeight.normal),
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}
