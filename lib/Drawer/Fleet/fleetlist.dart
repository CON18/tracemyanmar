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

  String uu='';
  var d=[];
  var dd=[];
  int index;

  @override
  void initState() {
    super.initState();
    _fetchfleep();
  }

  _fetchfleep() async{
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('UserId');
    String url = "http://52.187.13.89:8080/tracemyanmar/module001/service004/getAllFleepList";
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
      appBar: AppBar(
        title: Text("Fleet List",style: TextStyle(fontWeight: FontWeight.w300),),
        centerTitle: true,
      ),
      body:ListView.builder(
        itemCount: d.length,
        itemBuilder: (context, i){
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("ID: "+d[i]["fleepno"]),
                  subtitle: Text("Phone No: "+d[i]["phoneno"]),
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