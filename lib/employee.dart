class Employee{
  int id;
  var location;
  var time;
  var rid;
  var color;

  Employee(this.id,this.location,this.time,this.rid,this.color);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id' : id,
      'location' : location,
      'time' : time,
      'rid' : rid,
      'color' : color,
    };
    return map;
  }

  Employee.fromMap(Map<String, dynamic> map){
    id = map['id'];
    location = map['location'];
    time = map['time'];
    rid = map['rid'];
    color = map['color'];
  }
}