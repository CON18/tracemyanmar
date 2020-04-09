import 'package:TraceMyanmar/Drawer/report/report.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewReport extends StatefulWidget {
  @override
  _NewReportState createState() => _NewReportState();
}

class _NewReportState extends State<NewReport> {
  List itemLists = [
    {"id": "01", "no": "၁။ ", "title": "ချောင်းဆိုးလျှင်", "select": false},
    {"id": "02", "no": "၂။ ", "title": "ချမ်း/တုန်", "select": false},
    {"id": "03", "no": "၃။ ", "title": "၀မ်းပျက်/၀မ်းလျှော", "select": false},
    {"id": "04", "no": "၄။ ", "title": "လည်ချောင်းနာလျှင်", "select": false},
    {"id": "05", "no": "၅။ ", "title": "ကိုယ်လက်ကိုက်ခဲလျှင်", "select": false},
    {"id": "06", "no": "၆။ ", "title": "ခေါင်းကိုက်လျှင်", "select": false},
    {
      "id": "07",
      "no": "၇။ ",
      "title": "အဖျား ၁၀၀ နှင့်အထက်ရှိလျှင်",
      "select": false
    },
    {"id": "08", "no": "၈။ ", "title": "အသက်ရှူမ၀/မော လျှင်", "select": false},
    {
      "id": "09",
      "no": "၉။ ",
      "title": "နှုံးချိအားမရှိ ဖြစ်လျှင်",
      "select": false
    },
    {
      "id": "10",
      "no": "၁၀။ ",
      "title": "လွန်ခဲ့သော၁၄ရက်အတွင်းခရီးသွားခဲ့လျှင်",
      "select": false
    },
    {
      "id": "11",
      "no": "၁၁။ ",
      "title": "ရောဂါပိုး ကူးစက်သောနေရာများသို့\nခရီးသွားဖူးလျှင်",
      "select": false
    },
    {
      "id": "12",
      "no": "၁၂။ ",
      "title": "ရောဂါပိုး ကူးစက်လူနာနှင့် ထိတွေ့ဖူးလျှင် စောင့်ရှောက်ဖူးလျှင်",
      "select": false
    }
  ];

  String checklang = '';
  List textMyan = ["ရှေ့သို့ (Next)", "စစ်ဆေးမှု"];
  List textEng = ["Next", "Report"];

  int checkCount = 0;

  @override
  void initState() {
    super.initState();
    checkLanguage();
    // for (var i = 0; i < l.length; i++) {
    //     isChecking.add(false);
    //   }
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

  _selectChange(list) async {
    // print(list["serviceName"]);
    setState(() {
      for (var ii = 0; ii < itemLists.length; ii++) {
        if (itemLists[ii]["id"].toString() == list["id"].toString()) {
          if (list["select"].toString() == "true") {
            itemLists[ii]["select"] = false;
            checkCount = checkCount - 1;
            // chooseLists.removeWhere((item) =>
            //     item["services_syskey"] == list[ii]["services_syskey"]);
          } else {
            itemLists[ii]["select"] = true;
            checkCount = checkCount + 1;
            // chooseLists.add(list);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // checklang == "Eng" ? textEng[1] : textMyan[1],
          "သတင်းပို့ (Report)",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            new Container(
                child: Row(
              children: <Widget>[
                Text(
                  "ရောဂါလက္ခဏာနှင့်သွားလာမူများ",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: checkCount == 0
                      ? Container()
                      : Text(
                          "[ $checkCount ]",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                ),
              ],
            )),
            SizedBox(
              height: 7,
            ),
            Expanded(
              // child: Padding(
              // padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: new ListView.builder(
                  itemCount: itemLists.length,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            _selectChange(itemLists[i]);
                            // itemLists[i]["select"] = value;
                          },
                        );
                      },
                      child: new ListTile(
                        title: new Row(
                          children: <Widget>[
                            new Expanded(
                                child: new Text(itemLists[i]["title"])),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.blueGrey,
                                ),
                                child: new Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.blue,
                                  hoverColor: Colors.pink,
                                  value: itemLists[i]["select"],
                                  onChanged: (bool value) {
                                    _selectChange(itemLists[i]);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

              // ),
            ),
            SizedBox(
              height: 60.0,
            )
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            // print("CL >> " + srLst.toString());
            var route = new MaterialPageRoute(
                builder: (BuildContextcontext) => new Reporting(value: checkCount,));
            Navigator.of(context).push(route);
          },
          tooltip: 'Increment',
          // child: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          child: Icon(Icons.arrow_forward_ios),
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
          elevation: 10.0,
        ),
      ),
      // // persistentFooterButtons: <Widget>[
      // //   Form(
      // //     // key: formKey,
      // //     child: Padding(
      // //       padding: EdgeInsets.all(0.0),
      // //       child: Column(
      // //         mainAxisAlignment: MainAxisAlignment.center,
      // //         mainAxisSize: MainAxisSize.min,
      // //         children: <Widget>[
      // //           Row(
      // //             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // //             children: <Widget>[
      // //               Column(
      // //                 children: <Widget>[
      // //                   Container(
      // //                     width: MediaQuery.of(context).size.width * 0.95,
      // //                     child: Padding(
      // //                       padding: EdgeInsets.only(left: 0.0, right: 0.0),
      // //                       child: RaisedButton(
      // //                         shape: RoundedRectangleBorder(
      // //                           borderRadius: BorderRadius.circular(5.0),
      // //                         ),
      // //                         color: Colors.blue,
      // //                         onPressed: () async {
      // //                           var route = new MaterialPageRoute(
      // //                               builder: (BuildContextcontext) =>
      // //                                   new Reporting(value: checkCount,));
      // //                           Navigator.of(context).push(route);
      // //                         },
      // //                         child: Text(
      // //                           checklang == "Eng" ? textEng[0] : textMyan[0],
      // //                           style: TextStyle(
      // //                               color: Colors.white,
      // //                               fontWeight: FontWeight.w300),
      // //                         ),
      // //                       ),
      // //                     ),
      // //                   ),
      // //                 ],
      // //               ),
      // //             ],
      // //           )
      // //         ],
      // //       ),
      // //     ),
          // child: FloatingActionButton(
          //   backgroundColor: Colors.blue,
          //   onPressed: () {
          //     var route = new MaterialPageRoute(
          //                           builder: (BuildContextcontext) =>
          //                               new Reposting(value: 3,));
          //                       Navigator.of(context).push(route);
          //     // print("CL >> " + srLst.toString());
          //   },
          //   tooltip: 'Increment',
          //   // child: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          //   child: Icon(Icons.arrow_forward_ios),
          //   // shape: RoundedRectangleBorder(
          //   //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
          //   elevation: 10.0,
          // ),
        // )
      // ],
    );
  }
}
