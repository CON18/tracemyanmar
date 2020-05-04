import 'package:device_id/device_id.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class About extends StatefulWidget {
  final String uuid;
  // final String chatkey;
  About({
    Key key,
    @required this.uuid,
    //   @required this.chatkey
  }) : super(key: key);
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var deviceId = '';
  var error = '';
  int count = 0;
  String checkfont = '';
  String lan = '';
  bool showUUID = false;
  @override
  void initState() {
    super.initState();
    _getDeviceId();
    deviceId = widget.uuid;
    analyst();
    someMethod();
    // dbHelper = DBHelper();
    // _checkAndstartTrack();
    //    String text = 'ယေဓမ္မာ ဟေတုပ္ပဘဝါ တေသံ ဟေတုံ တထာဂတော အာဟ တေသဉ္စ ယောနိရောဓေါ ဧဝံ ဝါဒီ မဟာသမဏော။';
    // String zawgyiText = Rabbit.uni2zg(text);
    // String unicodeText = Rabbit.zg2uni(zawgyiText);
  }

  analyst() async {
    await analytics.logEvent(
      name: 'About_Request',
      parameters: <String, dynamic>{
        // 'string': myController.text,
      },
    );
  }

  Future someMethod() async {
    String deviceLanguage = await Devicelocale.currentLocale;
    checkfont = deviceLanguage.substring(3, 5);
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

  _getError() async {
    final prefs = await SharedPreferences.getInstance();
    var err = prefs.getString("errorLog") ?? "no error";
    setState(() {
      // error = err;
    });
  }

  _getDeviceId() async {
    var did = await DeviceId.getID;
    setState(() {
      deviceId = did;
      print(deviceId);
    });
  }

  @override
  void dispose() {
    // timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        // key: _scaffoldKey,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        // title: Text(
        //   "Edit Profile",
        //   style: TextStyle(
        //       fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        // ),
        backgroundColor: Colors.blue.withOpacity(0.8),
        elevation: 0.0,
        // title: Text(
        //   checklang == "Eng" ? textEng[0] : textMyan[0],
        //   style: TextStyle(
        //       fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        // ),
        title: Text(
          "About",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
        ),
        centerTitle: true,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                  color: Colors.blue.withOpacity(0.8),
                  // height: 250.0,
                  height: MediaQuery.of(context).size.height * 0.20),
              // height: orientation == Orientation.portrait ? 100.0 : 200.0,
              // clipper: getClipper(),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Flexible(
                  //   flex: 1,
                  // child: Container(
                  // child:

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        // padding: const EdgeInsets.only(top: 17.0, left: 120.0),
                        padding: const EdgeInsets.only(
                            top: 80.0, left: 0.0, bottom: 0.0),
                        child: Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 7,
                            ),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Colors.grey.withOpacity(0.5),
                            //       offset: Offset(0, 5),
                            //       blurRadius: 25)
                            // ],
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: GestureDetector(
                                onTap: () {
                                  print("YOUR CLICK PRO IMG >>");
                                  // count += 1;
                                  // if (count == 5) {
                                  //   _getError();
                                  //   count = 0;
                                  // }
                                  // _getDeviceId();
                                  setState(() {
                                    count += 1;

                                    if (count >= 2) {
                                      showUUID = true;
                                    }
                                  });
                                },
                                child:
                                    // CircleAvatar(
                                    //     backgroundImage:
                                    //         AssetImage("images/choose_img1.png")),
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // border: Border.all(
                                    //   color: Colors.lightBlueAccent,
                                    //   width: 3,
                                    // ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(0, 5),
                                          blurRadius: 25)
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: CircleAvatar(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          AssetImage("assets/tm-logo1.png")
                                      // backgroundImage:
                                      //     AssetImage("images/default.jpg")
                                      ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                    // ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Text(
                              lan == "Zg"
                                  ? Rabbit.uni2zg(
                                      '''ဤ Mobile Application ကို Coronavirus Disease 2019 (COVID-19) ထိန်းချုပ်ရေးနှင့် အရေးပေါ် တုံ့ပြန်ရေး ICT နည်းပညာအထောက်အကူပြုလုပ်ငန်းအဖွဲ့က ထုတ်ဝေပါသည်။

This Mobile Application is distributed by the Coronavirus Disease 2019 (COVID-19) Control and Emergency Response ICT Team.''')
                                  : '''ဤ Mobile Application ကို Coronavirus Disease 2019 (COVID-19) ထိန်းချုပ်ရေးနှင့် အရေးပေါ် တုံ့ပြန်ရေး ICT နည်းပညာအထောက်အကူပြုလုပ်ငန်းအဖွဲ့က ထုတ်ဝေပါသည်။

This Mobile Application is distributed by the Coronavirus Disease 2019 (COVID-19) Control and Emergency Response ICT Team.''',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily:
                                      lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                  fontSize: 15.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Image.asset("assets/mm.png"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Image.asset("assets/mcf.png"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       child: Text(
                  //         "UUID",
                  //         style: TextStyle(
                  //             fontSize: 20, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  showUUID
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "UUID: " + deviceId.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  // new Container(
                  //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                  //     height: 2.0,
                  //     width: 100.0,
                  //     color: Colors.blue[200]),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    color: Colors.red,
                    child: Text(error),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
