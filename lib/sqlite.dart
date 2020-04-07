import 'dart:convert';
import 'package:TraceMyanmar/Drawer/drawer.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/edit_checkin.dart';
import 'package:TraceMyanmar/location/helpers/singleMkr_map.dart';
import 'package:TraceMyanmar/location/pages/home_page.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'employee.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';

class Sqlite extends StatefulWidget {
  final String value;

  Sqlite({Key key, this.value}) : super(key: key);
  @override
  _SqliteState createState() => _SqliteState();
}

class _SqliteState extends State<Sqlite> {
  SlidableController slidableController = SlidableController();

  Future<List<Employee>> employees;
  TextEditingController controller = TextEditingController();
  String name, id, location, righttime, rid;
  int curUserId;
  String deviceId = "";
  String alertmsg = "";
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  String _locationMessage = "";
  String lat = "";
  String long = "";
  String latt = "";
  String longg = "";
  String formattedDate;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  DateTime current;
  String _scanBarcode = "";
  var scanresult;
  String result;
  String color;
  String checklang = '';
  String remark = "";

  // bool _isLoading = true;

  List textMyan = [
    "GPS Check In",
    "QR Check In",
    "အချက်အလက်များ​ပေးပို့ခြင်း",
    "ဗားရှင်း 1.0.13"
  ];
  List textEng = ["GPS Check In", "QR Check In", "Submit", "Version 1.0.12"];
  final String url =
      "https://play.google.com/store/apps/details?id=com.mit.TraceMyanmar2020&hl=en";

  checkLanguage() async {
    // final prefs = await SharedPreferences.getInstance();
    // checklang = prefs.getString("Lang");
    // if (checklang == "" || checklang == null || checklang.length == 0) {
    //   checklang = "Eng";
    // } else {
    //   checklang = checklang;
    // }
    checklang = "Myanmar";
    setState(() {});
  }

  _openURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future scanBarcodeNormal() async {
    String barcodeScanRes = "";
    try {
      barcodeScanRes = await scanner.scan();
      if (barcodeScanRes != null) {
        if (barcodeScanRes.substring(0, 1) == "{") {
          print(barcodeScanRes);
          // var route = new MaterialPageRoute(
          //     builder: (BuildContext context) =>
          //         new Sqlite());
          // Navigator.of(context).push(route);
          scanresult = jsonDecode(barcodeScanRes);
          result = scanresult["rid"];
          rid = result;

          remark = scanresult["remark"];
          // print("RMK >> " + remark.toString());
          validate();
          setState(() {});
        } else {
          print("haha");
        }
      } else {
        scanBarcodeNormal();
      }
      setState(() {
        _scanBarcode = barcodeScanRes;
        print(_scanBarcode);
        alertmsg = _scanBarcode;
        // this._method1();
      });
      // } on PlatformException catch(ex){
      //   if(ex.code == BarcodeScanner.CameraAccessDenied){
      //     setState(() {
      //       alertmsg = "The permission was denied.";
      //     });
      //   }else{
      //     setState(() {
      //       alertmsg = "unknown error ocurred $ex";
      //     });
      //   }
    } on FormatException {
      setState(() {
        alertmsg = "Scan canceled, try again !";
        print(alertmsg);
      });
    } catch (e) {
      alertmsg = "Unknown error $e";
    }
    print(barcodeScanRes);
    // this._method1();
  }

  void _onItemTapped(int index) {
    setState(() {
      // _selectedIndex = index;
    });
  }

