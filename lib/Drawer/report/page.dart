import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'report.dart';

class PageNew extends StatefulWidget {
  @override
  _PageNewState createState() => _PageNewState();
}

class _PageNewState extends State<PageNew> {

  Map<String, bool> values = {
    'Apple': false,
    'Banana': false,
    'Cherry': false,
    'Mango': false,
    'Orange': false,
  };
 
  var tmpArray = [];
  String checklang = '';
  List textMyan = ["နောက်သို့","Report"];
  List textEng = ["Next","Report"];
 
  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }
  getCheckboxItems(){
 
    values.forEach((key, value) {
      if(value == true)
      {
        tmpArray.add(key); 
      }
  });
 
  // Printing all selected items on Terminal screen.
  print(tmpArray);
  // Here you will get all your selected Checkbox items.
 
  // Clear array after use.
  tmpArray.clear();
}
 bool v = false;
List<bool> isChecking = new List<bool>();
  List<String> ll=[
    'ချောင်းဆိုးလျှင်',
    ' ချမ်း/တုန်',
    '၀မ်းပျက်/၀မ်းလျှော',
    'လည်ချောင်းနာလျှင်',
    'ကိုယ်လက်ကိုက်ခဲလျှင်',
    'ခေါင်းကိုက်လျှင်',
    'အဖျား ၁၀၀ နှင့်အထက်ရှိလျှင်',
    'အသက်ရှူမ၀/မော လျှင်',
    'နှုံးချိအားမရှိ ဖြစ်လျှင်',
    'လွန်ခဲ့သော၁၄ရက်အတွင်းခရီးသွားခဲ့လျှင်',
    "Covid -19 ကူးစက်သောနေရာများသို့\nခရီးသွားဖူးလျှင်",
    "Covid -19 ကူးစက်လူနာနှင့်\nထိတွေ့ဖူးလျှင် စောက်ရှောက်ဖူးလျှင်",
  ];
  List<bool> l=[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> m=[
    '၁',
    '၁',
    '၁',
    '၁',
    '၁',
    '၁',
    '၁',
    '၂',
    '၂',
    '၃',
    '၃',
    '၃',
  ];
  List<int> mm=[
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    2,
    2,
    3,
    3,
    3,
  ];
  List<String> n=[
    "၁။ ",
    "၂။ ",
    "၃။ ",
    "၄။ ",
    "၅။ ",
    "၆။ ",
    "၇။ ",
    "၈။ ",
    "၉။ ",
    "၁၀။ ",
    "၁၁။ ",
    "၁၂။ ",
  ];

  @override
  void initState() {
    super.initState();
    checkLanguage();
    for (var i = 0; i < l.length; i++) {
        isChecking.add(false);
      }
  }


  int total=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          checklang=="Eng" ? textEng[1] :textMyan[1],
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            // new TextField(
            //   controller: eCtrl,
            //   onSubmitted: (text) {
            //     litems.add(text);
            //     eCtrl.clear();
            //     setState(() {});
            //   },
            // ),
            new Container(
              child:Row(
                children: <Widget>[
                Text("ရောဂါလက္ခဏာနှင့်သွားလာမူများ",style: TextStyle(fontWeight: FontWeight.bold),),
                Spacer(),
                Text("",style: TextStyle(fontWeight: FontWeight.bold),),
                Text(" အမှတ်",style: TextStyle(fontWeight: FontWeight.bold),),
              ],)
            ),
            SizedBox(
              height: 7,
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:0.0,right: 10.0),
                child: new ListView.builder
                  (
                    itemCount: ll.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(n[Index]),
                            Text(ll[Index]),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                              child: Checkbox(
                                value: isChecking[Index],
                                onChanged: (bool value) {
                                    setState(() {
                                        isChecking[Index] = value;
                                        if(isChecking[Index]==true){
                                          total +=mm[Index];
                                        }
                                        else{
                                          total-=mm[Index];
                                        }
                                        print(total);
                                    });
                                },
                              ),
                            ),
                            Text(" "+m[Index]),
                          ],
                        );
                    }
                ),
              )
          ),
          // new Container(
          //   child: ,
          // )
          ],
          
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              height: 40.0,
              child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
                child: Text(checklang=="Eng" ? textEng[0]: textMyan[0],style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                onPressed: () {
                  var route = new MaterialPageRoute(builder: (BuildContextcontext) =>new Reposting(value:total));
                  Navigator.of(context).push(route);
                },
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}