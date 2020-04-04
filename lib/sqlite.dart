import 'dart:convert';
import 'package:TraceMyanmar/Drawer/drawer.dart';
import 'package:TraceMyanmar/db_helper.dart';
<<<<<<< HEAD
import 'package:TraceMyanmar/location/helpers/google_map.dart';
import 'package:TraceMyanmar/location/pages/home_page.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
=======
import 'package:TraceMyanmar/location/pages/home_page.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'employee.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;

class Sqlite extends StatefulWidget {
  final String value;

  Sqlite({Key key, this.value}) : super(key: key);
  @override
  _SqliteState createState() => _SqliteState();
}

class _SqliteState extends State<Sqlite> {
<<<<<<< HEAD
  SlidableController slidableController = SlidableController();

=======
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
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
  // String checklang = '';
  // List textMyan = ["သိမ်းဆည်းပါ။","QR အဖတ်","အချက်အလက်များတင်ပို့ခြင်း",""];
  // List textEng = ["Check In","Scan QR","Submit","Version 1.0.6"];

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
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
    _getDeviceId();
    gettime();
    _getCurrentLocation();
    setState(() {});
  }

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 1),
    ));
  }

  _getCurrentLocation() async {
    initState() {}
    setState(() {});
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // final Geolocator geolocator = Geolocator()
    //   ..forceAndroidLocationManager = true;
    // var position = await geolocator.getLastKnownPosition(
    //     desiredAccuracy: LocationAccuracy.best);
<<<<<<< HEAD
    print("location >>> $location");
=======
    print("location $location");
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
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
        'http://103.101.18.229:8080/TraceService/module001/service005/saveUser';
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
    });
  }

  clearName() {
    controller.text = '';
    setState(() {});
  }

  validate() {
    setState(() {});
    if (formKey.currentState.validate()) {
      setState(() {
        DateTime now = DateTime.now();
        formattedDate = new DateFormat.MMMMd("en_US").add_jm().format(now);
        righttime = formattedDate;
        //new DateFormat.yMd().add_jm()  DateFormat('hh:mm EEE d MMM') yMMMMd("en_US")
      });
      formKey.currentState.save();
      if (isUpdating) {
        Employee e = Employee(curUserId, location, righttime, rid, color);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Employee e = Employee(curUserId, location, righttime, rid, color);
        dbHelper.save(e);
        // color = "1";
        this.alertmsg = "Check In Successfully!";
        this.snackbarmethod();
        setState(() {});
      }
      clearName();
      refreshList();
      setState(() {
        rid = "Checked In";
      });
    }
  }

<<<<<<< HEAD
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

=======
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
  form() {
    return Form(
      key: formKey,
      child: Padding(
<<<<<<< HEAD
        padding: EdgeInsets.all(0.0),
=======
        padding: EdgeInsets.all(15.0),
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
<<<<<<< HEAD
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
                            isUpdating ? 'UPDATE' : 'Check In',
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
                        'Scan QR',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),

=======
            // TextFormField(
            //   controller: controller,
            //   keyboardType: TextInputType.text,
            //   decoration: InputDecoration(labelText: 'Name'),
            //   validator: (val) => val.length == 0 ? 'Enter Name' : null,
            //   onSaved: (val) => name = val,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
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
                    isUpdating ? 'UPDATE' : 'Check In',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                ),
                FlatButton(
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
                    'Scan QR',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                ),
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
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

<<<<<<< HEAD
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

  ListView dataTable(List<Employee> employees) {
    return ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, i) {
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
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => GoogleMapPage()));
                        },
                        child: new Container(
                          child: Icon(Icons.location_on,
                              size: 30, color: Colors.green.shade400),
                          // Icon(Icons.location_on),
                        ),
                      ),
                      title: Text(
                        // employees[i].rid,
                        employees[i].rid.toString() == "null"
                            ? "Checked In"
                            : employees[i].rid.toString(),
                        // '\n' +
                        // employee.time.toString(),
                        style: TextStyle(
                          fontFamily: "Pyidaungsu",
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          employees[i].rid.toString() == "null"
                              ? Container()
                              : Text(
                                  // employees[i].time,
                                  employees[i].time.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                          borderRadius:
                              new BorderRadius.all(Radius.circular(50.0)),
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
          // return Container(
          //   child: Text(employees[i].rid.toString()),
          // );
        });
=======
  SingleChildScrollView dataTable(List<Employee> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 65,
        dataRowHeight: 90,
        headingRowHeight: 0,
        sortAscending: true,
        columns: [
          DataColumn(
              label: Text(
            '',
            style: TextStyle(color: Colors.black87, fontSize: 14),
          )),
          // DataColumn(
          //   label: Text('Device ID')
          // ),

          // DataColumn(
          //   label: Text(
          //     'Location',
          //     style: TextStyle(color: Colors.black87, fontSize: 14),
          //   ),
          // ),
          // DataColumn(
          //   label: Text(
          //     'Time',
          //     style: TextStyle(color: Colors.black87, fontSize: 14),
          //   ),
          // ),
          DataColumn(
            label: Text(
              '',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
          DataColumn(
            label: Text(
              '',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
        rows: employees
            .map(
              (employee) => DataRow(cells: [
                DataCell(
                    Icon(Icons.location_on,
                        size: 30, color: Colors.green.shade400), onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
                    // Text(employee.location.toString(),
                    //     style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15)
                    //     // ,style: employee.color=="1"? TextStyle(fontWeight: FontWeight.w400,color: Colors.red) :TextStyle(fontWeight: FontWeight.w400,color: Colors.amber)
                    //     ),
                    ),
                // DataCell(
                //   Text(deviceId),
                // ),
                // DataCell(
                //   Text(employee.location.toString(),
                //       style: TextStyle(fontWeight: FontWeight.w400)
                //       // ,style: employee.color=="1"? TextStyle(fontWeight: FontWeight.w400,color: Colors.red) :TextStyle(fontWeight: FontWeight.w400,color: Colors.amber)
                //       ),
                // ),
                // DataCell(
                //   Text(employee.name), onTap: (){
                //     setState(() {
                //       isUpdating = true;
                //       curUserId = employee.id;
                //     });
                //     controller.text = employee.name;
                //   }
                // ),
                // DataCell(Text(employee.time.toString(),
                //     style: TextStyle(fontWeight: FontWeight.w400))),
                DataCell(Container(
                    width: 150,
                    child: Text(
                  employee.rid.toString() == "null"
                      ? "Checked In"
                      : employee.rid.toString() +
                          '\n' +
                          employee.time.toString(),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                ))),
                // overflow: TextOverflow.ellipsis
                DataCell(IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade300,
                    ),
                    onPressed: () {
                      dbHelper.delete(employee.id);
                      refreshList();
                    })),
              ]),
            )
            .toList(),
      ),
    );
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (null == snapshot.data || snapshot.data.leght == 0) {
<<<<<<< HEAD
            return Center(child: Text("No Data Found"));
=======
            return Text("No Data Found");
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
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
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      )),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Version 1.0.6",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
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
                },
                // icon: Icon(Icons.list),
              ),
            ],
          ),
          body: Container(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
<<<<<<< HEAD
                // form(),
=======
                form(),
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
                list(),
              ],
            ),
          ),
<<<<<<< HEAD
          persistentFooterButtons: <Widget>[form()],
=======
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
        ));
  }
}