  Future<bool> popped() {
    DateTime now = DateTime.now();
    if (current == null || now.difference(current) > Duration(seconds: 2)) {
      current = now;
      Fluttertoast.showToast(
        msg: "Press back Again To exit !",
        toastLength: Toast.LENGTH_SHORT,
      );
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
    _getDeviceId();
    gettime();
    _getLastLatLong();
    _getCurrentLocation();
    setState(() {});
  }

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  snackbarmethod1(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      // content: new Text("Please wait, searching your location"),
      content: new Text(name),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 3),
    ));
  }

  _getLastLatLong() async {
    var lLat;
    var lLong;

    var allLists = await dbHelper.getEmployees();
    // print("L-leng 11 >> " + allLists.toString());
    // print("L-leng >> " + allLists.length.toString());
    if (allLists.length != 0) {
      for (final list in allLists) {
        var index = list.location.toString().indexOf(',');
        lLat = list.location.toString().substring(0, index);
        lLong = list.location.toString().substring(index + 1);
      }
      print("Last lat/long >> " + lLat.toString() + lLong.toString());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("last-lat", lLat);
      prefs.setString("last-long", lLong);
    }
  }

  _getCurrentLocation() async {
    initState() {}
    //Get last check in location

    setState(() {});
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // final Geolocator geolocator = Geolocator()
    //   ..forceAndroidLocationManager = true;
    // var position = await geolocator.getLastKnownPosition(
    //     desiredAccuracy: LocationAccuracy.best);
    print("location >>> $location");
    location = "${position.latitude}, ${position.longitude}";
    latt = "${position.latitude}";
    longg = "${position.longitude}";

    setState(() {});
    print(_locationMessage);
    print(formattedDate);
  }

  getCardno() async {
    var setList = [];
    setList = await dbHelper.getEmployees();
    setState(() {});
    var data = [];
    for (var i = 0; i < setList.length; i++) {
      var index = setList[i].location.toString().indexOf(',');
      data.add({
        "phoneNo": "${widget.value}",
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
        _scaffoldkey.currentState.showSnackBar(new SnackBar(
          content: new Text("Submitted Successfully!"),
          backgroundColor: Colors.blue.shade400,
          duration: Duration(seconds: 1),
        ));
      } else {
        this.alertmsg = result['msgDesc'];
        this.snackbarmethod();
      }
    });
  }

  gettime() async {
    var now = new DateTime.now();
    print(now);
    setState(() {});
  }

  _getDeviceId() async {
    String device_id = await DeviceId.getID;
    deviceId = device_id;
    print(deviceId);
  }

  refreshList() {
    setState(() {});
    dbHelper = DBHelper();
    isUpdating = false;
    _getDeviceId();
    gettime();
    _getCurrentLocation();
    setState(() {
      employees = dbHelper.getEmployees();
      // Future.delayed(const Duration(seconds: 2), () {
      //   _isLoading = false;
      // });
    });
  }

  clearName() {
    controller.text = '';
    setState(() {});
  }

  validate() {
    print("CurUserId >>" + remark.toString());
    setState(() {});
    if (location == null) {
      this.snackbarmethod1("Location not accessible.");
    } else if (formKey.currentState.validate()) {
      setState(() {
        DateTime now = DateTime.now();
        formattedDate = new DateFormat.yMd().add_jm().format(now);
        righttime = formattedDate;
        //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
      });
      formKey.currentState.save();
      if (isUpdating) {
        print("11111111");
        // if (location == null) {
        // Employee e =
        //     Employee(curUserId, "L, L", righttime, rid, color, remark);
        // dbHelper.update(e);

        // } else {
        Employee e =
            Employee(curUserId, location, righttime, rid, color, remark);
        dbHelper.update(e);
        // }

        setState(() {
          isUpdating = false;
        });
      } else {
        print("2222");
        // if (location == null) {
        //   Employee e = Employee(curUserId, "L, L", righttime, rid, color, "");
        //   dbHelper.save(e);
        // } else {
        Employee e = Employee(curUserId, location, righttime, rid, color, "");
        dbHelper.save(e);
        // }

        // color = "1";
        // this.alertmsg = "Check In Successfully!";
        // this.snackbarmethod();
        _getLastLatLong();
        setState(() {});
      }
      clearName();
      refreshList();
      setState(() {
        rid = "Checked In";
      });
    }
  }

  //-->> Old
  // form() {
  //   return Form(
  //     key: formKey,
  //     child: Padding(
  //       padding: EdgeInsets.all(15.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           // TextFormField(
  //           //   controller: controller,
  //           //   keyboardType: TextInputType.text,
  //           //   decoration: InputDecoration(labelText: 'Name'),
  //           //   validator: (val) => val.length == 0 ? 'Enter Name' : null,
  //           //   onSaved: (val) => name = val,
  //           // ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               RaisedButton(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(5.0),
  //                 ),
  //                 color: Colors.blue,
  //                 onPressed: () async {
  //                   _getCurrentLocation();
  //                   validate();
  //                   setState(() {});
  //                 },
  //                 child: Text(
  //                   isUpdating ? 'UPDATE' : 'Check In',
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.w300),
  //                 ),
  //               ),
  //               FlatButton(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(5.0),
  //                 ),
  //                 color: Colors.blue,
  //                 onPressed: () {
  //                   setState(() {
  //                     scanBarcodeNormal();
  //                   });
  //                 },
  //                 child: Text(
  //                   'Scan QR',
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.w300),
  //                 ),
  //               ),
  //               // GestureDetector(
  //               //   onTap: () {
  //               //     setState(() {
  //               //       scanBarcodeNormal();
  //               //     });
  //               //   },
  //               //   child: Image.asset(
  //               //     "assets/scan.png",
  //               //     width: 40.0,
  //               //     height: 40.0,
  //               //     color: Colors.blue,
  //               //   ),
  //               // )
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 13.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            _getCurrentLocation();
                            validate();
                            setState(() {});
                          },
                          child: Text(
                            isUpdating
                                ? 'UPDATE'
                                : checklang == "Eng" ? textEng[0] : textMyan[0],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   width: 20.0,
                // ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.47,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 13.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          scanBarcodeNormal();
                        });
                      },
                      child: Text(
                        checklang == "Eng" ? textEng[1] : textMyan[1],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       scanBarcodeNormal();
                //     });
                //   },
                //   child: Image.asset(
                //     "assets/scan.png",
                //     width: 40.0,
                //     height: 40.0,
                //     color: Colors.blue,
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  //--->> Old
  // SingleChildScrollView dataTable(List<Employee> employees) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: DataTable(
  //       columnSpacing: 65,
  //       dataRowHeight: 90,
  //       headingRowHeight: 0,
  //       sortAscending: true,
  //       columns: [
  //         DataColumn(
  //             label: Text(
  //           '',
  //           style: TextStyle(color: Colors.black87, fontSize: 14),
  //         )),
  //         // DataColumn(
  //         //   label: Text('Device ID')
  //         // ),

  //         // DataColumn(
  //         //   label: Text(
  //         //     'Location',
  //         //     style: TextStyle(color: Colors.black87, fontSize: 14),
  //         //   ),
  //         // ),
  //         // DataColumn(
  //         //   label: Text(
  //         //     'Time',
  //         //     style: TextStyle(color: Colors.black87, fontSize: 14),
  //         //   ),
  //         // ),
  //         DataColumn(
  //           label: Text(
  //             '',
  //             style: TextStyle(color: Colors.black87, fontSize: 14),
  //           ),
  //         ),
  //         DataColumn(
  //           label: Text(
  //             '',
  //             style: TextStyle(color: Colors.black87, fontSize: 14),
  //           ),
  //         ),
  //       ],
  //       rows: employees
  //           .map(
  //             (employee) => DataRow(cells: [
  //               DataCell(
  //                   Icon(Icons.location_on,
  //                       size: 30, color: Colors.green.shade400), onTap: () {
  //                 Navigator.push(context,
  //                     MaterialPageRoute(builder: (context) => HomePage()));
  //               }
  //                   // Text(employee.location.toString(),
  //                   //     style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15)
  //                   //     // ,style: employee.color=="1"? TextStyle(fontWeight: FontWeight.w400,color: Colors.red) :TextStyle(fontWeight: FontWeight.w400,color: Colors.amber)
  //                   //     ),
  //                   ),
  //               // DataCell(
  //               //   Text(deviceId),
  //               // ),
  //               // DataCell(
  //               //   Text(employee.location.toString(),
  //               //       style: TextStyle(fontWeight: FontWeight.w400)
  //               //       // ,style: employee.color=="1"? TextStyle(fontWeight: FontWeight.w400,color: Colors.red) :TextStyle(fontWeight: FontWeight.w400,color: Colors.amber)
  //               //       ),
  //               // ),
  //               // DataCell(
  //               //   Text(employee.name), onTap: (){
  //               //     setState(() {
  //               //       isUpdating = true;
  //               //       curUserId = employee.id;
  //               //     });
  //               //     controller.text = employee.name;
  //               //   }
  //               // ),
  //               // DataCell(Text(employee.time.toString(),
  //               //     style: TextStyle(fontWeight: FontWeight.w400))),
  //               DataCell(Container(
  //                   width: 150,
  //                   child: Text(
  //                     employee.rid.toString() == "null"
  //                         ? "Checked In"
  //                         : employee.rid.toString() +
  //                             '\n' +
  //                             employee.time.toString(),
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
  //                   ))),
  //               // overflow: TextOverflow.ellipsis
  //               DataCell(IconButton(
  //                   icon: Icon(
  //                     Icons.delete,
  //                     color: Colors.red.shade300,
  //                   ),
  //                   onPressed: () {
  //                     dbHelper.delete(employee.id);
  //                     refreshList();
  //                   })),
  //             ]),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }

  Widget buildItem(int i, employees) {
    return Column(
      children: <Widget>[
        Container(
          child: Slidable(
            key: Key(employees[i].id.toString()),
            controller: slidableController,
            actionPane: SlidableScrollActionPane(),
            // SlidableStrechActionPane
            // SlidableDrawerActionPane
            // SlidableScrollActionPane
            // SlidableBehindActionPane
            // actionExtentRatio: 0.25,
            actionExtentRatio: 0.17,
            child: Container(
              color: Colors.white,
              child: new ListTile(
                onTap: () async {
                  print("Edit >> " + employees[i].remark.toString());
                  // curUserId, location, righttime, rid, color, remark
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditCheckIn(
                                id: employees[i].id.toString(),
                                location: employees[i].location.toString(),
                                time: employees[i].time.toString(),
                                ride: employees[i].rid.toString(),
                                remark: employees[i].remark.toString(),
                              )));
                  // print("res>>" + res.toString());
                  if (res == "success") {
                    refreshList();
                  }
                },
                leading: GestureDetector(
                  onTap: () {
                    // print("AAA");
                    // print(
                    //     "LIST >> " + employees[i].location.toString());
                    if (employees[i].location == "L, L") {
                      snackbarmethod1(
                          "Sorry, you're default location. Please, update you check in");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleMarker(
                                    id: employees[i].id.toString(),
                                    location: employees[i].location.toString(),
                                    time: employees[i].time.toString(),
                                    ride: employees[i].rid.toString(),
                                  )));
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => GoogleMapPage()));
                  },
                  child: new Container(
                    child: Icon(Icons.location_on,
                        size: 30,
                        color: employees[i].location == "L, L"
                            ? Colors.grey
                            : Colors.green.shade400),
                    // Icon(Icons.location_on),
                  ),
                ),
                // title: employees[i].rid.toString() == "null"
                //     ? Container()
                //     : employees[i].rid.toString() == "Checked In"
                //         ? Text(
                //             employees[i].location.toString(),
                //             style: TextStyle(
                //               fontFamily: "Pyidaungsu",
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15.0,
                //             ),
                //           )
                //         : Text(
                //             employees[i].rid.toString(),
                //             style: TextStyle(
                //               fontFamily: "Pyidaungsu",
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15.0,
                //             ),
                //           ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    employees[i].rid.toString() == "null"
                        ? Text(
                            employees[i].location.toString(),
                            style: TextStyle(
                              fontFamily: "Pyidaungsu",
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          )
                        : employees[i].rid.toString() == "Checked In"
                            ? Text(
                                employees[i].location.toString(),
                                style: TextStyle(
                                  fontFamily: "Pyidaungsu",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              )
                            : Text(
                                employees[i].rid.toString(),
                                style: TextStyle(
                                  fontFamily: "Pyidaungsu",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                    // employees[i].rid.toString() == "Checked In"
                    //     ? Container()
                    //     : Row(
                    //         children: <Widget>[
                    //           Text(
                    //             employees[i].location.toString(),
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //               fontFamily: "Pyidaungsu",
                    //               // fontWeight: FontWeight.bold,
                    //               fontSize: 15.0,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          employees[i].time.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    (employees[i].remark == "" || employees[i].remark == null)
                        ? Container()
                        : Row(
                            children: <Widget>[
                              Text(
                                employees[i].remark.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 5.0,
                    ),
                    // employees[i].rid.toString() == "null"
                    //     ? Container()
                    //     : Text(
                    //         // employees[i].time,
                    //         employees[i].time.toString(),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    // SizedBox(width: 5,),
                  ],
                ),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                // caption: 'Delete',
                iconWidget: Container(
                  // color: Colors.cusRed,
                  padding: EdgeInsets.all(8.0),

                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    color: Colors.redAccent,
                    borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: new Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                color: Colors.white,
                // icon: Icons.delete,
                onTap: () {
                  // print("Delete>>" + employees[i].id.toString());
                  dbHelper.delete(employees[i].id);
                  refreshList();
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  dataTable(List<Employee> employees) {
    if (employees.length == 0) {
      return Center(
          child: Container(
              child: Text(
        "No Data Found",
        style: TextStyle(
            color: Colors.black26, fontSize: 18.0, fontWeight: FontWeight.bold),
      )));
    } else {
      return ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, i) {
            return buildItem(i, employees.reversed.toList());
          });
    }
    // return Container(
    //   child: Text(employees[i].rid.toString()),
    // );
    // });
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // _isLoading = false;
            return dataTable(snapshot.data);
          }
          // print("EMP >> $employees");
          // if (employees == null || employees == []) {
          //   return Center(child: Text("No Data Found"));
          // } else {
          //   return Container(
          //     child: Text("dflkj"),
          //   );
          // }
          if (snapshot.data == null || snapshot.data.length == 0) {
            // return Center(child: Text("No Data Found"));
            return Container();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => popped(),
        child: Scaffold(
          key: _scaffoldkey,
          drawer: Drawerr(),
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text(
              'TraceMyanmar',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
            ),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            checklang == "Eng" ? textEng[2] : textMyan[2],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Text(
                            " (Submit)",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      )),
                  PopupMenuItem(
                    value: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(checklang == "Eng" ? textEng[3] : textMyan[3],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        Text(" (Version)",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      ],
                    ),
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
                      isUpdating = false;
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
          body:
              // _isLoading
              //     ? Container()
              Container(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                // form(),
                Container(),
                list(),
              ],
            ),
          ),
          persistentFooterButtons: <Widget>[form()],
        ));
  }
}
