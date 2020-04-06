import 'package:TraceMyanmar/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String checklang = '';
  List textMyan = ["ဘာသာစကားပြင်​​ရန်", "English", "မြန်မာ​"];
  List textEng = ["Language Setting", "English", "Myanmar"];

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

  @override
  void initState() {
    super.initState();
    checkLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        centerTitle: true,
        title: Text(
          checklang == "Eng" ? textEng[0] : textMyan[0],
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          ListTile(
            title: Text(checklang == "Eng" ? textEng[1] : textMyan[1],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w300)),
            trailing:
                Container(width: 60, child: Image.asset('assets/eng.png')),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              checklang = "Eng";
              prefs.setString("Lang", checklang);
              setState(() {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Sqlite()));
              });
              print(prefs.getString("Lang"));
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(height: 5),
          ListTile(
            title: Text(checklang == "Eng" ? textEng[2] : textMyan[2],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w300)),
            trailing:
                Container(width: 65, child: Image.asset('assets/myan.png')),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              checklang = "Myan";
              prefs.setString("Lang", checklang);
              setState(() {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Sqlite()));
              });
              print(prefs.getString("Lang"));
            },
          ),
          Divider(
            color: Colors.grey,
          ),
        ]),
      ),
    );
  }
}
