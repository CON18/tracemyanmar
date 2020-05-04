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
  ScrollController _scrollController = ScrollController();

  String lan = '';
  String checkfont = '';
  bool isLoading = false;
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
      "post": 
      // "Topic Body body body 2",
      "Topic Body body body body body \n body body body  body body body \n body body 2",
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
                    'No Messages',
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
                  // onRefresh: _onRefresh,
                  // header: WaterDropHeader(),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: notiLists == null ? 0 : notiLists.length,
                      itemBuilder: (context, i) {
                        return Container(
                          color: Colors.white,
                          child: new ListTile(
                            // title: Text(
                            //   notiLists[i]["topic"],
                            //   style: TextStyle(
                            //     fontFamily: "Pyidaungsu",
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 15.0,
                            //   ),
                            // ),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            "",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: RichText(
                                            text: TextSpan(
                                              // text: notiLists[i]["topic"],
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,

                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: notiLists[i]["topic"],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    )),
                                                    // SizedBox(height: 3,),
                                                TextSpan(
                                                    text: '\n' +
                                                        notiLists[i]["post"],
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                                TextSpan(
                                                    text: '  \n' +
                                                        notiLists[i]["date"] +
                                                        " " +
                                                        notiLists[i]["time"],
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                        )
                                        // Container(
                                        //   padding: EdgeInsets.only(left: 10),
                                        //   child:
                                        //       // Row(
                                        //       //   children: <Widget>[
                                        //       Text(
                                        //     notiLists[i]["topic"],
                                        //     overflow: TextOverflow.visible,
                                        //     style: TextStyle(
                                        //       fontFamily: "Pyidaungsu",
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 16.0,
                                        //     ),
                                        //   ),

                                        //   //   ],
                                        //   // ),
                                        // ),
                                        // Container(
                                        //   padding: EdgeInsets.only(left: 10),
                                        //   child:
                                        //       // Row(
                                        //       //   children: <Widget>[
                                        //       Text(
                                        //     notiLists[i]["post"],
                                        //     overflow: TextOverflow.visible,
                                        //     style: TextStyle(
                                        //         fontFamily: "Pyidaungsu"),
                                        //   ),

                                        //   //   ],
                                        //   // ),
                                        // ),
                                        // Container(
                                        //   padding: EdgeInsets.only(left: 12),
                                        //   child:
                                        //       //  Row(
                                        //       //   mainAxisSize: MainAxisSize.min,
                                        //       // children: [
                                        //       Text(
                                        //     notiLists[i]["date"] +
                                        //         " " +
                                        //         notiLists[i]["time"],
                                        //     overflow: TextOverflow.visible,
                                        //     style: TextStyle(
                                        //         fontFamily: "Pyidaungsu",
                                        //         color: Colors.black45),
                                        //   ),
                                        //   //   ],
                                        //   // ),
                                        // ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.black45, size: 30.0),
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
    );
  }
}
