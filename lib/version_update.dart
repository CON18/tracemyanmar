import 'package:TraceMyanmar/version_history.dart';
import 'package:flutter/material.dart';

class VersionUpdate extends StatefulWidget {
  @override
  _VersionUpdateState createState() => _VersionUpdateState();
}

class _VersionUpdateState extends State<VersionUpdate> {
  bool isLoading = true;
  var versionNo = "1.1.15";

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue,
        title: new Container(
          child: new Text(
            "Version Update",
            // 'စီစစ်ခြင်း (Verify)',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.cyan,
                    strokeWidth: 3,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Checking for update...")
                ],
              ),
            ),
            Card(
              color: Colors.lightBlue,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: Column(
                      children: <Widget>[
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.10,
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(Icons.arrow_downward,
                                  color: Colors.white),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "New Version Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Version $versionNo is now available.",
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 16.0),
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //   width: MediaQuery.of(context).size.width * 0.10,
                            //   padding: EdgeInsets.only(left: 5),
                            //   child: Icon(Icons.remove_circle,
                            //       color: Colors.white),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 13.0),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  color: Colors.blue[200],
                                  onPressed: () async {
                                    // _getCurrentLocation();
                                    setState(() {
                                      // _openNewVersionURL(
                                      //     "https://sawsawshar.gov.mm/");
                                    });
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   width: MediaQuery.of(context).size.width *
                            //       0.40,
                            //   child: Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 10.0, right: 13.0),
                            //     child: RaisedButton(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius:
                            //             BorderRadius.circular(5.0),
                            //       ),
                            //       color: Colors.blue[200],
                            //       onPressed: () async {
                            //         // _getCurrentLocation();
                            //         setState(() {
                            //           checkNewVersion = false;
                            //         });
                            //       },
                            //       child: Text(
                            //         'Cancel',
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Version " + version,
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Your app is up to date.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
