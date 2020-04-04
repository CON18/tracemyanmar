import 'dart:convert';

import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateLocationPage extends StatefulWidget {
  @override
  _UpdateLocationPageState createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
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

  @override
  void initState() {
    super.initState();
    divisionamount = divisionList[0];
    districtamount = districtList[0];
    townshipamount = townshipList[0];
  }
  snackbarmethod(){
        _scaffoldkey.currentState.showSnackBar(new SnackBar(
          content: new Text(this.alertmsg),
          backgroundColor: Colors.blue.shade400,
          duration: Duration(seconds: 1),
        ));
  }
  update() async {
    String url =
        "http://52.187.13.89:8080/tracemyanmar/module001/serviceRegisterTraceMyanmar/updateRegister";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"phoneNo": "' + "+9599510637" + '", "division":"' + divisionamount + '", "district":"' + districtamount + '", "township":"' + townshipamount + '" }';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = response.body;
      print(body);
      var data = jsonDecode(body);
      setState(() {
        // isLoading = false;
        // contactList = data["cadData"];
        // this.alertmsg = data["desc"];
        // this._method1();
      if (data['code'] == "0000") {
        this.alertmsg=data['desc'];
        this.snackbarmethod();
        Future.delayed(const Duration(milliseconds: 1000), () {
        var route = new MaterialPageRoute(
        builder: (BuildContext context) => new Sqlite(
        ));
        Navigator.of(context).push(route);
        });
      }else{
        this.alertmsg=data['desc'];
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
          'My Location',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: Column(
        key: _formKey,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: new Text("Please Select Division"),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
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
          new Text("Please Select District"),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
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
          new Text("Please Select Township"),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
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
          Divider(
            height:20
          ),
          new RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: ()  async{
              update();
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Container(
              width: 120.0,
              height: 38.0,
              child: Center(
                  // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
                  child: Text("Update",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
