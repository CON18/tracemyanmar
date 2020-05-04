import 'package:TraceMyanmar/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// final webViewKey = GlobalKey<WebViewContainerState>();

class WebviewInfo extends StatefulWidget {
  @override
  _WebviewInfoState createState() => _WebviewInfoState();
}

class _WebviewInfoState extends State<WebviewInfo> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _key = UniqueKey();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isLoading = true;
  bool onError = false;

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

  _refresh() async {
    // webViewKey.currentState?.reloadWebView();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TabsPage(
            openTab: 1,
          ),
        ));
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
    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        key: _scaffoldkey,
        // body: WebViewContainer(key: webViewKey),
        body: Column(
          children: [
            isLoading
                ? Center(
                    child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator()))
                : Container(),
            onError
                ? Center(
                    child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 100.0),
                          child: Text(
                            "No Connection!",
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Column(
                      //       children: <Widget>[
                      //         Container(
                      //           // width: MediaQuery.of(context).size.width * 0.47,
                      //           width: 200,
                      //           child: Padding(
                      //             padding:
                      //                 EdgeInsets.only(left: 10.0, right: 13.0),
                      //             child: RaisedButton.icon(
                      //               onPressed: () async {
                      //                 // _getCurrentLocation();
                      //                 _refresh();
                      //               },
                      //               icon: Icon(
                      //                 Icons.refresh,
                      //                 // size: 40,
                      //                 color: Colors.white,
                      //               ),
                      //               color: Colors.blue,
                      //               label: Text(
                      //                 "Refresh",
                      //                 style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.w300),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     // SizedBox(
                      //     //   width: 20.0,
                      //     // ),

                      //     Container(
                      //       // width: MediaQuery.of(context).size.width * 0.47,
                      //       width: 200,
                      //       child: Padding(
                      //         padding: EdgeInsets.only(left: 10.0, right: 13.0),
                      //         child: RaisedButton.icon(
                      //           onPressed: () async {
                      //             // _getCurrentLocation();
                      //             showAlertDialog(context);
                      //           },
                      //           icon: Icon(
                      //             Icons.headset_mic,
                      //             // size: 40,
                      //             color: Colors.white,
                      //           ),
                      //           color: Colors.blue,
                      //           label: Text(
                      //             "Call Center 2019",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w300),
                      //           ),
                      //         ),
                      //       ),
                      //     ),

                      //     // GestureDetector(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       scanBarcodeNormal();
                      //     //     });
                      //     //   },
                      //     //   child: Image.asset(
                      //     //     "assets/scan.png",
                      //     //     width: 40.0,
                      //     //     height: 40.0,
                      //     //     color: Colors.blue,
                      //     //   ),
                      //     // )
                      //   ],
                      // ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh,
                            size: 40,
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            print("REFRESH >>");
                            _refresh();
                          },
                        ),
                      )
                    ],
                  ))
                : Container(),
            onError
                ? Container()
                : Expanded(
                    // child: SmartRefresher(
                    //   controller: _refreshController,
                    //   onRefresh: _refresh(),
                    // header: WaterDropHeader(),

                    child: Container()
                    // // // WebView(
                    // // //   navigationDelegate: (NavigationRequest request) {
                    // // //     if (request.url.contains("tel:")) {
                    // // //       setState(() {
                    // // //         // isLoading = false;
                    // // //         // onError = true;
                    // // //         showAlertDialog(context);
                    // // //       });
                    // // //     }
                    // // //   },
                    // // //   onWebViewCreated: (controller) {
                    // // //     // _webViewController = controller;
                    // // //   },
                    // // //   key: _key,
                    // // //   javascriptMode: JavascriptMode.unrestricted,
                    // // //   onWebResourceError: (err) {
                    // // //     setState(() {
                    // // //       onError = true;
                    // // //     });
                    // // //   },
                    // // //   onPageFinished: (result) {
                    // // //     setState(() {
                    // // //       isLoading = false;
                    // // //     });
                    // // //     print("RESULT >>> " + result.toString());
                    // // //   },
                    // // //   initialUrl: 'https://www.mohs.gov.mm/',
                    // // // ),
                    // ),
                    // WebViewContainer(key: webViewKey),
                    //  WebView(
                    //     key: _key,
                    //     javascriptMode: JavascriptMode.unrestricted,
                    //     onWebResourceError: (err) {
                    //       // print("Error");
                    //       setState(() {
                    //         onError = true;
                    //       });
                    //     },
                    //     onPageFinished: (result) {
                    //       setState(() {
                    //         isLoading = false;
                    //       });
                    //       print("RESULT >>> " + result.toString());
                    //     },
                    // initialUrl: 'https://www.mohs.gov.mm/'),
                    // ),
                    ),
          ],
        ),
      ),
    );
  }
}

// class WebViewContainer extends StatefulWidget {
//   WebViewContainer({Key key}) : super(key: key);

//   @override
//   WebViewContainerState createState() => WebViewContainerState();
// }

// class WebViewContainerState extends State<WebViewContainer> {
//   WebViewController _webViewController;
//   final _key = UniqueKey();

//   bool isLoading = true;
//   bool onError = false;
//   _refresh() async {
//     webViewKey.currentState?.reloadWebView();
//   }

//   void reloadWebView() {
//     _webViewController?.reload();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         isLoading
//             ? Center(
//                 child: Container(
//                     padding: EdgeInsets.all(20.0),
//                     child: CircularProgressIndicator()))
//             : Container(),
//         onError
//             ? Center(
//                 child: Column(
//                 children: <Widget>[
//                   Container(
//                       padding: EdgeInsets.only(top: 100.0),
//                       child: Text(
//                         "No Connection!",
//                         style: TextStyle(
//                             color: Colors.black26,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold),
//                       )),
//                       SizedBox(height: 20,),
//                   Container(
//                     child: IconButton(
//                       icon: Icon(Icons.refresh, size: 40,),
//                       color: Colors.blue,
//                       onPressed: () {
//                         print("REFRESH >>");
//                         _refresh();
//                       },
//                     ),
//                   )
//                 ],
//               ))
//             : Container(),
//         onError
//             ? Container()
//             : Expanded(
//                 child: WebView(
//                   onWebViewCreated: (controller) {
//                     _webViewController = controller;
//                   },
//                   key: _key,
//                   javascriptMode: JavascriptMode.unrestricted,
//                   onWebResourceError: (err) {
//                     setState(() {
//                       onError = true;
//                     });
//                   },
//                   onPageFinished: (result) {
//                     setState(() {
//                       isLoading = false;
//                     });
//                     print("RESULT >>> " + result.toString());
//                   },
//                   initialUrl: 'https://www.mohs.gov.mm/',
//                 ),
//                 // WebViewContainer(key: webViewKey),
//                 //  WebView(
//                 //     key: _key,
//                 //     javascriptMode: JavascriptMode.unrestricted,
//                 //     onWebResourceError: (err) {
//                 //       // print("Error");
//                 //       setState(() {
//                 //         onError = true;
//                 //       });
//                 //     },
//                 //     onPageFinished: (result) {
//                 //       setState(() {
//                 //         isLoading = false;
//                 //       });
//                 //       print("RESULT >>> " + result.toString());
//                 //     },
//                 // initialUrl: 'https://www.mohs.gov.mm/'),
//               )
//       ],
//     );
//   }
// }
