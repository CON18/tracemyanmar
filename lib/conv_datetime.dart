import 'package:intl/intl.dart';

convertDateTime() {
  DateTime now = DateTime.now();
  var yr = DateFormat.y().format(now);
  var mn = DateFormat.M().format(now);
  if (mn.length == 1) {
    mn = "0" + mn;
  }
  var dy = DateFormat.d().format(now);
  if (dy.length == 1) {
    dy = "0" + dy;
  }
  // var time = new DateFormat.jm().format(now);
  var time = new DateFormat.Hms().format(now);
  var dt = yr + "-" + mn + "-" + dy + "T" + time;
  return dt;
}
