import 'package:flutter/material.dart';

class Reposting extends StatefulWidget {

  final int value;
   Reposting(
      {Key key,
      this.value,})
      : super(key: key);

  @override
  _RepostingState createState() => _RepostingState();
}

class _RepostingState extends State<Reposting> {


 final TextEditingController _text1 = new TextEditingController();
 final TextEditingController _text2 = new TextEditingController();
 final TextEditingController _text3 = new TextEditingController();
 bool v1 = false;
bool v2 = false;
bool v3 = false;
bool vv = false;
String v4="null";

  final _formKey = new GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
     String alertmsg = "";
  @override
  void initState() {
    super.initState();
  }
   void _method1() {
    print("Snack Bar");
    print(this.alertmsg);
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg),backgroundColor: Colors.blueAccent, duration: Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
     _text1.text = "${widget.value}";
    
    // return Container(
    //   child: Text("${widget.value}"),
    // );
  // final style = TextStyle(
  //       fontFamily: 'Montserrat', fontSize: 19.0, color: Colors.black);

  // final totalMark = new Container(
  //       child: Column(children: <Widget>[
  //     ListTile(
  //       title: Padding(
  //         padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
  //         child: Text("Total Mark"),
  //       ),
  //       subtitle: Padding(
  //         padding: const EdgeInsets.all(5.0),
  //         child: Text(
  //           "${widget.value}",
  //           style: style,
  //         ),
  //       ),
  //     ),
  //     Divider(
  //       color: Colors.black,
  //     )
  //   ]));
    final totalMark = new TextField(
          controller: _text1,
          decoration: InputDecoration(
              labelText: "Total Mark",
              enabled: false,
              ),
        );
  final location = new TextField(
          controller: _text2,
          decoration: InputDecoration(
              labelText: "Location",
              ),
        );
        final phonenumber = new TextField(
          controller: _text3,
          decoration: InputDecoration(
              labelText: "Phone Number",
              ),
        );
        // final question = new TextField(
        //   controller: _text4,
        //   decoration: InputDecoration(
        //       labelText: "Question",
        //       ),
        // );
  // final phonenumber = new Container(
  //       child: Column(children: <Widget>[
  //     ListTile(
  //       title: Padding(
  //         padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
  //         child: Text("Total Mark"),
  //       ),
  //       subtitle: Padding(
  //         padding: const EdgeInsets.all(5.0),
  //         child: Text(
  //           "${widget.value}",
  //           style: style,
  //         ),
  //       ),
  //     ),
  //     Divider(
  //       color: Colors.black,
  //     )
  //   ]));
  final question = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Text("Have you tested positive for COVID-19?"),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(children: <Widget>[
            Text("Yes"),
            Checkbox(
                value: v1,
                onChanged: (bool value) {
                    setState(() {
                        v1 = value;
                        v2 = vv;
                        v3 = vv;
                    });
                },
            ),
            Text("No"),
            Checkbox(
                value: v2,
                onChanged: (bool value) {
                    setState(() {
                        v2 = value;
                        v1 = vv;
                        v3 = vv;
                    });
                },
            ),
            Text("Pending"),
            Checkbox(
                value: v3,
                onChanged: (bool value) {
                    setState(() {
                        v3 = value;
                        v1 = vv;
                        v2 = vv;
                    });
                },
            ),
          ],)
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

  final cancelbutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () async {
        this.alertmsg = '';
        Navigator.pop(context);
      },
      color: Colors.grey[300],
      textColor: Colors.white,
      child: Container(
        width: 120.0,
        height: 38.0,
        child: Center(
            // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
            child: Text("Cancel",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );
    final reportbutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () async {
        Navigator.pop(context);
        print(_text1.text);
        print(_text2.text);
        print(_text3.text);
        if(v1==true){
          setState(() {
            v4="True";
          });
        }else if(v2==true){
          setState(() {
            v4="False";
          });
        }else if(v3==true){
          v4="Pending";
        }
        print(v4);
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Container(
        width: 120.0,
        height: 38.0,
        child: Center(
            // child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
            child: Text("Report",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );

    // final reportbutton = new RaisedButton(
    //   color: Colors.blue,
      // onPressed: () async{
      //   setState(() {
      //     if(amount1==null){
      //  _scaffoldkey.currentState.showSnackBar(new SnackBar(
      //   content: new Text("Please Select month"),backgroundColor: Colors.red, duration: Duration(seconds: 1)));
      //     }else{
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => skynetConfirmPage(
        //           value: "${widget.value}",
        //           value1: '$package',
        //           value2: '$type1',
        //           value3: '$amount1',
        //           value4: '$charge',
        //           value5: '$total',
        //           value6: '$contactList1')),
        // );
        //   }
        // });

      // },
      // color: Color.fromRGBO(40, 103, 178, 1),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(5.0),
      // ),
      // textColor: Colors.white,
    //   child: Container(
    //     width: 120.0,
    //     height: 38.0,
    //     color: Colors.blue,
    //     child: Center(
    //         // child: Text(checklang == "Eng" ? textEng[8] : textMyan[8],
    //         child: Text("Report Submit",
    //             style: TextStyle(
    //               fontSize: 17,
    //               color: Colors.white,
    //               fontWeight: FontWeight.w300,
    //             ))),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Reporting",style: TextStyle(fontWeight: FontWeight.w300),),
      ),
      // body: Container(
      //   padding: EdgeInsets.all(15.0),
      //   child: Column(
      //     children: <Widget>[
      //       Row(children: <Widget>[
      //         Text("Total Mark:"),
      //         Text("${widget.value}"),
      //       ],),
            
      //     ],
      //   ),
      // ),
      body: new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 5.0),
              height: 380,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: ListView(
                  padding: EdgeInsets.all(2.0),
                  children: <Widget>[
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: totalMark,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: location,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: phonenumber,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: question,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(left: 26.0),
                          child: cancelbutton,
                        ),
                        new Container(
                          padding: EdgeInsets.only(left: 26.0),
                          child: reportbutton,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}