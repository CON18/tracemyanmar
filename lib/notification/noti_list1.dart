import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class NotiList extends StatefulWidget {
  @override
  _NotiListState createState() => _NotiListState();
}

class _NotiListState extends State<NotiList> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String lan = '';
  String checkfont = '';

  var notiLists = [
    {
      "date": "2020-04-28",
      "msgid": "1",
      "post": "Topic Body body 1",
      "time": "17:55:00",
      "topic": "Topic Header 1",
      "url": ""
    },
    {
      "date": "2020-04-28",
      "msgid": "2",
      "post": "Topic Body body body 2",
      "time": "18:05:00",
      "topic": "Topic Header 2",
      "url": ""
    }
  ];

  @override
  void initState() {
    super.initState();
    someMethod();

    analyst();
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

  Widget buildItem(int i, notiList) {
    return Column(
      children: <Widget>[
        Container(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 5),
            child: Card(
              elevation: 6.0,
              // margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              // shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                decoration:
                    // BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    BoxDecoration(
                        color: Colors.lightBlue[800],
                        borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(
                        right: 12.0,
                      ),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      // "Topic Header",
                      notiList[i]["topic"],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Icon(Icons.linear_scale,
                                //     color: Colors.lightBlue),
                                Text(" " + notiList[i]["post"],
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: <Widget>[
                                // Padding(
                                // padding: const EdgeInsets.only(right:5.0),
                                // child:
                                // Icon(
                                //   Icons.access_time,
                                //   color: Colors.lightBlue,
                                //   size: 19,
                                // ),
                                // ),
                                Text(
                                    "  " +
                                        notiList[i]["date"] +
                                        " " +
                                        notiList[i]["time"],
                                    style: TextStyle(color: Colors.white))
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Colors.white, size: 30.0)),
              ),
            ),
            // child: new ListTile(
            //   onTap: () async {},
            //   trailing: Icon(
            //     Icons.arrow_forward_ios,
            //     color: Colors.black26,
            //   ),
            //   // leading: GestureDetector(
            //   //   onTap: () {

            //   //   },
            //   //   child: new Container(
            //   //     child: Icon(Icons.location_on,
            //   //         size: 30,
            //   //         color: (employees[i]["location"] == "" ||
            //   //                 employees[i]["location"] == null)
            //   //             ? Colors.grey
            //   //             : employees[i]["marker"] == "blue"
            //   //                 ? Colors.blue
            //   //                 : employees[i]["marker"] == "green"
            //   //                     ? Colors.blue[800]
            //   //                     : employees[i]["marker"] == "brown"
            //   //                         ? Colors.brown
            //   //                         : Colors.grey),
            //   //     // Icon(Icons.location_on),
            //   //   ),
            //   // ),
            //   title: Text(
            //     "title",
            //     style: TextStyle(
            //       fontFamily: "Pyidaungsu",
            //       fontWeight: FontWeight.bold,
            //       fontSize: 15.0,
            //     ),
            //   ),

            //   subtitle: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       SizedBox(
            //         height: 5.0,
            //       ),
            //       Text(
            //         "body",
            //         style: TextStyle(
            //           fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
            //           color: Colors.black,
            //           fontWeight: FontWeight.normal,
            //           fontSize: 15.0,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
            lan == "Zg"
                ? Rabbit.uni2zg('​အသိပေးချက်များ (Notifications)')
                : 'အသိပေးချက်များ (Notifications)',
            // '​မြေပုံ (Map)',
            style: TextStyle(
                fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                fontWeight: FontWeight.w300,
                fontSize: 18.0)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SmartRefresher(
          controller: _refreshController,
          // onRefresh: _onRefresh,
          // header: WaterDropHeader(),
          child: ListView.builder(
              itemCount: notiLists.length,
              itemBuilder: (context, i) {
                return buildItem(i, notiLists.reversed.toList());
              }),
        ),
      ),
    );
  }
}
