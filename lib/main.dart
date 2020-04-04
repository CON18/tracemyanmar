import 'package:TraceMyanmar/LoginandRegister/login.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';//ndh
 
void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}
 
class _MyAppState extends State<MyApp> {
  String _message = '';
  String _body='';
 
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 
  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }
 
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.subscribeToTopic('hello');
    _firebaseMessaging.getToken().then((token) => print('FCM Token: '+token));
    getMessage();
  }
  
  void getMessage(){
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    setState(() {_message = message["notification"]["title"];
       _body = message["notification"]["body"];
       print('Title: '+_message);
       print('Body: '+_body);
      }
      );
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }
 
 @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Sqlite(),
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