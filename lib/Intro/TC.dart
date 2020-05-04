import 'package:TraceMyanmar/tabs.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class TCPage extends StatefulWidget {
  final String check;

  TCPage({Key key, this.check}) : super(key: key);
  @override
  _TCPageState createState() => _TCPageState();
}

class _TCPageState extends State<TCPage> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  bool _giveVerse = true;
  String checkfont = '';
  String lan = '';

  @override
  void initState() {
    super.initState();
    someMethod();
    analyst();
  }

  analyst() async {
    await analytics.logEvent(
      name: 'TC_Request',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.lightBlue),
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
                  fontWeight: FontWeight.w600,
                ),
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
                        "By the end of December, 2019, Coronavirus disease (COVID-19) has started and is spreading globally as a pandemic disease.Government of the Republic of the Union of Myanmar, Ministry of Health and Sports has started preparedness and response actions on COVID-19 since January 4, 2020. On February 28, by the Order 19/2020 respiratory disease (Coronavirus Disease 2019 - COVID-19) in order to prevent, contain and manage COVID-19 in the country, (Coronavirus Disease 2019 - COVID-19) is classified as epidemic and notifiable disease which must be reported and notified immediately under infectious diseases Suppression Act Section 21, subsection (b).Thus, the Saw Saw Shar Application system was developed to prevent COVID-19 respiratory disease.This is a system that monitors your daily health. You are placed in quarantine and must report your health status twice a day. By participating in this system, you and your family, and your community will be better to prevent the spread of infection in Myanmar. It will help the environment and Myanmar.It is important that your information is complete and accurate to prevent the spread of COVID-19 in your family, community and country. This information is collected for purpose of use the prevention and control of COVID-19 within the specified time period and it will not be used in any other unrelated purposes.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      )
                    : Text(
                        lan == "Zg"
                            ? Rabbit.uni2zg(
//                                 '''၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။
// ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်း လုပ်ငန်းများအား စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံ အတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်း များကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေ သတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သော ကုသမှုများ ခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ်နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ ဒေသရှိ ရပ်ကွက်/ ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက် သတင်းပို့ရမည်ဖြစ်ပါသည်။
// သို့ဖြစ်ပါ၍ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Shar (စောစောရှာ) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်းဖြစ်ပါသည်။
// ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေစဉ်ကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို နေ့စဉ် စောင့်ကြည့်ပေးနေမည့်စနစ် ဖြစ်ပါသည်။ လူကြီးမင်း၏ ကျန်းမာရေး အခြေအနေကို လူကြီးမင်း ကိုယ်တိုင် တစ်နေ့ (၂) ကြိမ် သတင်းပေးပို့ ပေးရမည် ဖြစ်ပါသည်။ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်းဖြင့် လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာရောက်မည် ဖြစ်ပါသည်။
// လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံအား COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှုကို ထိန်းချုပ် ကာကွယ်နိုင်ရေး လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။
// တစ်ရက် (၂) ကြိမ် သတင်းပို့ရန် ပျက်ကွက်ခြင်း၊ အချက်အလက်များကို မှန်ကန်စွာ ဖြည့်သွင်းခြင်း မပြုပါက တည်ဆဲဥပဒေများ (ရာဇသတ်ကြီးဥပဒေ၊ ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ၊ သဘာဝဘေးအန္တရာယ်စီမံခန့်ခွဲမှုဆိုင်ရာဥပဒေနှင့် အခြားဆက်စပ် ဥပဒေများ) အရ ထိရောက်စွာ အရေးယူခြင်းခံရမည် ဖြစ်ပါသည်။
// အထက်ဖော်ပြပါ အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရသူများအပြင် မြန်မာနိုင်ငံသားများအားလုံး အနေဖြင့် လည်း ပူးပေါင်းပါဝင်နိုင်ပါသည်။ ထိုသို့ ပူးပေါင်းပါဝင်ခြင်းဖြင့် ရောဂါကူးစက်ခံရသူ ရောက်ရှိခဲ့သော နေရာများကို သိရှိနိုင်ခြင်း၊ မိမိအနေဖြင့် အဆိုပါနေရာတွင် ရောဂါကူးစက်ခံထားရသူနှင့် အတူ ရှိနေခဲ့ခြင်းနှင့် ထိတွေ့ခဲ့မှု ရှိ/မရှိတို့ကို သိရှိနိုင်ခြင်း တို့ကြောင့် ရောဂါကူးစက်ခံရနိုင်မှု အခြေအနေ ကို စောစောသိရှိနိုင်ပါသည်။ စောစောသိခြင်းဖြင့် ရောဂါကူးစက် ခံရနိုင်မှု ရှိ/မရှိ ကို စောစောရှာနိုင် မည် ဖြစ်သောကြောင့် စောစောကုသနိုင်ပြီး မိမိနှင့် မိမိ ပတ်ဝန်းကျင်ကို ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါ သည်။ စောစောရှာ နိုင်ခြင်းဖြင့် ရောဂါကူးစက်ပြန့်ပွားမှုကို ထိန်းချုပ်ကာကွယ်နိုင်မည် ဖြစ်ပါသည်။
// ယခု ကောက်ခံသော အချက်အလက်များသည် COVID-19 အသက်ရှူ လမ်းကြောင်း ဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ရောဂါကူးစက်ဖြစ်ပွားနေသည့် သတ်မှတ် ကာလအတွင်းတွင်သာ အသုံးပြုရန် ကောက်ခံခြင်းဖြစ်ပါသည်။ ကောက်ခံထားသည့် အချက် အလက်များကို အခြား မသက်ဆိုင်သည့်နေရာများတွင် အသုံးပြုမည် မဟုတ်ပါ။''')
//                                 '''၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။
// ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်း လုပ်ငန်းများအား စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံ အတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်း များကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ ဒေသရှိ ရပ်ကွက်/ ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက် သတင်းပို့ရမည်ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေ သတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သော ကုသမှုများ ခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ်နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။
// COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Shar (စောစောရှာ) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်း ဖြစ်ပါသည်။
// ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရပါက ထိုကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို သတင်းပေးပို့နိုင်ပြီး၊ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်း ဖြင့် လူကြီးမင်း နှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာရောက်မည် ဖြစ်ပါသည်။
// လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံအား COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှုကို ထိန်းချုပ် ကာကွယ်နိုင်ရေး လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။
// အသွားအလာ ကန့်သတ် (Quarantine) ၍ ရောဂါစောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရသူများအပြင် မြန်မာနိုင်ငံအတွင်း နေထိုင်သူများအားလုံး အနေဖြင့် လည်း ပူးပေါင်းပါဝင်ရန်လိုအပ်ပါသည်။ ထိုသို့ပူးပေါင်းပါဝင်ခြင်းဖြင့် ရောဂါကူးစက်ခံရသူ ရောက်ရှိ ခဲ့သော နေရာများကို သိရှိနိုင်မည်ဖြစ်ပြီး မိမိအနေဖြင့် အဆိုပါနေရာတွင် ရှိနေခဲ့ခြင်း ရှိ/မရှိ ကို သိရှိနိုင်ခြင်းကြောင့် ရောဂါကူးစက်ခံရနိုင်မှု အခြေအနေကို စောစောသိရှိနိုင်မည်ပါသည်။ ထိုသို့ စောစောသိရှိခြင်းဖြင့် ရောဂါကူးစက်ခံရနိုင်မှု ရှိ/မရှိ ကို စောစောရှာဖွေကုသမှုပေးနိုင်ပြီး မိမိနှင့် မိမိပတ်ဝန်းကျင်ကို ကာကွယ်ပေးနိုင်မည်ဖြစ်သကဲ့သို့ ရောဂါကူးစက်ပြန့်ပွားမှုကိုလည်း ထိန်းချုပ် ကာကွယ်နိုင်မည်ဖြစ်ပါသည်။
// ဤ Mobile Application မှ ကောက်ခံရရှိသော အချက်အလက်များကို ရယူဆောင်ရွက် ရာတွင် တစ်ဦးချင်းစီ၏ ပုဂ္ဂိုလ်ရေးဆိုင်ရာအချက်အလက်များကို ထုတ်ဖော်သွားမည် မဟုတ်ဘဲ၊ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ရောဂါ ကူးစက် ဖြစ်ပွားနေသည့် သတ်မှတ်ကာလအတွင်းတွင်သာ အသုံးပြုရန် ရယူခြင်း ဖြစ်ပြီး အခြား မသက်ဆိုင်သည့်နေရာများတွင် လုံးဝ (လုံးဝ) အသုံးပြုမည် မဟုတ်ပါကြောင်း ဖော်ပြအပ်ပါသည်။

// Coronavirus Disease 2019 (COVID-19) ထိန်းချုပ်ရေးနှင့်အရေးပေါ်တုံ့ပြန်ရေး
// ICT နည်းပညာအထောက်အကူပြုလုပ်ငန်းအဖွဲ့''')
                                '''၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။
ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်း လုပ်ငန်းများကို စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံအတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်းများကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁၊ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။
ရောဂါဖြစ်ပွါးရာဒေသမှ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ ဒေသရှိ ရပ်ကွက်/ ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာရေးဌာနသို့ မပျက်မကွက် သတင်းပို့ရမည်ဖြစ်ပါသည်။
ရောဂါဖြစ်ပွါးရာဒေသမှ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေ သတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သော ကုသမှုများ ခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ်နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုကို ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။
COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Shar (စောစောရှာ) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်း ဖြစ်ပါသည်။
ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရပါက ထိုကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို သတင်းပေးပို့နိုင်ပြီး၊ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်းဖြင့် လူကြီးမင်း နှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာရောက်မည် ဖြစ်ပါသည်။
လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှု ထိန်းချုပ်၊ ကာကွယ်နိုင်ရေးအတွက် လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။
အသွားအလာ ကန့်သတ် (Quarantine) ၍ ရောဂါစောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရသူများအပြင် မြန်မာနိုင်ငံအတွင်း နေထိုင်သူများအားလုံး အနေဖြင့် လည်း ပူးပေါင်းပါဝင်ရန်လိုအပ်ပါသည်။ ထိုသို့ပူးပေါင်းပါဝင်ခြင်းဖြင့် ရောဂါကူးစက်ခံရသူ ရောက်ရှိခဲ့သော နေရာများကို သိရှိနိုင်မည်ဖြစ်ပြီး မိမိအနေဖြင့် အဆိုပါနေရာတွင် ရှိနေခဲ့ခြင်း ရှိ/မရှိ ကိုလည်း သိရှိနိုင်ခြင်းကြောင့် ရောဂါကူးစက်ခံရနိုင်မှု အခြေအနေကို စောစောသိရှိနိုင်မည်ပါသည်။ ထိုသို့ စောစောသိရှိခြင်းဖြင့် ရောဂါကူးစက်ခံရနိုင်မှု ရှိ/မရှိ ကို စောစောရှာဖွေကုသမှုပေးနိုင်ပြီး မိမိနှင့် မိမိပတ်ဝန်းကျင်ကို ကာကွယ်ပေးနိုင်မည်ဖြစ်သကဲ့သို့ ရောဂါကူးစက်ပြန့်ပွားမှုကိုလည်း ထိန်းချုပ် ကာကွယ်နိုင်မည်ဖြစ်ပါသည်။ 
ဤ Mobile Application က ကောက်ခံရရှိသော အချက်အလက်များကို ရယူဆောင်ရွက် ရာတွင် တစ်ဦးချင်းစီ၏ ပုဂ္ဂိုလ်ရေးဆိုင်ရာအချက်အလက်များကို ထုတ်ဖော်သွားမည် မဟုတ်ဘဲ၊ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ရောဂါ ကူးစက် ဖြစ်ပွားနေသည့် သတ်မှတ်ကာလအတွင်းတွင်သာ အသုံးပြုရန် ရယူခြင်း ဖြစ်ပြီး အခြား မသက်ဆိုင်သည့်နေရာများတွင် လုံးဝ (လုံးဝ) အသုံးပြုမည် မဟုတ်ပါကြောင်း ဖော်ပြအပ်ပါသည်။


Coronavirus Disease 2019 (COVID-19) ထိန်းချုပ်ရေးနှင့်အရေးပေါ်တုံ့ပြန်ရေး
ICT နည်းပညာအထောက်အကူပြုလုပ်ငန်းအဖွဲ့''')
                            : '''၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။
ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်း လုပ်ငန်းများကို စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံအတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်းများကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁၊ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။
ရောဂါဖြစ်ပွါးရာဒေသမှ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ ဒေသရှိ ရပ်ကွက်/ ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာရေးဌာနသို့ မပျက်မကွက် သတင်းပို့ရမည်ဖြစ်ပါသည်။
ရောဂါဖြစ်ပွါးရာဒေသမှ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေ သတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သော ကုသမှုများ ခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ်နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုကို ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။
COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Shar (စောစောရှာ) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်း ဖြစ်ပါသည်။
ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရပါက ထိုကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို သတင်းပေးပို့နိုင်ပြီး၊ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်းဖြင့် လူကြီးမင်း နှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာရောက်မည် ဖြစ်ပါသည်။
လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှု ထိန်းချုပ်၊ ကာကွယ်နိုင်ရေးအတွက် လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။
အသွားအလာ ကန့်သတ် (Quarantine) ၍ ရောဂါစောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရသူများအပြင် မြန်မာနိုင်ငံအတွင်း နေထိုင်သူများအားလုံး အနေဖြင့် လည်း ပူးပေါင်းပါဝင်ရန်လိုအပ်ပါသည်။ ထိုသို့ပူးပေါင်းပါဝင်ခြင်းဖြင့် ရောဂါကူးစက်ခံရသူ ရောက်ရှိခဲ့သော နေရာများကို သိရှိနိုင်မည်ဖြစ်ပြီး မိမိအနေဖြင့် အဆိုပါနေရာတွင် ရှိနေခဲ့ခြင်း ရှိ/မရှိ ကိုလည်း သိရှိနိုင်ခြင်းကြောင့် ရောဂါကူးစက်ခံရနိုင်မှု အခြေအနေကို စောစောသိရှိနိုင်မည်ပါသည်။ ထိုသို့ စောစောသိရှိခြင်းဖြင့် ရောဂါကူးစက်ခံရနိုင်မှု ရှိ/မရှိ ကို စောစောရှာဖွေကုသမှုပေးနိုင်ပြီး မိမိနှင့် မိမိပတ်ဝန်းကျင်ကို ကာကွယ်ပေးနိုင်မည်ဖြစ်သကဲ့သို့ ရောဂါကူးစက်ပြန့်ပွားမှုကိုလည်း ထိန်းချုပ် ကာကွယ်နိုင်မည်ဖြစ်ပါသည်။ 
ဤ Mobile Application က ကောက်ခံရရှိသော အချက်အလက်များကို ရယူဆောင်ရွက် ရာတွင် တစ်ဦးချင်းစီ၏ ပုဂ္ဂိုလ်ရေးဆိုင်ရာအချက်အလက်များကို ထုတ်ဖော်သွားမည် မဟုတ်ဘဲ၊ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ရောဂါ ကူးစက် ဖြစ်ပွားနေသည့် သတ်မှတ်ကာလအတွင်းတွင်သာ အသုံးပြုရန် ရယူခြင်း ဖြစ်ပြီး အခြား မသက်ဆိုင်သည့်နေရာများတွင် လုံးဝ (လုံးဝ) အသုံးပြုမည် မဟုတ်ပါကြောင်း ဖော်ပြအပ်ပါသည်။


Coronavirus Disease 2019 (COVID-19) ထိန်းချုပ်ရေးနှင့်အရေးပေါ်တုံ့ပြန်ရေး
ICT နည်းပညာအထောက်အကူပြုလုပ်ငန်းအဖွဲ့''',
//                             : '''၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။
// ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်း လုပ်ငန်းများအား စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံ အတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်း များကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ ဒေသရှိ ရပ်ကွက်/ ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက် သတင်းပို့ရမည်ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေ သတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သော ကုသမှုများ ခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ်နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။
// COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Shar (စောစောရှာ) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်း ဖြစ်ပါသည်။
// ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရပါက ထိုကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို သတင်းပေးပို့နိုင်ပြီး၊ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်း ဖြင့် လူကြီးမင်း နှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာရောက်မည် ဖြစ်ပါသည်။
// လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံအား COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှုကို ထိန်းချုပ် ကာကွယ်နိုင်ရေး လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။
// အသွားအလာ ကန့်သတ် (Quarantine) ၍ ရောဂါစောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရသူများအပြင် မြန်မာနိုင်ငံအတွင်း နေထိုင်သူများအားလုံး အနေဖြင့် လည်း ပူးပေါင်းပါဝင်ရန်လိုအပ်ပါသည်။ ထိုသို့ပူးပေါင်းပါဝင်ခြင်းဖြင့် ရောဂါကူးစက်ခံရသူ ရောက်ရှိ ခဲ့သော နေရာများကို သိရှိနိုင်မည်ဖြစ်ပြီး မိမိအနေဖြင့် အဆိုပါနေရာတွင် ရှိနေခဲ့ခြင်း ရှိ/မရှိ ကို သိရှိနိုင်ခြင်းကြောင့် ရောဂါကူးစက်ခံရနိုင်မှု အခြေအနေကို စောစောသိရှိနိုင်မည်ပါသည်။ ထိုသို့ စောစောသိရှိခြင်းဖြင့် ရောဂါကူးစက်ခံရနိုင်မှု ရှိ/မရှိ ကို စောစောရှာဖွေကုသမှုပေးနိုင်ပြီး မိမိနှင့် မိမိပတ်ဝန်းကျင်ကို ကာကွယ်ပေးနိုင်မည်ဖြစ်သကဲ့သို့ ရောဂါကူးစက်ပြန့်ပွားမှုကိုလည်း ထိန်းချုပ် ကာကွယ်နိုင်မည်ဖြစ်ပါသည်။
// ဤ Mobile Application မှ ကောက်ခံရရှိသော အချက်အလက်များကို ရယူဆောင်ရွက် ရာတွင် တစ်ဦးချင်းစီ၏ ပုဂ္ဂိုလ်ရေးဆိုင်ရာအချက်အလက်များကို ထုတ်ဖော်သွားမည် မဟုတ်ဘဲ၊ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ရောဂါ ကူးစက် ဖြစ်ပွားနေသည့် သတ်မှတ်ကာလအတွင်းတွင်သာ အသုံးပြုရန် ရယူခြင်း ဖြစ်ပြီး အခြား မသက်ဆိုင်သည့်နေရာများတွင် လုံးဝ (လုံးဝ) အသုံးပြုမည် မဟုတ်ပါကြောင်း ဖော်ပြအပ်ပါသည်။

// Coronavirus Disease 2019 (COVID-19) ထိန်းချုပ်ရေးနှင့်အရေးပေါ်တုံ့ပြန်ရေး
// ICT နည်းပညာအထောက်အကူပြုလုပ်ငန်းအဖွဲ့''',
//                             : '''၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။
// ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်း လုပ်ငန်းများအား စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံ အတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်း များကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေ သတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သော ကုသမှုများ ခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ်နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ ဒေသရှိ ရပ်ကွက်/ ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက် သတင်းပို့ရမည်ဖြစ်ပါသည်။
// သို့ဖြစ်ပါ၍ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Shar (စောစောရှာ) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်းဖြစ်ပါသည်။
// ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေစဉ်ကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို နေ့စဉ် စောင့်ကြည့်ပေးနေမည့်စနစ် ဖြစ်ပါသည်။ လူကြီးမင်း၏ ကျန်းမာရေး အခြေအနေကို လူကြီးမင်း ကိုယ်တိုင် တစ်နေ့ (၂) ကြိမ် သတင်းပေးပို့ ပေးရမည် ဖြစ်ပါသည်။ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်းဖြင့် လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာရောက်မည် ဖြစ်ပါသည်။
// လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံအား COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှုကို ထိန်းချုပ် ကာကွယ်နိုင်ရေး လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။
// တစ်ရက် (၂) ကြိမ် သတင်းပို့ရန် ပျက်ကွက်ခြင်း၊ အချက်အလက်များကို မှန်ကန်စွာ ဖြည့်သွင်းခြင်း မပြုပါက တည်ဆဲဥပဒေများ (ရာဇသတ်ကြီးဥပဒေ၊ ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ၊ သဘာဝဘေးအန္တရာယ်စီမံခန့်ခွဲမှုဆိုင်ရာဥပဒေနှင့် အခြားဆက်စပ် ဥပဒေများ) အရ ထိရောက်စွာ အရေးယူခြင်းခံရမည် ဖြစ်ပါသည်။
// အထက်ဖော်ပြပါ အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရသူများအပြင် မြန်မာနိုင်ငံသားများအားလုံး အနေဖြင့် လည်း ပူးပေါင်းပါဝင်နိုင်ပါသည်။ ထိုသို့ ပူးပေါင်းပါဝင်ခြင်းဖြင့် ရောဂါကူးစက်ခံရသူ ရောက်ရှိခဲ့သော နေရာများကို သိရှိနိုင်ခြင်း၊ မိမိအနေဖြင့် အဆိုပါနေရာတွင် ရောဂါကူးစက်ခံထားရသူနှင့် အတူ ရှိနေခဲ့ခြင်းနှင့် ထိတွေ့ခဲ့မှု ရှိ/မရှိတို့ကို သိရှိနိုင်ခြင်း တို့ကြောင့် ရောဂါကူးစက်ခံရနိုင်မှု အခြေအနေ ကို စောစောသိရှိနိုင်ပါသည်။ စောစောသိခြင်းဖြင့် ရောဂါကူးစက် ခံရနိုင်မှု ရှိ/မရှိ ကို စောစောရှာနိုင် မည် ဖြစ်သောကြောင့် စောစောကုသနိုင်ပြီး မိမိနှင့် မိမိ ပတ်ဝန်းကျင်ကို ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါ သည်။ စောစောရှာ နိုင်ခြင်းဖြင့် ရောဂါကူးစက်ပြန့်ပွားမှုကို ထိန်းချုပ်ကာကွယ်နိုင်မည် ဖြစ်ပါသည်။
// ယခု ကောက်ခံသော အချက်အလက်များသည် COVID-19 အသက်ရှူ လမ်းကြောင်း ဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ရောဂါကူးစက်ဖြစ်ပွားနေသည့် သတ်မှတ် ကာလအတွင်းတွင်သာ အသုံးပြုရန် ကောက်ခံခြင်းဖြစ်ပါသည်။ ကောက်ခံထားသည့် အချက် အလက်များကို အခြား မသက်ဆိုင်သည့်နေရာများတွင် အသုံးပြုမည် မဟုတ်ပါ။''',
                        // "၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်းလုပ်ငန်းများအား စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံအတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်းများကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။သို့ဖြစ်ပါ၍ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ် နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Pyaw (စောစောပြော) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်းဖြစ်ပါသည်။ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါစောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေစဉ်ကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို နေ့စဉ် စောင့်ကြည့်ပေးနေမည့်စနစ် ဖြစ်ပါသည်။ လူကြီးမင်း၏ ကျန်းမာရေး အခြေအနေကို လူကြီးမင်း ကိုယ်တိုင် တစ်နေ့ (၂) ကြိမ် သတင်းပေးပို့ ပေးရမည်ဖြစ်ပါသည်။ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်းဖြင့် လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာ ရောက်မည် ဖြစ်ပါသည်။လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံအား COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှုကို ထိန်းချုပ် ကာကွယ်နိုင်ရေး လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။တစ်ရက် (၂) ကြိမ် သတင်းပို့ရန် ပျက်ကွက်ခြင်း၊ အချက်အလက်များကို မှန်ကန်စွာ ဖြည့်သွင်းခြင်း မပြုပါက တည်ဆဲဥပဒေများ (ရာဇသတ်ကြီးဥပဒေ၊ ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ၊ သဘာဝဘေးအန္တရာယ်စီမံခန့်ခွဲမှုဆိုင်ရာဥပဒေနှင့် အခြားဆက်စပ် ဥပဒေများ) အရ ထိရောက်စွာ အရေးယူခြင်းခံရမည် ဖြစ်ပါသည်။ယခု ကောက်ခံသော အချက်အလက်များသည် COVID-19 အသက်ရှူ လမ်းကြောင်း ဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ သတ်မှတ်ကာလ အတွင်းတွင်သာ အသုံးပြုရန် ကောက်ခံခြင်းဖြစ်ပါသည်။ ကောက်ခံထားသည့် အချက်အလက်များကို အခြား မသက်ဆိုင်သည့်နေရာများတွင် အသုံးပြုမည် မဟုတ်ပါ။",
//                         '''၂၀၁၉ ခုနှစ်၊ ဒီဇင်ဘာလကုန်တွင် စတင်ဖြစ်ပွားခဲ့သည့် လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) သည် ယခုအခါ ကမ္ဘာ့နိုင်ငံအသီးသီးသို့ ကပ်ရောဂါအသွင်ဖြင့် ကူးစက်ပျံ့နှံ့လျက်ရှိပါသည်။
// ပြည်ထောင်စုသမ္မတမြန်မာနိုင်ငံတော်အစိုးရ၊ ကျန်းမာရေးနှင့်အားကစားဝန်ကြီးဌာန သည် ၂၀၂၀ ပြည့်နှစ်၊ ဇန်နဝါရီလ (၄)ရက်နေ့မှ စတင်၍ COVID-19 ရောဂါ ကာကွယ်၊ ကုသ၊ ထိန်းချုပ်ခြင်း လုပ်ငန်းများအား စတင်ဆောင်ရွက်ခဲ့ပြီး ဖေဖော်ဝါရီလ (၂၈) ရက်နေ့တွင် အမိန့် ၁၉/၂၀၂၀ ဖြင့် အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) မြန်မာနိုင်ငံ အတွင်း ကူးစက်ပျံ့နှံ့မှု မဖြစ်ပွားစေရေးအတွက် ကြိုတင်ကာကွယ်ခြင်းနှင့် တုံ့ပြန်ဆောင်ရွက်ခြင်း များကို ထိရောက်စွာ ဆောင်ရွက်နိုင်ရန် ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ ပုဒ်မ ၂၁ ပုဒ်မခွဲ (ခ) ပါ လုပ်ပိုင်ခွင့်ကို ကျင့်သုံး၍ လတ်တလော အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ (Coronavirus Disease 2019 – COVID-19) ကို ကူးစက်မြန်ရောဂါ သို့မဟုတ် တိုင်ကြားရမည့် ကူးစက်ရောဂါ အဖြစ် သတ်မှတ်ခဲ့ပြီး ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူတစ်ဦးအနေဖြင့် မဖြစ်မနေ သတင်းပို့ခြင်း၊ သီးသန့်ခွဲခြားနေထိုင်ခြင်း (Isolation)၊ အသွားအလာကန့်သတ်ခြင်း (Quarantine) ပြုလုပ်ခြင်းဖြင့် မိမိကိုယ်တိုင် ရောဂါဖြစ်ပွားလာပါက စောစီးစွာ သိရှိပြီး ထိရောက်သော ကုသမှုများ ခံယူရ၍ အသက်သေဆုံးခြင်းမှ ကာကွယ်နိုင်မည့်အပြင် မိသားစုဝင်များ၊ အတူနေသူများနှင့် မိမိနေထိုင်ရာရပ်ရွာသို့ ရောဂါ ကူးစက်မှုအား ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါသည်။
// ရောဂါဖြစ်ပွားရာဒေသ (သို့မဟုတ်) နိုင်ငံခြားမှ ပြန်ရောက်လာသူများအနေဖြင့် မိမိတို့ ဒေသရှိ ရပ်ကွက်/ ကျေးရွာအုပ်ချုပ်ရေးမှူးရုံး (သို့မဟုတ်) နီးစပ်ရာကျန်းမာ ရေးဌာနသို့ မပျက်မကွက် သတင်းပို့ရမည်ဖြစ်ပါသည်။
// သို့ဖြစ်ပါ၍ COVID-19 အသက်ရှူလမ်းကြောင်းဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ဤ Saw Saw Shar (စောစောရှာ) Application စနစ်ကို အကောင်အထည် ဖော်ခြင်းဖြစ်ပါသည်။
// ဤစနစ်သည် လူကြီးမင်းအနေဖြင့် အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေစဉ်ကာလအတွင်း လူကြီးမင်း၏ ကျန်းမာရေးအခြေအနေကို နေ့စဉ် စောင့်ကြည့်ပေးနေမည့်စနစ် ဖြစ်ပါသည်။ လူကြီးမင်း၏ ကျန်းမာရေး အခြေအနေကို လူကြီးမင်း ကိုယ်တိုင် တစ်နေ့ (၂) ကြိမ် သတင်းပေးပို့ ပေးရမည် ဖြစ်ပါသည်။ ဤစနစ်တွင် ပူးပေါင်းပါဝင်ပေးခြင်းဖြင့် လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံကို ကူညီရာရောက်မည် ဖြစ်ပါသည်။
// လူကြီးမင်းနှင့် မိသားစု၊ ပတ်ဝန်းကျင်နှင့် မြန်မာနိုင်ငံအား COVID-19 အသက်ရှူ လမ်းကြောင်းဆိုင်ရာရောဂါ ကူးစက်ပျံ့နှံ့မှုကို ထိန်းချုပ် ကာကွယ်နိုင်ရေး လူကြီးမင်း၏ အချက်အလက်များကို ပြည့်စုံမှန်ကန်စွာ ဖြည့်သွင်း ပေးပို့ပေးရန်လိုအပ်ပါသည်။
// တစ်ရက် (၂) ကြိမ် သတင်းပို့ရန် ပျက်ကွက်ခြင်း၊ အချက်အလက်များကို မှန်ကန်စွာ ဖြည့်သွင်းခြင်း မပြုပါက တည်ဆဲဥပဒေများ (ရာဇသတ်ကြီးဥပဒေ၊ ကူးစက်ရောဂါများ ကာကွယ် နှိမ်နင်းရေးဥပဒေ၊ သဘာဝဘေးအန္တရာယ်စီမံခန့်ခွဲမှုဆိုင်ရာဥပဒေနှင့် အခြားဆက်စပ် ဥပဒေများ) အရ ထိရောက်စွာ အရေးယူခြင်းခံရမည် ဖြစ်ပါသည်။
// အထက်ဖော်ပြပါ အသွားအလာ ကန့်သတ် (Quarantine) ၍   ရောဂါ စောင့်ကြပ်ကြည့်ရှုခြင်း (Surveillance) ကို လိုက်နာဆောင်ရွက်နေရသူများအပြင် မြန်မာနိုင်ငံသားများအားလုံး အနေဖြင့် လည်း ပူးပေါင်းပါဝင်နိုင်ပါသည်။ ထိုသို့ ပူးပေါင်းပါဝင်ခြင်းဖြင့် ရောဂါကူးစက်ခံရသူ ရောက်ရှိခဲ့သော နေရာများကို သိရှိနိုင်ခြင်း၊ မိမိအနေဖြင့် အဆိုပါနေရာတွင် ရောဂါကူးစက်ခံထားရသူနှင့် အတူ ရှိနေခဲ့ခြင်းနှင့် ထိတွေ့ခဲ့မှု ရှိ/မရှိတို့ကို သိရှိနိုင်ခြင်း တို့ကြောင့် ရောဂါကူးစက်ခံရနိုင်မှု အခြေအနေ ကို စောစောသိရှိနိုင်ပါသည်။ စောစောသိခြင်းဖြင့် ရောဂါကူးစက် ခံရနိုင်မှု ရှိ/မရှိ ကို စောစောရှာနိုင် မည် ဖြစ်သောကြောင့် စောစောကုသနိုင်ပြီး မိမိနှင့် မိမိ ပတ်ဝန်းကျင်ကို ကာကွယ်ပေးနိုင်မည် ဖြစ်ပါ သည်။ စောစောရှာ နိုင်ခြင်းဖြင့် ရောဂါကူးစက်ပြန့်ပွားမှုကို ထိန်းချုပ်ကာကွယ်နိုင်မည် ဖြစ်ပါသည်။
// ယခု ကောက်ခံသော အချက်အလက်များသည် COVID-19 အသက်ရှူ လမ်းကြောင်း ဆိုင်ရာရောဂါကို ထိန်းချုပ် ကာကွယ်နိုင်ရန် ရည်ရွယ်၍ ရောဂါကူးစက်ဖြစ်ပွားနေသည့် သတ်မှတ် ကာလအတွင်းတွင်သာ အသုံးပြုရန် ကောက်ခံခြင်းဖြစ်ပါသည်။ ကောက်ခံထားသည့် အချက် အလက်များကို အခြား မသက်ဆိုင်သည့်နေရာများတွင် အသုံးပြုမည် မဟုတ်ပါ။''',
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
                child: widget.check == "1"
                    ? RaisedButton(
                        elevation: 10,
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          lan == "Zg"
                              ? Rabbit.uni2zg('နောက်သို့ (Back)')
                              : 'နောက်သို့ (Back)',
                          // 'နောက်သို့ (Back)',
                          style: TextStyle(
                            fontFamily: lan == "Zg" ? "Zawgyi" : "Pyidaungsu",
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.black38,
                        textColor: Colors.white,
                      )
                    : RaisedButton(
                        elevation: 10,
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          setState(() {
                            prefs.setString("firsttime", "true");
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabsPage(
                                openTab: 1,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          lan == "Zg"
                              ? Rabbit.uni2zg('လက်ခံပါသည် (Accept)')
                              : 'လက်ခံပါသည် (Accept)',
                          // 'လက်ခံပါသည် (Accept)',
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
