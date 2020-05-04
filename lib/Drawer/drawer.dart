import 'dart:convert';

import 'package:TraceMyanmar/Drawer/Fleet/fleet.dart';
import 'package:TraceMyanmar/Drawer/Language/language.dart';
import 'package:TraceMyanmar/Drawer/Profile/new_profile.dart';
import 'package:TraceMyanmar/Drawer/Profile/profile.dart';
import 'package:TraceMyanmar/Drawer/Profile/profile_view.dart';
import 'package:TraceMyanmar/Drawer/report/new_report.dart';
import 'package:TraceMyanmar/Drawer/report/page.dart';
import 'package:TraceMyanmar/LoginandRegister/login.dart';
import 'package:TraceMyanmar/location/pages/home_page.dart';
import 'package:TraceMyanmar/notification/noti_list.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:url_launcher/url_launcher.dart';

class Drawerr extends StatefulWidget {
  @override
  _DrawerrState createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  String uu = '', ss = '';
  String qrText;
  String checklang = '';
  List textMyan = [
    // "စီစစ်ခြင်း\n(Verify)",
    "စိစစ်ခြင်း\n(Verify)",
    "မြေပုံ\n(Map)",
    // လမ်းကြောင်း
    "မှတ်ပုံတင်\n(Register)",
    "သတင်းပို့\n(Report)",
    "ဘာသာစကား\n(Language)"
  ];
  // List textMyan = ["စီစစ်ခြင်း", "မြေပုံ", "လမ်းကြောင်းမှတ်ပုံတင်", "သတင်းပို့", "ဘာသာစကား"];
  // List textMyan = ["Verify", "​မြေပုံ", "Register", "စစ်ဆေးမှု", " ဘာသာစကား"];
  List textEng = ["Verify", "Map", "Register", "Report", "Language"];
  // List textEng = ["စီစစ်ခြင်း(Verify)", "မြေပုံ(Map)", "လမ်းကြောင်းမှတ်ပုံတင်(Register)", "သတင်းပို့(Report)", "ဘာသာစကား(Language)"];
  var lan;
  checkLanguage() async {
    // final prefs = await SharedPreferences.getInstance();
    // checklang = prefs.getString("Lang");
    // if (checklang == "" || checklang == null || checklang.length == 0) {
    //   checklang = "Eng";
    // } else {
    //   checklang = checklang;
    // }
    checklang = "Myanmar";
    someMethod();
    analyst();
    setState(() {});
  }

