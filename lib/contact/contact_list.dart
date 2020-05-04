import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String checkfont = '';
  String lan = '';
  FirebaseAnalytics analytics = FirebaseAnalytics();

  // var aryLists = [
  //   {"no": "1", "title": "",}
  // ]
  List textMyan = [
    "ဆက်သွယ်ရန် (Contact)", //0
    "ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာနမှ", //1
    "ဆက်သွယ်ရမည့် ဖုန်းနံပါတ်များ", //2
    "နေပြည်တော်", //3
    //⚪ ⚫ • "၁၊ ", //4
    "• ", //4
    "ဗဟိုကူးစက်ရောဂါတိုက်ဖျက်ရေးဌာနခွဲ", //5
    "•  ပြည်သူ့ကျန်းမာရေးဦးစီးဌာန", //6
    // "၂၊ ", //7
    "• ", //7
    "Public Health Emergency Operation Center ပြည့်သူ့ကျန်းမာရေးဦးစီးဌာန", //8
    // "၃၊ ", //9
    "• ", //9
    "ဒေါက်တာထွန်းတင် ညွှန်ကြားရေးမှူး၊ ဗဟိုကူးစက်ရောဂါတိုက်ဖက်ရေးဌာနခွဲ ပြည်သူ့ကျန်းမာရေးဦးစီးဌာန", //10
    "၄၊ ", //11
    "ဒေါက်တာမိုးခိုင် ညွှန်ကြားရေးမှူး၊ ကုသရေးဦးစီးဌာန", //12
    "၅၊ ", //13
    "ဒေါက်တာဉာဏ်ဝင်းမြင့် ဒုတိယညွှန်ကြားရေးမှူး၊ ဗဟိုကူးစက်ရောဂါတိုက်ဖျက်ရေးဌာနခွဲ ပြည်သူ့ကျန်းမာရေးဦးစီးဌာန", //14
    "ပြည်ထောင်စုနယ်မြေ၊ နေပြည်တော်", //15
    "၆၊ ", //16
    "ဒေါက်တာမြတ်ဝဏ္ဏစိုး၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် နေပြည်တော်ကောင်စီပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //17
    "၇၊ ", //18
    "ဒေါက်တာမျိုးစုကြည် ဒုတိယတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //19
    "ရန်ကုန်တိုင်းဒေသကြီး", //20
    "၈၊ ", //21
    "ဒေါက်တာထွန်းမြင့် ဒုတိယညွှန်ကြားရေးမှူးချုပ် ရန်ကုန်တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန", //22
    "၉၊ ", //23
    "ဒေါက်တာသက်စုမွန် လက်ထောက်ညွှန်ကြားရေးမှူး ရန်ကုန်တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန", //24
    "မန္တလေးတိုင်းဒေသကြီး", //25
    "၁၀၊ ", //25
    "ဒေါက်တာသန်းသန်းမြင့် ဒုတိယညွှန်ကြားရေးမှူးချုပ် မန္တလေးတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန", //26
    "၁၁၊ ", //27
    "ဒေါက်တာသင်းသင်းနွယ် ဒုတိယတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး မန္တလေးတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန", //28
    "ကချင်ပြည်နယ်", //29
    "၁၂၊ ", //30
    "ဒေါက်တာအေးသိန်း ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //31
    "ကယားပြည်နယ်", //32
    "၁၃၊ ", //33
    "ဒေါက်တာဌေးလွင် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //34
    "ကရင်ပြည်နယ်", //35
    "၁၄၊ ", //36
    "ဒေါက်တာကျော်စွာမြင့် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //37
    "ချင်းပြည်နယ်", //38
    "၁၅၊ ", //39
    "ဒေါက်တာအောင်ငွေစံ ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //40
    "စစ်ကိုင်းတိုင်းဒေသကြီး", //41
    "၁၆၊ ", //42
    "ဒေါက်တာဝင်းလွင် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //43
    "တနင်္သာရီတိုင်းဒေသကြီး", //44
    "၁၇၊ ", //45
    "ဒေါက်တာထွန်းမင်း တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //46
    "ပဲခူးတိုင်းဒေသကြီး", //47
    "၁၈၊ ", //48
    "ဒေါက်တာအေးငြိမ်း၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //49
    "၁၉၊ ", //50
    "ဒေါက်တာအေးအေးငြိမ်း၊ ဒုတိယတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //51
    "မကွေးတိုင်းဒေသကြီး", //52
    "၂၀၊ ", //53
    "ဒေါက်တာသောင်းလှိုင်၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //54
    "မွန်ပြည်နယ်", //55
    "၂၁၊ ", //56
    "ဒေါက်တာထွန်းအောင်ကြည် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //57
    "ရခိုင်ပြည်နယ်", //58
    "၂၂၊ ", //59
    "ဒေါက်တာစိုင်းဝင်းဇော်လှိုင် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //60
    "ရှမ်းပြည်နယ် (တောင်ပိုင်း)", //61
    "၂၃၊ ", //62
    "ဒေါက်တာသူဇာချစ်တင်၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //63
    "ရှမ်းပြည်နယ် (အရှေ့ပိုင်း)", //64
    "၂၄၊ ", //65
    "ဒေါက်တာမြင့်ကျော် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //66
    "ရှမ်းပြည်နယ် (မြောက်ပိုင်း)", //67
    "၂၅၊ ", //68
    "ဒေါက်တာတင်မောင်ညွှန့် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး", //69
    "ဧရာဝတီတိုင်းဒေသကြီး", //70
    "၂၆၊ ", //71
    "ဒေါက်တာသန်းထွန်းအောင်၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး" //72
  ];

  @override
  void initState() {
    super.initState();
    someMethod();
    analyst();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'Contact_Request',
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

  showAlertDialog(BuildContext context, callNo) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        // getCardno();
        setState(() {
          FlutterPhoneState.startPhoneCall(callNo);
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
        "Do you want to call?",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
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

  Widget _text1(weight, int index, size) {
    return Text(
      lan == "Zg" ? Rabbit.uni2zg(textMyan[index]) : textMyan[index],
      overflow: TextOverflow.visible,
      // checklang == "Eng" ? textEng[1] : textMyan[1],
      // "ဆက်သွယ်ရန် (Contact)",
      style: TextStyle(
          fontWeight: weight,
          fontSize: size,
          fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      // appBar: AppBar(
      //   title: _text1(FontWeight.w300, 0, 18.0),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: _text1(FontWeight.bold, 1, 18.0),
                    // Text(
                    //   lan == "Zg" ? Rabbit.uni2zg(textMyan[1]) : textMyan[1],
                    //   // "ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာနမှ",
                    //   overflow: TextOverflow.fade,
                    //   style: TextStyle(
                    //       fontFamily: "Zawgyi",
                    //       fontSize: 18.0,
                    //       fontWeight: FontWeight.bold),
                    // ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: _text1(FontWeight.bold, 2, 18.0),
                    //  Text(
                    //   lan == "Zg" ? Rabbit.uni2zg(textMyan[2]) : textMyan[2],
                    //   // "ဆက်သွယ်ရမည့် ဖုန်းနံပါတ်များ",
                    //   overflow: TextOverflow.fade,
                    //   style: TextStyle(
                    //       fontFamily: "Zawgyi",
                    //       fontSize: 18.0,
                    //       fontWeight: FontWeight.bold),
                    // ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      //subtitle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // _text1(FontWeight.w600, 3, 17.0),
                          Text(
                            lan == "Zg"
                                ? Rabbit.uni2zg("နေပြည်တော်")
                                : "နေပြည်တော်",
                            overflow: TextOverflow.visible,
                            // checklang == "Eng" ? textEng[1] : textMyan[1],
                            // "ဆက်သွယ်ရန် (Contact)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.lightBlue,
                                fontFamily:
                                    lan == "Zg" ? "Zawgyi" : "Pyidaungsu"),
                          ),
                          // Text(
                          //   lan == "Zg" ? Rabbit.uni2zg(textMyan[3]) : textMyan[3],
                          //   // "နေပြည်တော်",
                          //   style: TextStyle(
                          //       fontFamily: "Zawgyi",
                          //       fontSize: 17.0,
                          //       fontWeight: FontWeight.w600),
                          // )
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      // new Container(
                      //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                      //     height: 2.0,
                      //     width: 55.0,
                      //     color: Colors.blue[200]),
                      //   ],
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      // ။
                      //------->>>>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _text1(FontWeight.normal, 4, 17.0),
                          // Text(
                          //   lan == "Zg" ? Rabbit.uni2zg(textMyan[4]) : textMyan[4],
                          //   // "၁၊ ",
                          //   style: TextStyle(
                          //       fontFamily: "Zawgyi",
                          //       fontSize: 17.0,
                          //       fontWeight: FontWeight.normal),
                          // ),
                          new Flexible(
                            child: new Container(
                              padding: new EdgeInsets.only(right: 13.0),
                              child: _text1(FontWeight.normal, 5, 17.0),
                              // new Text(
                              //   lan == "Zg" ? Rabbit.uni2zg(textMyan[5]) : textMyan[5],
                              //   // 'ဗဟိုကူးစက်ရောဂါတိုက်ဖျက်ရေးဌာနခွဲ',
                              //   overflow: TextOverflow.visible,
                              //   style: new TextStyle(
                              //       fontFamily: "Zawgyi",
                              //       fontSize: 17.0,
                              //       fontWeight: FontWeight.normal),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // GestureDetector(
                          //   onTap: () {
                          //     print("Call >> 0923423");
                          //     showAlertDialog(context, "0673431432");
                          //   },
                          //   child: Text(
                          //     "၀၆၇-၃၄၃၁၄၃၂",
                          //     style: TextStyle(
                          //         fontSize: 18.0,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.lightBlue),
                          //   ),
                          // )
                          Chip(
                            labelPadding: EdgeInsets.all(1.0),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.phone,
                                color: Colors.lightBlue,
                                size: 15.0,
                              ),
                            ),
                            label: Text(
                              "  ၀၆၇-၃၄၃၁၄၃၂  ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                            backgroundColor: Colors.lightBlue,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: EdgeInsets.all(6.0),
                            // label: Text(
                            //   "၀၆၇-၃၄၃၁၄၃၂",
                            //   style: TextStyle(color: Colors.lightBlue),
                            // ),

                            // deleteIconColor: Colors.lightBlue,
                            // onDeleted: () {
                            //   setState(() {
                            //     print("RRR");
                            //   });
                            // },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey[500],
                        height: 5,
                      ),
                      //------------<<<<<
                      //------->>>>
                      // new Container(
                      //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                      //     height: 2.0,
                      //     width: 55.0,
                      //     color: Colors.blue[200]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.normal),
                          ),
                          new Flexible(
                            child: new Container(
                              padding: new EdgeInsets.only(right: 13.0),
                              child: _text1(FontWeight.normal, 6, 17.0),
                              //  new Text(
                              //   lan == "Zg" ? Rabbit.uni2zg(textMyan[6]) : textMyan[6],
                              //   // 'ပြည်သူ့ကျန်းမာရေးဦးစီးဌာန',
                              //   overflow: TextOverflow.visible,
                              //   style: new TextStyle(
                              //       fontFamily: "Zawgyi",
                              //       fontSize: 17.0,
                              //       fontWeight: FontWeight.normal),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Chip(
                            labelPadding: EdgeInsets.all(1.0),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.phone,
                                color: Colors.lightBlue,
                                size: 15.0,
                              ),
                            ),
                            label: Text(
                              "  ၀၆၇-၃၄၃၁၄၃၄  ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                            backgroundColor: Colors.lightBlue,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: EdgeInsets.all(6.0),
                          )
                          // label: Text(
                          //   "၀၆၇-၃၄၃၁၄၃၂",
                          //   style: TextStyle(color: Colors.lightBlue),
                          // ),

                          // deleteIconColor: Colors.lightBlue,
                          // onDeleted: () {
                          //   setState(() {
                          //     print("RRR");
                          //   });
                          // },
                          // GestureDetector(
                          //   onTap: () {
                          //     print("Call >> 0923423");
                          //     showAlertDialog(context, "0673431434");
                          //   },
                          //   child: Text(
                          //     "၀၆၇-၃၄၃၁၄၃၄",
                          //     style: TextStyle(
                          //         fontSize: 18.0,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.lightBlue),
                          //   ),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey[500],
                        height: 5,
                      ),
                      // new Container(
                      //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                      //     height: 2.0,
                      //     width: 55.0,
                      //     color: Colors.blue[200]),
                      SizedBox(
                        height: 20,
                      ),

                      //------------<<<<<
                      //------->>>>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _text1(FontWeight.normal, 7, 17.0),
                          // Text(
                          //   lan == "Zg" ? Rabbit.uni2zg(textMyan[7]) : textMyan[7],
                          //   // "၂၊ ",
                          //   style: TextStyle(
                          //       fontFamily: "Zawgyi",
                          //       fontSize: 17.0,
                          //       fontWeight: FontWeight.normal),
                          // ),
                          new Flexible(
                            child: new Container(
                              padding: new EdgeInsets.only(right: 13.0),
                              child: _text1(FontWeight.normal, 8, 17.0),
                              // new Text(
                              //   lan == "Zg" ? Rabbit.uni2zg(textMyan[8]) : textMyan[8],
                              //   // 'Public Health Emergency Operation Center ပြည့်သူ့ကျန်းမာရေးဦးစီးဌာန',
                              //   overflow: TextOverflow.visible,
                              //   style: new TextStyle(
                              //       fontFamily: "Zawgyi",
                              //       fontSize: 17.0,
                              //       fontWeight: FontWeight.normal),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Chip(
                            labelPadding: EdgeInsets.all(1.0),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.phone,
                                color: Colors.lightBlue,
                                size: 15.0,
                              ),
                            ),
                            label: Text(
                              "  ၀၆၇-၃၄၂၀၂၆၈  ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                            backgroundColor: Colors.lightBlue,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: EdgeInsets.all(6.0),
                          )
                          // GestureDetector(
                          //   onTap: () {
                          //     print("Call >> 0923423");
                          //     showAlertDialog(context, "0673420268");
                          //   },
                          //   child: Text(
                          //     "၀၆၇-၃၄၂၀၂၆၈",
                          //     style: TextStyle(
                          //         fontSize: 18.0,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.lightBlue),
                          //   ),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey[500],
                        height: 5,
                      ),
                      // new Container(
                      //     margin: new EdgeInsets.symmetric(vertical: 5.0),
                      //     height: 2.0,
                      //     width: 55.0,
                      //     color: Colors.blue[200]),
                      SizedBox(
                        height: 20,
                      ),
                      //------------<<<<<
                      //------->>>>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _text1(FontWeight.normal, 9, 17.0),
                          // Text(
                          //   lan == "Zg" ? Rabbit.uni2zg(textMyan[9]) : textMyan[9],
                          //   // "၃၊ ",
                          //   style: TextStyle(
                          //       fontFamily: "Zawgyi",
                          //       fontSize: 17.0,
                          //       fontWeight: FontWeight.normal),
                          // ),
                          new Flexible(
                            child: new Container(
                              padding: new EdgeInsets.only(right: 13.0),
                              child: _text1(FontWeight.normal, 10, 17.0),
                              // new Text(
                              //   lan == "Zg"
                              //       ? Rabbit.uni2zg(textMyan[10])
                              //       : textMyan[10],
                              //   // 'ဒေါက်တာထွန်းတင် ညွှန်ကြားရေးမှူး၊ ဗဟိုကူးစက်ရောဂါတိုက်ဖက်ရေးဌာနခွဲ ပြည်သူ့ကျန်းမာရေးဦးစီးဌာန',
                              //   overflow: TextOverflow.visible,
                              //   style: new TextStyle(
                              //       fontFamily: "Zawgyi",
                              //       fontSize: 17.0,
                              //       fontWeight: FontWeight.normal),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              print("Call >> 0923423");
                              showAlertDialog(context, "09429228991");
                            },
                            child: Text(
                              "၀၉-၄၂၉၂၂၈၉၉၁",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                          )
                        ],
                      ),
                      new Container(
                          margin: new EdgeInsets.symmetric(vertical: 5.0),
                          height: 2.0,
                          width: 55.0,
                          color: Colors.blue[200]),
                      SizedBox(
                        height: 20,
                      ),
                      //------------<<<<<//------->>>>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _text1(FontWeight.normal, 11, 17.0),
                          // Text(
                          //   lan == "Zg" ? Rabbit.uni2zg(textMyan[11]) : textMyan[11],
                          //   // "၄၊ ",
                          //   style: TextStyle(
                          //       fontFamily: "Zawgyi",
                          //       fontSize: 17.0,
                          //       fontWeight: FontWeight.normal),
                          // ),
                          new Flexible(
                            child: new Container(
                              padding: new EdgeInsets.only(right: 13.0),
                              child: _text1(FontWeight.normal, 12, 17.0),
                              // new Text(
                              //   lan == "Zg"
                              //       ? Rabbit.uni2zg(textMyan[12])
                              //       : textMyan[12],
                              //   // 'ဒေါက်တာမိုးခိုင် ညွှန်ကြားရေးမှူး၊ ကုသရေးဦးစီးဌာန',
                              //   overflow: TextOverflow.visible,
                              //   style: new TextStyle(
                              //       fontFamily: "Zawgyi",
                              //       fontSize: 17.0,
                              //       fontWeight: FontWeight.normal),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              print("Call >> 0923423");
                              showAlertDialog(context, "092174275");
                            },
                            child: Text(
                              "၀၉-၂၁၇၄၂၇၅",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                          )
                        ],
                      ),
                      new Container(
                          margin: new EdgeInsets.symmetric(vertical: 5.0),
                          height: 2.0,
                          width: 55.0,
                          color: Colors.blue[200]),
                      SizedBox(
                        height: 20,
                      ),
                      //------------<<<<<
                      //------->>>>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _text1(FontWeight.normal, 13, 17.0),
                          // Text(
                          //   lan == "Zg" ? Rabbit.uni2zg(textMyan[13]) : textMyan[13],
                          //   // "၅၊ ",
                          //   style: TextStyle(
                          //       fontFamily: "Zawgyi",
                          //       fontSize: 17.0,
                          //       fontWeight: FontWeight.normal),
                          // ),
                          new Flexible(
                            child: new Container(
                              padding: new EdgeInsets.only(right: 13.0),
                              child: _text1(FontWeight.normal, 14, 17.0),
                              //  new Text(
                              //   lan == "Zg"
                              //       ? Rabbit.uni2zg(textMyan[14])
                              //       : textMyan[14],
                              //   // 'ဒေါက်တာဉာဏ်ဝင်းမြင့် ဒုတိယညွှန်ကြားရေးမှူး၊ ဗဟိုကူးစက်ရောဂါတိုက်ဖျက်ရေးဌာနခွဲ ပြည့်သူ့ကျန်းမာရေးဦးစီးဌာန',
                              //   overflow: TextOverflow.visible,
                              //   style: new TextStyle(
                              //       fontFamily: "Zawgyi",
                              //       fontSize: 17.0,
                              //       fontWeight: FontWeight.normal),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              print("Call >> 0923423");
                              showAlertDialog(context, "09459149477");
                            },
                            child: Text(
                              "၀၉-၄၅၉၁၄၉၄၇၇",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                          )
                        ],
                      ),
                      new Container(
                          margin: new EdgeInsets.symmetric(vertical: 5.0),
                          height: 2.0,
                          width: 55.0,
                          color: Colors.blue[200]),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 15, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[15]) : textMyan[15],
                  //   // "ပြည်ထောင်စုနယ်မြေ၊ နေပြည်တော်",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 16, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[16]) : textMyan[16],
                  //   // "၆၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 17, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[17])
                      //       : textMyan[17],
                      //   // 'ဒေါက်တာမြတ်ဝဏ္ဏစိုး၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် နေပြည်တော်ကောင်စီပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "0931495436");
                    },
                    child: Text(
                      "၀၉-၃၁၄၉၅၄၃၆",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 18, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[18]) : textMyan[18],
                  //   // "၇၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 19, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[19])
                      //       : textMyan[19],
                      //   // 'ဒေါက်တာမျိုးစုကြည် ဒုတိယတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095049099");
                    },
                    child: Text(
                      "၀၉-၅၀၄၉၀၉၉",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 20, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[20]) : textMyan[20],
                  //   // "ရန်ကုန်တိုင်းဒေသကြီး",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 21, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[21]) : textMyan[21],
                  //   // "၈၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 22, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[22])
                      //       : textMyan[22],
                      //   // 'ဒေါက်တာထွန်းမြင့် ဒုတိယညွှန်ကြားရေးမှူးချုပ် ရန်ကုန်တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "09449001261");
                    },
                    child: Text(
                      "၀၉-၄၄၉၀၀၁၂၆၁",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 23, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[23]) : textMyan[23],
                  //   // "၉၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 24, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[24])
                      //       : textMyan[24],
                      //   // 'ဒေါက်တာသက်စုမွန် လက်ထောက်ညွှန်ကြားရေးမှူး ရန်ကုန်တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "0979450057");
                    },
                    child: Text(
                      "၀၉-၇၉၄၅၀၀၅၇",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 25, 17.0),
                  // Text(

                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[25]) : textMyan[25],
                  //   // "မန္တလေးတိုင်းဒေသကြီး",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 26, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[26]) : textMyan[26],
                  //   // "၁၀၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 27, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[27])
                      //       : textMyan[27],
                      //   // 'ဒေါက်တာသန်းသန်းမြင့် ဒုတိယညွှန်ကြားရေးမှူးချုပ် မန္တလေးတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "092000344");
                    },
                    child: Text(
                      "၀၉-၂၀၀၀၃၄၄",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 28, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[28]) : textMyan[28],
                  //   // "၁၁၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 29, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[29])
                      //       : textMyan[29],
                      //   // 'ဒေါက်တာသင်းသင်းနွယ် ဒုတိယတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး မန္တလေးတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာန',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "0943099526");
                    },
                    child: Text(
                      "၀၉-၄၃၀၉၉၅၂၆",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 30, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[30]) : textMyan[30],
                  //   // "ကချင်ပြည်နယ်",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 31, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[31]) : textMyan[31],
                  //   // "၁၂၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 32, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[32])
                      //       : textMyan[32],
                      //   // 'ဒေါက်တာအေးသိန်း ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "092100946");
                    },
                    child: Text(
                      "၀၉-၂၁၀၀၉၄၆",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 33, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[33]) : textMyan[33],
                  //   // "ကယားပြည်နယ်",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 34, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[34]) : textMyan[34],
                  //   // "၁၃၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 35, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[35])
                      //       : textMyan[35],
                      //   // 'ဒေါက်တာဌေးလွင် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "09259301114");
                    },
                    child: Text(
                      "၀၉-၂၅၉၃၀၁၁၁၄",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 36, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[36]) : textMyan[36],
                  //   // "ကရင်ပြည်နယ်",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 37, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[37]) : textMyan[37],
                  //   // "၁၄၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 38, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[38])
                      //       : textMyan[38],
                      //   // 'ဒေါက်တာကျော်စွာမြင့် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "09779112472");
                    },
                    child: Text(
                      "၀၉-၇၇၉၁၁၂၄၇၂",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 39, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[39]) : textMyan[39],
                  //   // "ချင်းပြည်နယ်",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 40, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[40]) : textMyan[40],
                  //   // "၁၅၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 41, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[41])
                      //       : textMyan[41],
                      //   // 'ဒေါက်တာအောင်ငွေစံ ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095159176");
                    },
                    child: Text(
                      "၀၉-၅၁၅၉၁၇၆",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 42, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[42]) : textMyan[42],
                  //   // "စစ်ကိုင်းတိုင်းဒေသကြီး",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 43, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[43]) : textMyan[43],
                  //   // "၁၆၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 44, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[44])
                      //       : textMyan[44],
                      //   // 'ဒေါက်တာဝင်းလွင် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "09256445644");
                    },
                    child: Text(
                      "၀၉-၂၅၆၄၄၅၆၄၄",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 45, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[45]) : textMyan[45],
                  //   // "တနင်္သာရီတိုင်းဒေသကြီး",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 46, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[46]) : textMyan[46],
                  //   // "၁၇၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 47, 17.0),
                      // new Text(

                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[47])
                      //       : textMyan[47],
                      //   // 'ဒေါက်တာထွန်းမင်း တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095301579");
                    },
                    child: Text(
                      "၀၉-၅၃၀၁၅၇၉",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 48, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[48]) : textMyan[48],
                  //   // "ပဲခူးတိုင်းဒေသကြီး",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 49, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[49]) : textMyan[49],
                  //   // "၁၈၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 50, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[50])
                      //       : textMyan[50],
                      //   // 'ဒေါက်တာအေးငြိမ်း၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "09254032902");
                    },
                    child: Text(
                      "၀၉-၂၅၄၀၃၂၉၀၂",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 51, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[51]) : textMyan[51],
                  //   // "၁၉၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 52, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[52])
                      //       : textMyan[52],
                      //   // 'ဒေါက်တာအေးအေးငြိမ်း၊ ဒုတိယတိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095029634");
                    },
                    child: Text(
                      "၀၉-၅၀၂၉၆၃၄",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 53, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[53]) : textMyan[53],
                  //   // "မကွေးတိုင်းဒေသကြီး",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 54, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[54]) : textMyan[54],
                  //   // "၂၀၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 55, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[55])
                      //       : textMyan[55],
                      //   // 'ဒေါက်တာသောင်းလှိုင်၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095409685");
                    },
                    child: Text(
                      "၀၉-၅၄၀၉၆၈၅",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 56, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[56]) : textMyan[56],
                  //   // "မွန်ပြည်နယ်",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lan == "Zg" ? Rabbit.uni2zg(textMyan[57]) : textMyan[57],
                    // "၂၁၊ ",
                    style: TextStyle(
                        fontFamily: "Zawgyi",
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal),
                  ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 58, 17.0),
                      //  new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[58])
                      //       : textMyan[58],
                      //   // 'ဒေါက်တာထွန်းအောင်ကြည် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095027963");
                    },
                    child: Text(
                      "၀၉-၅၀၂၇၉၆၃",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 59, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[59]) : textMyan[59],
                  //   // "ရခိုင်ပြည်နယ်",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 60, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[60]) : textMyan[60],
                  //   // "၂၂၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 61, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[61])
                      //       : textMyan[61],
                      //   // 'ဒေါက်တာစိုင်းဝင်းဇော်လှိုင် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095213648");
                    },
                    child: Text(
                      "၀၉-၅၂၁၃၆၄၈",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 62, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[62]) : textMyan[62],
                  //   // "ရှမ်းပြည်နယ် (တောင်ပိုင်း)",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 63, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[63]) : textMyan[63],
                  //   // "၂၃၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 64, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[64])
                      //       : textMyan[64],
                      //   // 'ဒေါက်တာသူဇာချစ်တင်၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095213666");
                    },
                    child: Text(
                      "၀၉-၅၂၁၃၆၆၆",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 65, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[65]) : textMyan[65],
                  //   // "ရှမ်းပြည်နယ် (အရှေ့ပိုင်း)",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 66, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[66]) : textMyan[66],
                  //   // "၂၄၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 67, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[67])
                      //       : textMyan[67],
                      //   // 'ဒေါက်တာမြင့်ကျော် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "09445105995");
                    },
                    child: Text(
                      "၀၉-၄၄၅၁၀၅၉၉၅",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 68, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[68]) : textMyan[68],
                  //   // "ရှမ်းပြည်နယ် (မြောက်ပိုင်း)",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 69, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[69]) : textMyan[69],
                  //   // "၂၅၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 70, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[70])
                      //       : textMyan[70],
                      //   // 'ဒေါက်တာတင်မောင်ညွှန့် ပြည်နယ်ပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "09894009911");
                    },
                    child: Text(
                      "၀၉-၈၉၄၀၀၉၉၁၁",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              //subtitle
              Row(
                children: <Widget>[
                  _text1(FontWeight.w600, 71, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[71]) : textMyan[71],
                  //   // "ဧရာဝတီတိုင်းဒေသကြီး",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //------->>>>
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _text1(FontWeight.normal, 72, 17.0),
                  // Text(
                  //   lan == "Zg" ? Rabbit.uni2zg(textMyan[72]) : textMyan[72],
                  //   // "၂၆၊ ",
                  //   style: TextStyle(
                  //       fontFamily: "Zawgyi",
                  //       fontSize: 17.0,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  new Flexible(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 13.0),
                      child: _text1(FontWeight.normal, 73, 17.0),
                      // new Text(
                      //   lan == "Zg"
                      //       ? Rabbit.uni2zg(textMyan[73])
                      //       : textMyan[73],
                      //   // 'ဒေါက်တာသန်းထွန်းအောင်၊ ဒုတိယညွှန်ကြားရေးမှူးချုပ် တိုင်းဒေသကြီးပြည်သူ့ကျန်းမာရေးဦးစီးဌာနမှူး',
                      //   overflow: TextOverflow.visible,
                      //   style: new TextStyle(
                      //       fontFamily: "Zawgyi",
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.normal),
                      // ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Call >> 0923423");
                      showAlertDialog(context, "095408973");
                    },
                    child: Text(
                      "၀၉-၅၄၀၈၉၇၃",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                  )
                ],
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 2.0,
                  width: 55.0,
                  color: Colors.blue[200]),
              SizedBox(
                height: 20,
              ),
              //------------<<<<<
              // //------->>>>
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Text(
              //       "",
              //       style: TextStyle(
              //           fontSize: 17.0, fontWeight: FontWeight.normal),
              //     ),
              //     new Flexible(
              //       child: new Container(
              //         padding: new EdgeInsets.only(right: 13.0),
              //         child: new Text(
              //           '',
              //           overflow: TextOverflow.visible,
              //           style: new TextStyle(
              //               fontSize: 17.0, fontWeight: FontWeight.normal),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     GestureDetector(
              //       onTap: () {
              //         print("Call >> 0923423");
              //       },
              //       child: Text(
              //         "",
              //         style: TextStyle(
              //             fontSize: 18.0,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.lightBlue),
              //       ),
              //     )
              //   ],
              // ),
              // new Container(
              //     margin: new EdgeInsets.symmetric(vertical: 5.0),
              //     height: 2.0,
              //     width: 55.0,
              //     color: Colors.blue[200]),
              // SizedBox(
              //   height: 20,
              // ),
              // //------------<<<<<
            ],
          ),
        ),
      ),
    );
  }
}
