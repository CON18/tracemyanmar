import 'package:flutter/material.dart';

class FleetDetail extends StatefulWidget {
  final String phoneno;
  final String fleepno;
  final String depaturedatetime;
  final String fromLocation;
  final String arrivaldatetime;
  final String tolocation;
  final String remark;

  FleetDetail(
      {Key key,
      this.phoneno,
      this.fleepno,
      this.depaturedatetime,
      this.fromLocation,
      this.arrivaldatetime,
      this.tolocation,
      this.remark})
      : super(key: key);
  @override
  _FleetDetailState createState() => _FleetDetailState();
}

class _FleetDetailState extends State<FleetDetail> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _text1 = new TextEditingController();
  final TextEditingController _text2 = new TextEditingController();
  final TextEditingController _text3 = new TextEditingController();
  final TextEditingController _text4 = new TextEditingController();
  final TextEditingController _text5 = new TextEditingController();
  final TextEditingController _text6 = new TextEditingController();
  final TextEditingController _text7 = new TextEditingController();
  final TextEditingController _text8 = new TextEditingController();
  var date_1="";
  var date_2="";
  var date1="";
  var time1="";
  var date2="";
  var time2="";
  var index1;
  var index2;
  var index3;


  @override
  void initState() {
    super.initState();
    _text1.text=widget.fleepno;
    _text2.text=widget.depaturedatetime;
    _text3.text=widget.fromLocation;
    _text4.text=widget.arrivaldatetime;
    _text5.text=widget.tolocation;
    _text6.text=widget.remark;
    
    setState(() {
      date_1=_text2.text;
      index1 = date_1.toString().indexOf('|');
      date1=date_1.toString().substring(0,index1);
      time1=date_1.toString().substring(index1+1);
      date_2=_text4.text;
      index2 = date_2.toString().indexOf('|');
      date2=date_2.toString().substring(0,index2);
      time2=date_2.toString().substring(index2+1);
      index3 = _text1.text.toString().indexOf('|');
      if(index3 == -1){
        _text7.text=_text1.text.toString();
        _text8.text=" ";
      }else{
        _text7.text=_text1.text.toString().substring(0,index3);
        _text8.text=_text1.text.toString().substring(index3+1);
      }
    });
    

  }

  @override
  Widget build(BuildContext context) {

    final fleetno = new TextField(
      controller: _text7,
      decoration: InputDecoration(
          labelText: "ID:",
          ),
      readOnly: true,
    );
    final type = new TextField(
      controller: _text8,
      decoration: InputDecoration(
          labelText: "Type:",
          ),
      readOnly: true,
    );
    final depaturedatetime = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text("Departure Date Time:"),
                SizedBox(
                  height: 10,
                ),
                Container(
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                      //   DatePicker.showDatePicker(context,
                      //       theme: DatePickerTheme(
                      //         containerHeight: 210.0,
                      //       ),
                      //       showTitleActions: true,
                      //       minTime: DateTime(2000, 1, 1),
                      //       maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                      //     print('confirm $date');
                      //     _date1 = '${date.year} - ${date.month} - ${date.day}';
                      //     setState(() {});
                      //   }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$date1",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        // DatePicker.showTimePicker(context,
                        //     theme: DatePickerTheme(
                        //       containerHeight: 210.0,
                        //     ),
                        //     showTitleActions: true, onConfirm: (time) {
                        //   print('confirm $time');
                        //   _time1 = '${time.hour} : ${time.minute} : ${time.second}';
                        //   setState(() {});
                        // }, currentTime: DateTime.now(), locale: LocaleType.en);
                        // setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$time1",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    )
                  ],
                ),
              )
              ],);
    final fromLocation = new TextField(
      controller: _text3,
      decoration: InputDecoration(
          labelText: "From:",
          ),
      readOnly: true,
    );

    final arrivaldatetime = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text("Arrival Date Time:"),
                SizedBox(
                  height: 10,
                ),
                Container(
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                      //   DatePicker.showDatePicker(context,
                      //       theme: DatePickerTheme(
                      //         containerHeight: 210.0,
                      //       ),
                      //       showTitleActions: true,
                      //       minTime: DateTime(2000, 1, 1),
                      //       maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                      //     print('confirm $date');
                      //     _date1 = '${date.year} - ${date.month} - ${date.day}';
                      //     setState(() {});
                      //   }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$date2",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        // DatePicker.showTimePicker(context,
                        //     theme: DatePickerTheme(
                        //       containerHeight: 210.0,
                        //     ),
                        //     showTitleActions: true, onConfirm: (time) {
                        //   print('confirm $time');
                        //   _time1 = '${time.hour} : ${time.minute} : ${time.second}';
                        //   setState(() {});
                        // }, currentTime: DateTime.now(), locale: LocaleType.en);
                        // setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  // color: Colors.blue,
                                ),
                                Text(
                                  "$time2",
                                  style: TextStyle(
                                      // color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    )
                  ],
                ),
              )
              ],);

    final tolocation = new TextField(
      controller: _text5,
      decoration: InputDecoration(
          labelText: "To:",
          ),
      readOnly: true,
    );
    final remark = new TextField(
      controller: _text6,
      decoration: InputDecoration(
          labelText: "Remark:",
          ),
      readOnly: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("ID : ${_text7.text}",style: TextStyle(fontWeight: FontWeight.w300),),
        centerTitle: true,
      ),
      
      body: new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.only(left: 10,top:5,right: 10),
              // height: 380,
              height: MediaQuery.of(context).size.height*0.89,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: fleetno,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: type,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 20),
                      child: depaturedatetime,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: fromLocation,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 20),
                      child: arrivaldatetime,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: tolocation,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: remark,
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