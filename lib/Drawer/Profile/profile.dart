import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String userid;
  final String username;

  Profile({Key key, this.userid,this.username}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final myController = TextEditingController();
  final mynameController = TextEditingController();

  String divisionamount = '';
  String districtamount = '';
  String townshipamount = '';
  String alertmsg = "";
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  List divisionList = [
    "KACHIN",
    "KAYAR",
    "KAYIN",
    "CHIN",
    "SAGAING",
    "TANINTHARYI",
    "BAGO",
    "MAGWE",
    "MANDALAY",
    "MON",
    "RAKHAING",
    "YANGON",
    "SHAN(SOUTH)",
    "SHAN(NORTH)",
    "SHAN(EAST)",
    "AYARWADDY",
    "NAYPYITAW"
  ];
  List districtList = [
    "MYITKYINAR",
    "BAMAW",
    "PUTARO",
    "LOIKAW",
    "BAWLAKAE",
    "PHARAN",
    "KAWKARAIT",
    "MYAWADDI",
    "PHALANN",
    "MINTUP",
    "SAGAING",
    "SHWEBO",
    "MONYWAR",
    "KATHAR",
    "KALAY",
    "KHANTEE",
    "MAWLIKE",
    "TAMU",
    "DAWEI",
    "MYEIK",
    "KAWTHAUNG",
    "BAGO",
    "TAUNGOO",
    "PYAY",
    "THARYARWADDI",
    "MAGWE",
    "MINBU",
    "THAYET",
    "PAKOKKU",
    "GANTGAW",
    "MANDALAY",
    "PYINOOLWIN",
    "KYAUKSAE",
    "MYINCHAN",
    "YAMAETHIN",
    "MEIKHTILAR",
    "NYAUNGOO",
    "MAWLAMYAING",
    "THAHTON",
    "SITTWE",
    "MAUNGTAW",
    "THANTWE",
    "YANGON(EAST)",
    "YANGON(WEST)",
    "YANGON(SOUTH)",
    "YANGON(NORTH)",
    "TAUNGGYI",
    "LOILIN",
    "LASHIO",
    "KYAUKMAE",
    "KUNLON",
    "MUSE",
    "LAUKKAING",
    "KYAITONE",
    "MINESAT",
    "MINEPYAT",
    "TACHILEIK",
    "PATHEIN",
    "HINTHARDA",
    "MYAUNGMYA",
    "MAAUPIN",
    "PYARPONE",
    "NAYPYITAW"
  ];
  List townshipList = [
    "MYITKYINAR",
    "WINEMAW",
    "INGANYAN",
    "MOEKAUNG",
    "MOENYIN",
    "PHARKANT",
    "TANAING",
    "CHIVWEY",
    "SAWTLAW",
    "BAMAW",
    "SHWEKU",
    "MOEMAUTH",
    "MANSI",
    "PUTARO",
    "SONPRABON",
    "MACHANBAW",
    "KAUNGLANPHU",
    "NAUNGMOON",
    "LOIKAW",
    "DIMAWSO",
    "PHRUSO",
    "SHARTAW",
    "BAWLAKAE",
    "PHARSAUNG",
    "MAESAE",
    "PHARAN",
    "HLAINGBWE",
    "PHARPUN",
    "THANTAUNG",
    "KAWKARAIT",
    "KYARINNSEIKGYI",
    "MYAWADDI",
    "HARKHAR",
    "PHALANN",
    "HTANTALAN",
    "TEETAIN",
    "TUNZAN",
    "MINTUP",
    "MATUPI",
    "KANPALAT",
    "PALATWA",
    "SAGAING",
    "MYINMU",
    "MYAUNG",
    "SHWEBO",
    "KHINOO",
    "WETLAT",
    "KANTBALU",
    "KYUNHLA",
    "YAEOO",
    "DIPEYIN",
    "TANTSAE",
    "MONYWAR",
    "BUTALIN",
    "AHYARTAW",
    "CHAUNGOO",
    "YINMARPIN",
    "KANI",
    "SARLINGYI",
    "PEARL",
    "KATHAR",
    "INNTAW",
    "HTEECHAINT",
    "BANMOUTH",
    "KAWLIN",
    "WUNTHYO",
    "PINLAEBU",
    "KALAY",
    "KALAYWA",
    "MINKIN",
    "KHANTEE",
    "HONMALIN",
    "LAHAE",
    "NANYUN",
    "MAWLIKE",
    "PHAUNGPYIN",
    "TAMU",
    "DAWEI",
    "LAUNGLON",
    "THAYETCHAUNG",
    "YAYPHYU",
    "MYEIK",
    "KYUNSU",
    "PULAW",
    "TANINTHARYI",
    "KAWTHAUNG",
    "BOTEPYIN",
    "BAGO",
    "THANUTPIN",
    "KAWA",
    "WAW",
    "NYAUNGLAYPIN",
    "KYAUKTAKHAR",
    "DIKEOO",
    "SHWEKYIN",
    "TAUNGOO",
    "YAYTARSHAE",
    "KYAUKGYI",
    "PHYU",
    "OAKTWIN",
    "HTANTAPIN",
    "PYAY",
    "PAUKKHAUNG",
    "PANTAUNG",
    "PAUNGTAE",
    "THAEKONE",
    "SHWETAUNG",
    "THAYARWADDI",
    "LATPADAN",
    "MINHLA",
    "OAKPHO",
    "ZEEKONE",
    "NATTALIN",
    "MOENYO",
    "KYOTPINKAUK",
    "MAGWE",
    "YAYNANCHAUNG",
    "CHAUK",
    "TAUNGTWINGYI",
    "MYOTHIT",
    "NATMAUK",
    "MINBU",
    "PWINTPHYU",
    "NGAPHAE",
    "SALIN",
    "SAYTOTETAYAR",
    "THAYET",
    "MINHLA",
    "MINTONE",
    'KANMA',
    "AUNGLAN",
    "SINPAUNGWAE",
    "PAKOKKU",
    "YAYSAKYO",
    "MYAING",
    "PAUK",
    "SEIKPHYU",
    "SAW",
    "GANTGAW",
    "HTEELIN",
    "CHANMYATHARSI",
    "AUNGMYAYTHARZAN",
    "MAHARAUNGMYAY",
    "CHANAYETHARZAN",
    "PYAYGYITAGON",
    "AHMAYAPURA",
    "PATHEINGYI",
    "PYINOOLWIN",
    "MATAYAR",
    "SINTKU",
    "MOEGYOKE",
    "THAPATEKYIN",
    "KYAUKSAE",
    "SINTKAING",
    "MYITTHAR",
    "TATAROO",
    "MYINCHAN",
    "TAUNGTHAR",
    "NWARHTOGYI",
    "KYAUKPATAUNG",
    "NYANZUN",
    "YAMAETHIN",
    "PYAWBWE",
    "TUPKONE",
    "PYINMANAR",
    "LAEWAY",
    "MEIKHTILAR",
    "MAHLAING",
    "THARSI",
    "WANTWIN",
    "NYAUNGOO",
    "MAWLAMYAING",
    "KYAIKMAYAW",
    "CHAUNGSON",
    "THANPHYUZAYAT",
    "MUDON",
    "YAY",
    "THAHTON",
    "PAUNG",
    "KYEIKEHTO",
    "BEELIN",
    "SITTWE",
    "PONNARKYUN",
    "PAUKTAW",
    "MYAYPONE",
    "KYAUKTAW",
    "MYAUKOO",
    "MINPYAR",
    "YATHAYTAUNG",
    "MAUNGTAW",
    "BUTHEETAUNG",
    "KYAUKPHYU",
    "KYAUKPHYU",
    "YANBYAE",
    "MANAUNG",
    "ANN",
    "THANTWE",
    "TAUNGKOTE",
    "GWA",
    "THINGANGYUN",
    "MINGALARTAUNGNYUNT",
    "TAMWE",
    "SOUTHOKKALARPA",
    "NORTHOKKALARPA",
    "PAZUNTAUNG",
    "DAWPONE",
    "BOTATAUNG",
    "YANKIN",
    "THARKAYTA",
    "DAGON(SOUTH)",
    "DAGON(NORTH)",
    "DAGON(SEIKKAN)",
    "DAGON(EAST)",
    "MAYANGONE",
    "HLAING",
    "KAMAYUT",
    "KYIMYINDAING",
    "SANCHAUNG",
    "AHLONE",
    "BAHAN",
    "DAGON",
    "LANMADAW",
    "LATHA",
    "PABEDAN",
    "KYAUKTATAR",
    "SEIKKAN",
    "THANLYIN",
    "KHAYAN",
    "THONEGWA",
    "KYAUKTAN",
    "KAWTMU",
    "KWUNCHANKONE",
    "TWUNTAY",
    "DALA",
    "SEIKKYIKHANAUNGTO",
    "KOKOKYUN",
    "INSEIN",
    "MINGALARDON",
    "TIKEKYI",
    "HTANTAPIN",
    "MAWBI",
    "HLEGU",
    "SHWEPYITHAR",
    "HLAINGTHARYAR",
    "TAUNGGYI",
    "HOPONE",
    "NYAUNGSHW",
    "SISAING",
    "KALAW",
    "PINTAYA",
    "YWARNYAN",
    "YATSAUT",
    "PINLAUNG",
    "PAEKHONE",
    "LOILIN",
    "LAECHAR",
    "NANTSAN(SOUTH)",
    "MOENAE",
    "KUNHEIN",
    "LINKHAY",
    "MAUTMAE",
    "MINEPAN",
    "KYAYTHEE",
    "MINEKAING",
    "MINESHOE",
    "LASHIO",
    "THEINNI",
    "TANTYAN",
    "MINEYE",
    "MANPHANT",
    "PANYAN",
    "NARPHAN",
    "PANWINE",
    "MINEMAW",
    "KYAUKMAE",
    "NAUNGCHO",
    "THIPAW",
    "NANMATU",
    "MANTONE",
    "NANTSAN(NORTH)",
    "MOEMATE",
    "MABAIN",
    "KUNLOAN",
    "HOPAN",
    "MUSE",
    "KUTKAI",
    "NANTKHAM",
    "LAUKKAING",
    "KONEKYAN",
    "KYINETONE",
    "MINEYAN",
    "MINEKHAT",
    "MINESAT",
    "MINETONE",
    "MINEPYIN",
    "MINEPHYAT",
    "MINEYAUNG",
    "TACHILEIK",
    "PATHEIN",
    "KANGYIDAUN",
    "THARPAUNG",
    "NGAPUTAW",
    "KYONEPYAW",
    "YAYKYI",
    "KYAUNGKONE",
    "HINTHARDA",
    "ZALON",
    "LAYMYATNYAR",
    "MYANAUNG",
    "KYANKHIN",
    "INGAPU",
    "MYAUNGMYA",
    "EINMAE",
    "LATTPUTTAR",
    "WARKHAEMA",
    "MAWLAMYAINGKYUN",
    "MAAUPIN",
    "PANTANAW",
    "NYAUNGTONE",
    "DANUPHYU",
    "PYARPONE",
    "BOKALAY",
    "KYAIKLATT",
    "DAYDAYE",
    "PYINMANA",
    "LEWE",
    "TATKONE",
    "ZABUTHIRI",
    "OUTARATHIRI",
    "POBBATHIRI",
    "DATKHINATHIRI",
    "ZAYARTHIRI",
    "NAYPYITAW",
  ];
  String checklang = '';
  List textMyan = ["ကိုယ်ပိုင်အချက်အလက်","ဖုန်းနံပါတ်","အမည်","တိုင်း/ပြည်နယ် ​ရွှေးချယ်​ပါ","ခရိုင် ​ရွှေးချယ်​ပါ","မြိုနယ် ​ရွှေးချယ်​ပါ","ပြင်ဆင်မည်"];
  List textEng = ["Profile","Phone No","Name","Please Select Division","Please Select District","Please Select Township","Update"];

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
  @override
  void initState() {
    super.initState();
    checkLanguage();
    divisionamount = divisionList[0];
    districtamount = districtList[0];
    townshipamount = townshipList[0];
    myController.text="${widget.userid}";
    mynameController.text="${widget.username}";
    if(myController.text=="null"){
      myController.text="";
    }else{
      myController.text="${widget.userid}";
    }
    if(mynameController.text=="null"){
      mynameController.text="";
    }else{
      mynameController.text="${widget.username}"; 
    }
  }

  snackbarmethod() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blue.shade400,
      duration: Duration(seconds: 1),
    ));
  }
  getstorage() async{
      final prefs = await SharedPreferences.getInstance();
      final key3 = 'UserName';
      final username = mynameController.text;
      prefs.setString(key3, username);
  }
  update() async {
    String url =
        "https://service.mcf.org.mm/tracemyanmar/module001/serviceRegisterTraceMyanmar/updateRegister";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phoneNo": "' +
        "+959951063763" +
        '", "division":"' +
        divisionamount +
        '", "district":"' +
        districtamount +
        '", "township":"' +
        townshipamount +
        '" }';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = response.body;
      print(body);
      var data = jsonDecode(body);
      setState(() {
        if (data['code'] == "0000") {
          this.alertmsg = data['desc'];
          this.snackbarmethod();
          getstorage();
          Future.delayed(const Duration(milliseconds: 1000), () {
            var route = new MaterialPageRoute(
                builder: (BuildContext context) => new Sqlite());
            Navigator.of(context).push(route);
          });
        } else {
          this.alertmsg = data['desc'];
          this.snackbarmethod();
        }
      });
    } else {
      print("Connection Fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          checklang=="Eng" ? textEng[0] :textMyan[0],
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        // leading: new Container(),
      ),
      body: SingleChildScrollView(
        key: _formKey,
        child: new Container(
          height: checklang=="Eng" ? 750:790,
          padding: EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: (Image.asset('assets/user-icon.png',
                              width: 110.0, height: 110.0))),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: Container(
                      child: TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    controller: myController,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                      labelText: checklang=="Eng" ? textEng[1] :textMyan[1],
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(
                          fontSize: 16, color: Colors.black, height: 0),
                      fillColor: Colors.grey,
                    ),
                  )),
                ),
                Divider(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: Container(
                      child: TextFormField(
                    controller: mynameController,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                      labelText: checklang=="Eng" ? textEng[2] :textMyan[2],
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(
                          fontSize: 16, color: Colors.black, height: 0),
                      fillColor: Colors.grey,
                    ),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: new Text(checklang=="Eng" ? textEng[3] :textMyan[3]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                  child: SizedBox(
                    height: 60.0,
                    child: new DropdownButton<String>(
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w300),
                      isExpanded: true,
                      items: divisionList.map((item) {
                        // date1 = item['startdate'];
                        return new DropdownMenuItem(
                          child: Container(
                            width: 200,
                            child: new Text(item),
                          ),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (newvalue) {
                        // startDate.text = date1;
                        divisionamount = newvalue;
                        print("division " + divisionamount);
                        setState(() {});
                      },
                      value: divisionamount.toString(),
                      underline: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 20,
                ),
                new Text(checklang=="Eng" ? textEng[4] :textMyan[4]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                  child: SizedBox(
                    height: 60.0,
                    child: new DropdownButton<String>(
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w300),
                      isExpanded: true,
                      items: districtList.map((item) {
                        // date1 = item['startdate'];
                        return new DropdownMenuItem(
                          child: Container(
                            width: 200,
                            child: new Text(item),
                          ),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (newvalue) {
                        // startDate.text = date1;
                        districtamount = newvalue;
                        print("division " + districtamount);
                        setState(() {});
                      },
                      value: districtamount.toString(),
                      underline: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 20,
                ),
                new Text(checklang=="Eng" ? textEng[5] :textMyan[5]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                  child: SizedBox(
                    height: 60.0,
                    child: new DropdownButton<String>(
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w300),
                      isExpanded: true,
                      items: townshipList.map((item) {
                        // date1 = item['startdate'];
                        return new DropdownMenuItem(
                          child: Container(
                            width: 200,
                            child: new Text(item),
                          ),
                          value: item.toString(),
                        );
                      }).toList(),
                      onChanged: (newvalue) {
                        // startDate.text = date1;
                        townshipamount = newvalue;
                        print("division " + townshipamount);
                        setState(() {});
                      },
                      value: townshipamount.toString(),
                      underline: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(height: 20),
                new RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () async {
                    update();
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Container(
                    width: 120.0,
                    height: 38.0,
                    child: Center(
                        // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
                        child: Text(checklang=="Eng" ? textEng[6] :textMyan[6],
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                      ))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
