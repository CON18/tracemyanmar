import 'package:flutter/material.dart';
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
          "Covid 19 Checklist",
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
                            Checkbox(
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
              height: 50.0,
              child: RaisedButton(
                child: Text("Next",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 19),),
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