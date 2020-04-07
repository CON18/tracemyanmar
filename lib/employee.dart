class Employee{
  int id;
  var location;
  var time;
  var rid;
  var color;
  var remark;

  Employee(this.id,this.location,this.time,this.rid,this.color,this.remark);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id' : id,
      'location' : location,
      'time' : time,
      'rid' : rid,
      'color' : color,
      'remark': remark
    };
    return map;
  }

  Employee.fromMap(Map<String, dynamic> map){
    id = map['id'];
    location = map['location'];
    time = map['time'];
    rid = map['rid'];
    color = map['color'];
    remark = map['remark'];
  }
}