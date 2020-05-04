import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:TraceMyanmar/startInterval.dart';
import 'package:device_id/device_id.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rabbit_converter/rabbit_converter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NotiList extends StatefulWidget {
  @override
  _NotiListState createState() => _NotiListState();
}

class _NotiListState extends State<NotiList> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();

  String lan = '';
  String checkfont = '';
  bool isLoading = true;
  List notiLists = [];
  List readList = [];
  // var notiLists = [
  // {
  //   "date": "2020-04-28",
  //   "msgid": "1",
  //   "post": "Topic Body body 1",
  //   "time": "17:55:00",
  //   "topic": "Topic Header 1",
  //   "url": "url"
  // },
  //   {
  //     "date": "2020-04-28",
  //     "msgid": "2",
  //     "post":
  //         // "Topic Body body body 2",
  //         "Topic Body body body body body body body body  body body body body body 2",
  //     "time": "18:05:00",
  //     "topic": "Topic Header 2",
  //     "url": ""
  //   }
  // ];

  @override
  void initState() {
    super.initState();
    someMethod();

    analyst();
    _getLists();
  }

  // // Future get _localPath async {
  // //   final directory = await getApplicationDocumentsDirectory();
  // //   return directory.path;
  // // }

  // // Future get _localFile async {
  // //   final path = await _localPath;
  // //   return File('$path/readList.txt');
  // // }

  // // Future writeReadList(list) async {
  // //   final file = await _localFile;

  // //   // Write the file
  // //   return file.writeAsString(list);
  // // }

  // // Future readL() async {
  // //   try {
  // //     final file = await _localFile;

  // //     // Read the file
  // //     String rl = await file.readAsString();

  // //     return rl;
  // //   } catch (e) {
  // //     // If we encounter an error, return 0
  // //     return 0;
  // //   }
  // // }

  // // getRead() async {
  // //   readL().then((res) {
  // //     var ab = json.decode(res);
  // //     print("RES >> $res" + ab[0].toString());
  // //   });
  // // }

  _getLists() async {
    var deviceId = await DeviceId.getID;
    final prefs = await SharedPreferences.getInstance();
    var ph = prefs.getString('UserId') ?? "";
    setState(() {
      String url = url2 + "/module001/serviceRegisterTraceMyanmar/getnotitopic";
      var body;

      body = jsonEncode({"msgid": 0, "uuid": deviceId, "phoneno": ph});
      // }
      // snackbarmethod1("BODY >> " + body.toString());
      // print("SE BODY >> " + body.toString());
      http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      }).then((dynamic res) async {
        print("Response >> " + res.toString());
        var result = json.decode(utf8.decode(res.bodyBytes));
        var data = result['datalist'];
        notiLists = List.generate(0, (i) => "Item");
        // print("RES ")
        print("RES >>> " + data.length.toString());
        for (var i = 0; i < data.length; i++) {
          notiLists.add({
            "date": data[i]["date"],
            "msgid": data[i]["msgid"],
            "post": data[i]["post"],
            "time": data[i]["time"],
            "topic": data[i]["topic"],
            "url": data[i]["url"],
            "read": true
          });
        }

        prefs.setString('tempo-notiList', notiLists.toString());

        // // var rl = [];
        // // readL().then((res) {
        // //   if (res != 0) {
        // //     rl = json.decode(res);
        // //     print("RES >> $res -- ");
        // //     // for (var l = 0; l < rl.length; l++) {
        // //     //   print("JJJ >> " + rl[l].toString());
        // //     // }
        // //     for (var i = 0; i < data.length; i++) {
        // //       // print("DDD >> " + data[i]["topic"].toString());

        // //       var ck = 0;
        // //       for (var j = 0; j < rl.length; j++) {
        // //         // print("JJJ >> " +
        // //         //     rl[j].toString() +
        // //         //     "|" +
        // //         //     data[i]["msgid"].toString());
        // //         if (rl[j].toString() == data[i]["msgid"].toString()) {
        // //           ck = 1;
        // //         }
        // //       }
        // //       if (ck == 1) {
        // //         // print("AAA>>>");
        // //         //true
        // //         readList.add(data[i]["msgid"]);
        // // notiLists.add({
        // //   "date": data[i]["date"],
        // //   "msgid": data[i]["msgid"],
        // //   "post": data[i]["post"],
        // //   "time": data[i]["time"],
        // //   "topic": data[i]["topic"],
        // //   "url": data[i]["url"],
        // //   "read": true
        // // });
        // //       } else {
        // //         // false
        // //         // print("BBB>>>");
        // //         // notiLists.add(data[i]);
        // //         notiLists.add({
        // //           "date": data[i]["date"],
        // //           "msgid": data[i]["msgid"],
        // //           "post": data[i]["post"],
        // //           "time": data[i]["time"],
        // //           "topic": data[i]["topic"],
        // //           "url": data[i]["url"],
        // //           "read": false
        // //         });
        // //       }
        // //       // });
        // //     }
        // //   } else {
        // //     for (var i = 0; i < data.length; i++) {
        // //       notiLists.add({
        // //         "date": data[i]["date"],
        // //         "msgid": data[i]["msgid"],
        // //         "post": data[i]["post"],
        // //         "time": data[i]["time"],
        // //         "topic": data[i]["topic"],
        // //         "url": data[i]["url"],
        // //         "read": false
        // //       });
        // //     }
        // //   }
        // //   setState(() {});
        // // });

        // print("NLL>>" + notiLists[0]["date"].toString());
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  analyst() async {
    await analytics.logEvent(
      name: 'NotiList_Request',
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

  _onRefresh() async {
    // monitor network fetch
    // isLoading = true;

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    print("REFRESH MESSAGE LIST > ");

    // msgLists = List.generate(0, (i) => "Item");
    // await Future.delayed(Duration(milliseconds: 1000));
    // var date = convertDateTime();
    // print("Date Format Test >> " + date.toString());

    setState(() {
      _getLists();
    });

    _refreshController.refreshCompleted();
    // _startBG();
    // setState(() {});
    // _listKey.currentState.initState();
  }

  showList() async {
    final prefs = await SharedPreferences.getInstance();
    var ls = prefs.getString('tempo-notiList');
    print("LS >> " + ls);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
            lan == "Zg"
                ? Rabbit.uni2zg('​အသိပေးချက်များ (Notice)')
                : 'အသိပေးချက်များ (Notice)',
            // '​မြေပုံ (Map)',
            style: TextStyle(
                fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                fontWeight: FontWeight.w300,
                fontSize: 18.0)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyan,
                strokeWidth: 5,
              ),
            )
          : notiLists.isEmpty
              ? Center(
                  child: Text(
                    'No Notification',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              // : RefreshIndicator(
              //     onRefresh: () async {
              //       print("Refresh message list");
              //     },
              //     child:
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  // header: WaterDropHeader(),
                  child: ListView.separated(
                      controller: _scrollController,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                            color: Colors.lightBlue,
                          ),
                      // separatorBuilder: (BuildContext context, int index) => Divider(),
                      itemCount: notiLists == null ? 0 : notiLists.length,
                      itemBuilder: (context, i) {
                        return Container(
                          color: Colors.white,
                          child: new ListTile(
                            onTap: () async {
                              // print("URL >> " + notiLists[i]["url"]);
                              // setState(() {
                              //   // print("URL >> " + readList.length.toString());
                              //   // if (readList.length > 0) {
                              //   print("lll");
                              //   // if (readList.toString().contains(
                              //   //     notiLists[i]["msgid"].toString())) {
                              //   // } else {
                              //   readList.add(notiLists[i]["msgid"]);
                              //   // }
                              //   //   for (var j = 0; j < readList.length; j++) {
                              //   //     print("J2J >> " + readList[j].toString() !=
                              //   //         notiLists[i]["msgid"].toString());
                              //   //     if (readList[j].toString() !=
                              //   //         notiLists[i]["msgid"].toString()) {
                              //   //       readList.add(notiLists[i]["msgid"]);
                              //   //     }
                              //   //   }
                              //   // } else {
                              //   //   readList.add(notiLists[i]["msgid"]);
                              //   // }
                              //   writeReadList(readList.toString());
                              // });
                              if (notiLists[i]["url"] != "") {
                                var url = "https://www.mohs.gov.mm/";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }
                            },
                            // leading: Container(
                            //   width: 40,
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: <Widget>[
                            //       Container(
                            //         alignment: Alignment.center,
                            //         height: 10,
                            //         width: 10,
                            //         decoration: BoxDecoration(
                            //           color: Colors.blue,
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: Text(
                            //           "",
                            //           style: TextStyle(color: Colors.white),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  // notiLists[i]["topic"],
                                  lan == "Zg"
                                      ? Rabbit.uni2zg(notiLists[i]["topic"])
                                      : notiLists[i]["topic"],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                    fontWeight: notiLists[i]["read"]
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  notiLists[i]["time"] +
                                      " " +
                                      notiLists[i]["date"],
                                  textAlign: TextAlign.right,
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  // notiLists[i]["post"],
                                  lan == "Zg"
                                      ? Rabbit.uni2zg(notiLists[i]["post"])
                                      : notiLists[i]["post"],
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontFamily:
                                        lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                                  ),
                                ),
                                // notiLists[i]["url"] == ""
                                //     ? Container()
                                //     : SizedBox(
                                //         width: 3,
                                //       ),
                                // notiLists[i]["url"] == ""
                                //     ? Container()
                                //     : Text("https://www.mohs.gov.mm",
                                //         style: TextStyle(
                                //             decoration:
                                //                 TextDecoration.underline,
                                //             color: Colors.blue)),

                                // Divider(
                                //   color: Colors.grey,
                                // )
                                // SizedBox(
                                //   height: 3,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 3.0),
                                //   child: Text(
                                //     notiLists[i]["date"] +
                                //         " " +
                                //         notiLists[i]["time"],
                                //     overflow: TextOverflow.ellipsis,
                                //   ),
                                // ),
                              ],
                            ),
                            trailing:
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   children: <Widget>[
                                //  Container()
                                Icon(Icons.keyboard_arrow_right,
                                    color: notiLists[i]["url"] == ""
                                        ? Colors.transparent
                                        : Colors.black45,
                                    size: 30.0),
                            // Container(
                            //   alignment: Alignment.center,
                            //   height: 10,
                            //   width: 10,
                            //   decoration: BoxDecoration(
                            //     color: Colors.blue,
                            //     shape: BoxShape.circle,
                            //   ),
                            //   child: Text(
                            //     "",
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            //   ],
                            // ),
                            // leading:

                            // trailing: Container(
                            //   width: 120,
                            //   // height: 20,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.end,
                            //     children: [
                            //       Row(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           Text(
                            //             notiLists[i]["date"] +
                            //             " " +
                            //             notiLists[i]["time"],
                            //             style: TextStyle(
                            //                 fontFamily: "Pyidaungsu",
                            //                 color: Colors.black45),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                        );
                      }),
                ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // getRead();
      //     showList();
      //   },
      //   child: Icon(
      //     Icons.add,
      //   ),
      //   backgroundColor: Colors.pink,
      // ),
    );
  }
}
