import 'package:TraceMyanmar/Drawer/Fleet/fleet.dart';
import 'package:TraceMyanmar/Drawer/Language/language.dart';
import 'package:TraceMyanmar/Drawer/Profile/new_profile.dart';
import 'package:TraceMyanmar/Drawer/Profile/profile.dart';
import 'package:TraceMyanmar/Drawer/Profile/profile_view.dart';
import 'package:TraceMyanmar/Drawer/report/new_report.dart';
import 'package:TraceMyanmar/Drawer/report/page.dart';
import 'package:TraceMyanmar/LoginandRegister/login.dart';
import 'package:TraceMyanmar/location/pages/home_page.dart';
import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerr extends StatefulWidget {
  @override
  _DrawerrState createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
  String uu = '', ss = '';
  String checklang = '';
  List textMyan = [
    "စီစစ်ခြင်း                        (Verify)",
    "မြေပုံ                                    (Map)",
    "လမ်းကြောင်းမှတ်ပုံတင် (Register)",
    "သတင်းပို့                                      (Report)",
    "ဘာသာစကား              (Language)"
  ];
  // List textMyan = ["စီစစ်ခြင်း", "မြေပုံ", "လမ်းကြောင်းမှတ်ပုံတင်", "သတင်းပို့", "ဘာသာစကား"];
  // List textMyan = ["Verify", "​မြေပုံ", "Register", "စစ်ဆေးမှု", " ဘာသာစကား"];
  List textEng = ["Verify", "Map", "Register", "Report", "Language"];
  // List textEng = ["စီစစ်ခြင်း(Verify)", "မြေပုံ(Map)", "လမ်းကြောင်းမှတ်ပုံတင်(Register)", "သတင်းပို့(Report)", "ဘာသာစကား(Language)"];

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
    getStorage();
  }

  // Column(
  //   children: <Widget>[
  //     GestureDetector(
  //       onTap: () {
  //         print("Go Profile View>>");
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ViewProfile(
  //                     userid: widget.userid,
  //                     username: widget.username)));
  //       },
  //       child: Container(
  //         padding:
  //             EdgeInsets.only(left: 5.0, right: 0.0, top: 70),
  //         child: QrImage(
  //           data: qrText.toString(),
  //           size: 60,
  //           // gapless: true,
  //           // foregroundColor: Colors.green,
  //           foregroundColor: Colors.black,
  //           backgroundColor: Colors.white38,
  //           errorCorrectionLevel: QrErrorCorrectLevel.H,
  //         ),
  //       ),
  //     ),
  //   ],
  // )

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Warning! "),
          content: new Text("Please Sign in first"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getStorage() async {
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('UserId');
    ss = prefs.getString('UserName');
    setState(() {});
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
          height: 200,
          width: 100,
          // color: Color.fromRGBO(40, 103, 178, 1),
          padding: EdgeInsets.all(0),
          child: new DrawerHeader(
            margin: EdgeInsets.only(bottom: 0),
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage('assets/three.png'),
                      fit: BoxFit.cover,
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
                            Stack(
                              children: <Widget>[
                                Positioned(
                                  // bottom: 12.0,
                                  // left: 16.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
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
                                                                username: ss)));
                                          },
                                          child: CircleAvatar(
                                            radius: 37,
                                            backgroundImage: AssetImage(
                                                'assets/user-icon.png'),
                                          )),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          uu == null ? "" : '$uu',
                                          // "+959966680686",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 0),
                                        child: Text(
                                          ss == null ? "" : '$ss',
                                          // "ချစ်ဦးနောင်",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Positioned(
                                  // bottom: 12.0,
                                  // left: 16.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      // GestureDetector(
                                      //   onTap: () {},
                                      //   child: Container(
                                      //     child: Image.asset(
                                      //         'assets/images/contactqr.png',
                                      //         height: 75,
                                      //         width: 75),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 20),
                                      // // Padding(
                                      //   padding:
                                      //       EdgeInsets.only(left: 10),
                                      //   child: Text(
                                      //     "Version 1.0.9",
                                      //     style: TextStyle(
                                      //         color: Colors.white,
                                      //         fontSize: 15.0),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 5),
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              color: Color(0xFF525252),
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
        ListTile(
          leading: Icon(
            Icons.lock,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(checklang == "Eng" ? textEng[0] : textMyan[0]),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
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
          title: Text(checklang == "Eng" ? textEng[1] : textMyan[1]),
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
            Icons.filter_center_focus,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(checklang == "Eng" ? textEng[2] : textMyan[2]),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Fleet()),
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
            Icons.bug_report,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(checklang == "Eng" ? textEng[3] : textMyan[3]),
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
            Icons.language,
            color: Colors.blue,
            size: 25,
          ),
          title: Text(checklang == "Eng" ? textEng[4] : textMyan[4]),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguagePage()),
            );
          },
        ),
        Divider(
          indent: 60,
          endIndent: 10,
          color: Colors.grey[500],
          height: 5,
        ),
      ]),
    );
  }
}
