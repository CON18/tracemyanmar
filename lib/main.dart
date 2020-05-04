import 'dart:convert';
import 'dart:io';

import 'package:TraceMyanmar/Drawer/Profile/new_profile.dart';
import 'package:TraceMyanmar/LoginandRegister/login.dart';
import 'package:TraceMyanmar/bluetooth/test_bluetooth.dart';
import 'package:TraceMyanmar/splash_screen.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tabs.dart';
import 'package:TraceMyanmar/test.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; //ndh
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String _message = '';
  String _body = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // _register() {
  //   _firebaseMessaging.getToken().then((token) => print(token));
  // }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    _firebaseMessaging.subscribeToTopic('hello');
    // _firebaseMessaging.getToken().then((token) => () {
    //       print('FCM Token: '+token);
    //       token = token;
    //       _sendUUID();
    //     });

    _getFCMToken();

    _permissionToAlt();
    getMessage();
  }

  _getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    var tok = prefs.getString("fcmToken") ?? "";
    if (tok == "") {
      _firebaseMessaging.getToken().then((token) {
        print("TOKEN >> " + token.toString());
        // token = token;

        prefs.setString("fcmToken", token.toString());
        _sendUUID(token.toString());
      });
    } else {
      print("Token already exist >> $tok");
    }
  }

  _permissionToAlt() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("altPermission", "1");
    prefs.setString("mohsData", "1");
    prefs.setString("getversion", "1");
  }

  void _sendUUID(token) async {
    var did = await DeviceId.getID;

    // HttpClient client = new HttpClient();
    // client.badCertificateCallback =
    //     ((X509Certificate cert, String host, int port) => true);

    // String url = 'https://service.mcf.org.mm/module001/service004/saveUser';

    // Map map = {"uuid": did.toString(), "fcmToken": token.toString()};
    // print("IF >> " + map.toString());
    // HttpClientRequest request = await client.postUrl(Uri.parse(url));

    // request.headers.set('content-type', 'application/json');

    // request.add(utf8.encode(json.encode(map)));

    // HttpClientResponse response = await request.close();

    // var reply = await response.transform(utf8.decoder).join();
    // var result = json.decode(reply);
    // print("REPLT >> " + result["code"].toString());
    // if (result["code"].toString() == "0000") {
    //   print("CODE >> " + result['desc'].toString());
    // } else {
    //   final prefs = await SharedPreferences.getInstance();
    //   prefs.setString(
    //       "errorLog", "ERROR FROM SEND UUID >> " + result['desc'].toString());
    // }
    // client.close();

    //   var result = json.decode(response);
    //     var resStatus = result['code'];
    // print("RES >> " + response.toString());
    setState(() {
      // String url = "https://service.mcf.org.mm/module001/service004/saveUser";
      // String url = "http://uatsssverify.azurewebsites.net/module001/service004/saveUser";
      String url = url2 + "/module001/service004/saveUser";
      // "http://52.187.13.89:8080/tracemyanmar/module001/service004/saveUser";
      var body =
          jsonEncode({"uuid": did.toString(), "fcmToken": token.toString()});
      // print("BODY >> " + body.toString());
      http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((dynamic res) async {
        print("Response >> " + res.toString());
        var result = json.decode(utf8.decode(res.bodyBytes));
        var resStatus = result['code'];
        print("CODE >> " + resStatus.toString());
        if (resStatus == '0000') {
          print("CODE >> " + result['desc'].toString());
        } else {
          print("ERROR ");
        }
      }).catchError((Object error) async {
        print("ON ERROR 11 >>");
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("errorLog", "ERROR FROM SEND UUID >> " + error);
      });
    });

    //    response : {
    //  	 "code": "0000",
    //  	 "desc": "Saved Successfully.",
    //  	 "error": ""
    // }
  }

  showNotification(Map<String, dynamic> message) async {
    // _message = message["notification"]["title"];
    // _body = message["notification"]["body"];
    // print('Title: ' + _message);
    // print('Body: ' + _body);
    var android = new AndroidNotificationDetails(
      'sss-id',
      message["notification"]["title"],
      message["notification"]["body"],
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, message["notification"]["title"], message["notification"]["body"], platform);
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() {
        // _message = message["notification"]["title"];
        // _body = message["notification"]["body"];
        // print('Title: ' + _message);
        // print('Body: ' + _body);
        showNotification(message);
      });
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => () {
            _message = message["notification"]["title"];
            _body = message["notification"]["body"];
            print('Title: ' + _message);
            print('Body: ' + _body);
          });
      // _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => () {
            _message = message["notification"]["title"];
            _body = message["notification"]["body"];
            print('Title: ' + _message);
            print('Body: ' + _body);
          });
      // _message = message["notification"]["title"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashScreenPage(),
      routes: {
        '/': (BuildContext context) => SplashScreenPage(),
        // '/': (BuildContext context) => TestBluetooth(),
        '/home': (BuildContext context) => TabsPage(
              openTab: 0,
            ),
        '/list': (BuildContext context) => TabsPage(
              openTab: 2,
            ),
        '/profile': (BuildContext context) => NewProfile(),
        // TabsPage(
        //               openTab: 2,
        //             )));
        // '/another': (BuildContext context) => Another()
      },
      // home: DemoTracking(),
      // home: Scaffold(
      //   body: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Text("Message: $_message"),
      //       OutlineButton(
      //         child: Text("Register My Device"),
      //         onPressed: () {
      //           _register();
      //         },
      //       ),
      //       // Text("Message: $message")
      //     ]),
      //   ),
      // ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Sqlite(),
//     );
//   }
// }
// }