  analyst() async {
    await analytics.logEvent(
      name: 'Drawer_Request',
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

  @override
  void initState() {
    super.initState();
    checkLanguage();
    getStorage();
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(20.0),
          // ),
          title: new Text(
            "Warning! ",
            style: TextStyle(color: Colors.amber),
          ),
          content: new Text("Please verify first."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  openNews() async {
    var url =
        "https://mohs.gov.mm/Main/content/publication/2019-ncov?fbclid=IwAR0H_MN_Vj3tXxDFeoBpLrqWQjTZ6C2MbP52X_tSy1jm6PTx0ozozLmqF2c";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getStorage() async {
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('UserId');
    ss = prefs.getString('UserName');

    setState(() {
      var param = [
        {"name": ss, "phone": uu}
      ];
      qrText = jsonEncode(param);
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        setState(() {
          FlutterPhoneState.startPhoneCall("2019");
        });
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
        // "သတင်းပို့ (Report)",
        "Call 2019?",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          // fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // color: Colors.grey[100],
      // child: new SizedBox(
      //     width: MediaQuery.of(context).size.width * 0.80,
      child: ListView(padding: EdgeInsets.fromLTRB(0, 00, 0, 0), children: <
          Widget>[
        Container(
          height: 250,
          width: 100,
          // color: Color.fromRGBO(40, 103, 178, 1),
          padding: EdgeInsets.all(0),
          child: new DrawerHeader(
            margin: EdgeInsets.only(bottom: 0),
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage('assets/three.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Stack(
                                    //   children: <Widget>[
                                    // Positioned(
                                    // bottom: 12.0,
                                    // left: 16.0,

                                    GestureDetector(
                                      onTap: () {
                                        uu == null
                                            ? _showDialog()
                                            :
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             Profile(userid:uu,username:ss)));
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ViewProfile(
                                            //                 userid: uu,
                                            //                 username: ss)));

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewProfile(
                                                          userid: uu,
                                                          // username: ss
                                                        )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.lightBlueAccent,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                offset: Offset(0, 5),
                                                blurRadius: 25)
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: CircleAvatar(
                                          radius: 37,
                                          backgroundImage: AssetImage(
                                              'assets/user-icon.png'),
                                        ),
                                      ),
                                    ),

                                    //   ],
                                    // ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            uu == null
                                                ? ""
                                                : lan == "Zg"
                                                    ? Rabbit.uni2zg('$uu')
                                                    : '$uu',
                                            // "+959966680686",
                                            style: TextStyle(
                                                fontFamily:
                                                    lan == "Zg" ? "Zawgyi" : "",
                                                color: Colors.white,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        // uu == null
                                        //     ? Container()
                                        //     : Icon(
                                        //         Icons.arrow_forward_ios,
                                        //         color: Colors.white70,
                                        //       ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, top: 0),
                                      child: Text(
                                        ss == null
                                            ? ""
                                            : lan == "Zg"
                                                ? Rabbit.uni2zg('$ss')
                                                : '$ss',
                                        // "Chit Oo Naung",
                                        style: TextStyle(
                                            fontFamily:
                                                lan == "Zg" ? "Zawgyi" : "",
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ],
                                ),
                                // ),
                                //   ],
                                // ),
                              ],
                            ),
                            // Column(
                            //   children: <Widget>[
                            // Stack(
                            //   children: <Widget>[
                            //     Positioned(
                            //       top: 0.0,
                            // child:

                            // (uu == "" || uu == null)
                            //     ? Container()
                            // :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                uu == null
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          print("Go Profile View>>");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewProfile(
                                                          userid: uu,
                                                          username: ss)));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5.0, right: 0.0, top: 70),
                                          child: QrImage(
                                            data: qrText.toString(),
                                            size: 70,
                                            // gapless: true,
                                            // foregroundColor: Colors.green,
                                            foregroundColor: Colors.white60,
                                            // backgroundColor: Colors.white38,
                                            errorCorrectionLevel:
                                                QrErrorCorrectLevel.H,
                                          ),
                                        ),
                                      ),
                              ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // ],
                            ),

                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: <Widget>[
                            //     Stack(
                            //       children: <Widget>[
                            //         Positioned(
                            //           // bottom: 12.0,
                            //           // left: 16.0,
                            //           child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.end,
                            //             children: <Widget>[
                            //               // GestureDetector(
                            //               //   onTap: () {},
                            //               //   child: Container(
                            //               //     child: Image.asset(
                            //               //         'assets/images/contactqr.png',
                            //               //         height: 75,
                            //               //         width: 75),
                            //               //   ),
                            //               // ),
                            //               // SizedBox(height: 20),
                            //               // // Padding(
                            //               //   padding:
                            //               //       EdgeInsets.only(left: 10),
                            //               //   child: Text(
                            //               //     "Version 1.0.9",
                            //               //     style: TextStyle(
                            //               //         color: Colors.white,
                            //               //         fontSize: 15.0),
                            //               //   ),
                            //               // ),
                            //               Padding(
                            //                 padding:
                            //                     EdgeInsets.only(left: 10, top: 5),
                            //                 child: Text(
                            //                   "",
                            //                   style: TextStyle(
                            //                       color: Color(0xFF525252),
                            //                       fontSize: 15.0),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new Positioned(
                  left: 75.0,
                  top: 65.0,
                  child: (uu == "" || uu == null)
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            uu == null
                                ? _showDialog()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewProfile(userid: uu
                                              // , username: ss
                                              ),
                                    ),
                                  );
                          },
                          child: new Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.lightBlueAccent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      offset: Offset(0, 5),
                                      blurRadius: 25)
                                ],
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.edit,
                                  size: 17,
                                ),
                              ))),
                ),
              ],
            ),
          ),
        ),
        // uu!="null" ?
        // ListTile(
        //   leading: Icon(
        //     Icons.lock,
        //     color: Colors.blue,
        //     size: 25,
        //   ),
        //   title: Text("Sign in"),
        //   trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
        //   onTap: () {
        //      _showDialog();
        //   },
        // ):
        uu == null
            ? ListTile(
                leading: Icon(
                  Icons.lock,
                  color: Colors.blue,
                  size: 25,
                ),
                title: Text(
                  // checklang == "Eng" ? textEng[0] : textMyan[0],
                  lan == "Zg" ? Rabbit.uni2zg(textMyan[0]) : textMyan[0],
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              )
            : ListTile(
                leading: Icon(
                  Icons.lock,
                  color: Colors.grey,
                  size: 25,
                ),
                title: Text(
                  // checklang == "Eng" ? textEng[0] : textMyan[0],
                  lan == "Zg" ? Rabbit.uni2zg(textMyan[0]) : textMyan[0],
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                onTap: () {
                  // setState(() {});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewProfile(
                                userid: uu,
                                // username: ss
                              )));
                },
              ),

        // // Divider(
        // //   indent: 60,
        // //   endIndent: 10,
        // //   color: Colors.grey[500],
        // //   height: 5,
        // // ),
        // // ListTile(
        // //   leading: Icon(
        // //     Icons.filter_center_focus,
        // //     color: Colors.blue,
        // //     size: 25,
        // //   ),
        // //   title: Text(checklang == "Eng" ? textEng[2] : textMyan[2]),
        // //   trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
        // //   onTap: () {
        // //     Navigator.push(
        // //       context,
        // //       MaterialPageRoute(builder: (context) => Fleet()),
        // //     );
        // //   },
        // // ),
        Divider(
          indent: 60,
          endIndent: 10,
          color: Colors.grey[500],
          height: 5,
        ),
        ListTile(
          leading: Icon(
            // Icons.assignment,
            Icons.mode_edit,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(
            // checklang == "Eng" ? textEng[3] : textMyan[3],
            lan == "Zg" ? Rabbit.uni2zg(textMyan[3]) : textMyan[3],
            style: TextStyle(
              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PageNew()),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewReport()),
            );
          },
        ),

        Divider(
          indent: 60,
          endIndent: 10,
          color: Colors.grey[500],
          height: 5,
        ),
        ListTile(
          leading: Icon(
            // Icons.bug_report,
            Icons.notifications,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(
            // checklang == "Eng" ? textEng[3] : textMyan[3],
            lan == "Zg"
                ? Rabbit.uni2zg("အသိပေးချက်များ\n(Notice)")
                : "အသိပေးချက်များ\n(Notice)",
            style: TextStyle(
              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotiList()),
            );
          },
        ),
        Divider(
          indent: 60,
          endIndent: 10,
          color: Colors.grey[500],
          height: 5,
        ),
        ListTile(
          leading: Icon(
            Icons.location_searching,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(
            // checklang == "Eng" ? textEng[1] : textMyan[1],
            lan == "Zg" ? Rabbit.uni2zg(textMyan[1]) : textMyan[1],
            style: TextStyle(
              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        Divider(
          indent: 60,
          endIndent: 10,
          color: Colors.grey[500],
          height: 5,
        ),
        ListTile(
          leading: Icon(
            // Icons.bug_report,
            Icons.assignment,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(
            // checklang == "Eng" ? textEng[3] : textMyan[3],
            lan == "Zg"
                ? Rabbit.uni2zg("ကိုဗစ် (၁၉) သတင်းများ\n(COVID-19 News)")
                : "ကိုဗစ် (၁၉) သတင်းများ\n(COVID-19 News)",
            style: TextStyle(
              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PageNew()),
            // );
            openNews();
          },
        ),
        Divider(
          indent: 60,
          endIndent: 10,
          color: Colors.grey[500],
          height: 5,
        ),
        ListTile(
          leading: Icon(
            Icons.headset_mic,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(
            // checklang == "Eng" ? textEng[3] : textMyan[3],
            // lan == "Zg"
            //     ? Rabbit.uni2zg("ကိုဗစ် (၁၉) သတင်းများ\n(COVID-19 News)")
            //     : "ကိုဗစ် (၁၉) သတင်းများ\n(COVID-19 News)",
            "Call Center (2019)",
            style: TextStyle(
              fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PageNew()),
            // );
            // openNews();
            showAlertDialog(context);
          },
        ),
        Divider(
          indent: 60,
          endIndent: 10,
          color: Colors.grey[500],
          height: 5,
        ),

        // ListTile(
        //   leading: Icon(
        //     Icons.language,
        //     color: Colors.blue,
        //     size: 25,
        //   ),
        //   title: Text(checklang == "Eng" ? textEng[4] : textMyan[4]),
        //   trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => LanguagePage()),
        //     );
        //   },
        // ),
        // Divider(
        //   indent: 60,
        //   endIndent: 10,
        //   color: Colors.grey[500],
        //   height: 5,
        // ),
      ]),
    );
  }
}
