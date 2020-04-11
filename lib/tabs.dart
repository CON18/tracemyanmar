import 'dart:async';
import 'dart:convert';

import 'package:TraceMyanmar/Drawer/drawer.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:TraceMyanmar/tracking/bgd_tracking.dart';
import 'package:TraceMyanmar/version_history.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

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
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final String url =
      "https://play.google.com/store/apps/details?id=com.mit.TraceMyanmar2020&hl=en";
  String checklang = '';
  List textMyan = [];
  List textEng = [];
  var dbHelper;

  var deviceId;
  var location;

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
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.index = widget.openTab;
    // onTabTapped(1);
    _getDeviceId();
    _getCurrentLocation();
    dbHelper = DBHelper();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // timer.cancel();
    super.dispose();
  }

  _getCurrentLocation() async {
    setState(() {});
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
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  getCardno() async {
    final prefs = await SharedPreferences.getInstance();
    var ph = prefs.getString('UserId');
    var name = prefs.getString('UserName');
    var setList = [];
    setList = await dbHelper.getEmployees();
    setState(() {});
    var data = [];
    for (var i = 0; i < setList.length; i++) {
      var index = setList[i].location.toString().indexOf(',');
      data.add({
        "phoneNo": ph,
        "deviceId": deviceId,
        "latitude": setList[i].location.toString().substring(0, index),
        "longitude": setList[i].location.toString().substring(index + 1),
        "time": setList[i].time
      });
    } //http://192.168.205.137:8081/IonicDemoService/module001/service005/saveUser
    //
    final url =
        'http://52.187.13.89:8080/tracemyanmar/module001/service005/saveUser';
    var body = jsonEncode({"data": data});
    print(body);
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print(result);
      if (result['msgCode'] == "0000") {
        // color = "0";
        // _scaffoldkey.currentState.showSnackBar(new SnackBar(
        //   content: new Text("Submitted Successfully!"),
        //   backgroundColor: Colors.blue.shade400,
        //   duration: Duration(seconds: 1),
        // ));
        this.snackbarmethod1("Submitted successfully");
      } else {
        // this.alertmsg = result['msgDesc'];
        this.snackbarmethod1(result['msgDesc']);
      }
    });
  }

  _openURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "TraceMyanmar",
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
                    icon: new Icon(Icons.home),
//                     text: '''   မူလ
// (Home)''',
                    // text: '''မူလ (Home)''',
                  ),
                ),
                Container(
                  height: 60,
                  child: new Tab(
                    icon: new Icon(Icons.format_list_bulleted),
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
              timer.cancel();
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
                    Text(
                  checklang == "Eng"
                      ? textEng[2] + " (Submit)"
                      : textMyan[2] + " (Submit)",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black),
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
              PopupMenuItem(
                value: 2,
                child:
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    Text(
                        checklang == "Eng"
                            ? textEng[3] + " (Version)"
                            : textMyan[3] + " (Version)",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                //     Text(" (Version)",
                //         style: TextStyle(
                //             fontWeight: FontWeight.w400,
                //             color: Colors.black)),
                //   ],
                // ),
              ),
            ],
            // initialValue: 2,
            onCanceled: () {
              print("You have canceled the menu.");
            },
            onSelected: (value) {
              print("value:$value");
              if (value == 1) {
                setState(() {
                  // isUpdating = false;
                  setState(() {
                    getCardno();
                  });
                });
              }
              if (value == 2) {
                setState(() {
                  _openURL();
                });
              }
            },
            // icon: Icon(Icons.list),
          ),
        ],
      ),
      drawer: Drawerr(),
      body: new TabBarView(
        children: <Widget>[BackgroundTracking(), Sqlite()],
        controller: _tabController,
      ),
      // floatingActionButton: [...]
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
