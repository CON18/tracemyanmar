import 'package:TraceMyanmar/Intro/TC.dart';
import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool _giveVerse = false;
  String checkfont = '';
  String lan = '';

  @override
  void initState() {
    super.initState();
    someMethod();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.lightBlue,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 50,
              // ),
              Image(
                image: AssetImage("assets/tm-logo1.png"),
                height: 130,
                width: 130,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Saw Saw Shar",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Terms and Condition",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "English",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Switch(
                    activeColor: Colors.white,
                    value: _giveVerse,
                    onChanged: (bool newValue) {
                      setState(() {
                        _giveVerse = newValue;
                      });
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        lan == "Zg" ? Rabbit.uni2zg("မြန်မာ") : "မြန်မာ",
                        // "မြန်မာ",
                        style: TextStyle(
                            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                ),
                child: (_giveVerse == false)
                    ? Text(
                        "Someone who have returned from abroad (or) COVID-19 local transmission areas should do mandatory reporting, self-isolation (or) self-quarantine procedures to get the early effective lifesaving treatment and prevent transmission to family, people staying together and village/ward residing.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      )
                    : Text(
                        lan == "Zg"
                            ? Rabbit.uni2zg(
                                "ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေသတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သောကုသမှုများခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ် နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။")
                            : "ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေသတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သောကုသမှုများခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ် နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။",
                        // "ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေသတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သောကုသမှုများခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ် နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။",
                        style: TextStyle(
                          fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(25.0),
                child: (_giveVerse == false)
                    ? Text(
                        "Someone who have returned from abroad (or) COVID-19 local transmission areas should do mandatory reporting to local administrative authorities (village/ward) or nearest health department.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      )
                    : Text(
                        lan == "Zg"
                            ? Rabbit.uni2zg(
                                "ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ဒေသရှိ ရပ်ကွက်/ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက်သတင်းပို့ပါရန်။")
                            : "ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ဒေသရှိ ရပ်ကွက်/ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက်သတင်းပို့ပါရန်။",
                        // "ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ဒေသရှိ ရပ်ကွက်/ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက်သတင်းပို့ပါရန်။",
                        style: TextStyle(
                          fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          color: Colors.lightBlue,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: RaisedButton(
                  elevation: 10,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TCPage(
                          check: "0",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    lan == "Zg" ? Rabbit.uni2zg('ရှေ့သို့ (Next)') : 'ရှေ့သို့ (Next)',
                    // 'ရှေ့သို့ (Next)',
                    style: TextStyle(
                      fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.black38,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
