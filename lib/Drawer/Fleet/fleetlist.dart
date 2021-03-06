import 'dart:async';

import 'package:TraceMyanmar/db_helper.dart';
import 'package:TraceMyanmar/employee.dart';
import 'package:TraceMyanmar/startInterval.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'fleetdetail.dart';

class FleetList extends StatefulWidget {
  @override
  _FleetListState createState() => _FleetListState();
}

class _FleetListState extends State<FleetList> {
final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String uu='';
  var d=[];
  var dd=[];
  int index;
  String checklang = '';
  List textMyan = ["မှတ်​စု စာရင်းများ (Fleet List)","ဖုန်းနံပါတ် (Phone No)"];
  List textEng = ["Fleet List","Phone No:"];

    var _start;
  Timer timer;
  var dbHelper;

  
  @override
  void initState() {
    super.initState();
    checkLanguage();
    _fetchfleep();

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
  void dispose() {
    timer.cancel();
    // timer1.cancel();
    super.dispose();
  }

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
  _fetchfleep() async{
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('UserId');
    String url = "https://service.mcf.org.mm/tracemyanmar/module001/service004/getAllFleepList";
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    String json = '{ "phneno": "' + uu + '"}';
    print(json);
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body.toString());
      // print(data);
      if (data['msgCode'] == "0000") {
        setState(() {
          d = data['data'];
        });
      }
      // print(d);
      // print(d.length);
      // print(d[0]["phoneno"]);
      // for(var i=0;i<d.length;i++){
      //   index=d[i]["fleepno"].toString().indexOf("|");
      //   if(index==-1){
      //     dd=d[i]["fleepno"];
      //   }else{
      //     dd=d[i]["fleepno"].substring(0,index);
      //   }
      // }
      // print(dd);
    } else {
      print("Connection Fail");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(checklang=="Eng" ? textEng[0] : textMyan[0],style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18),),
        centerTitle: true,
      ),
      body:ListView.builder(
        itemCount: d.length,
        itemBuilder: (context, i){
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("ID: "+d[i]["fleepno"],style: TextStyle(fontWeight: FontWeight.w400),),
                  subtitle: Text(checklang=="Eng" ? textEng[1] : textMyan[1]+d[i]["phoneno"],style: TextStyle(fontWeight: FontWeight.w300),),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FleetDetail(
                        phoneno: d[i]["phoneno"],
                        fleepno: d[i]["fleepno"],
                        depaturedatetime: d[i]["depaturedatetime"],
                        fromLocation: d[i]["fromLocation"],
                        arrivaldatetime: d[i]["arrivaldatetime"],
                        tolocation: d[i]["tolocation"],
                        remark: d[i]["remark"],
                      )));
                      },
                ),
                Divider(thickness: 1,),
              ],
            ),
          );
        },
      ),
    );
  }
}